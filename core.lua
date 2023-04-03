t = 0
map = {
    {x=1,  y=0,  c=corner.TOP},
    {x=1,  y=3,  c=corner.BL},
    {x=3,  y=3,  c=corner.BR},
    {x=3,  y=1,  c=corner.TL},
    {x=7,  y=1,  c=corner.TR},
    {x=7,  y=3,  c=corner.BL},
    {x=9,  y=3,  c=corner.TR},
    {x=9,  y=5,  c=corner.BR},
    {x=8,  y=5,  c=corner.TL},
    {x=8,  y=7,  c=corner.BR},
    {x=5,  y=7,  c=corner.BL},
    {x=5,  y=5,  c=corner.TR},
    {x=2,  y=5,  c=corner.TL},
    {x=2,  y=7,  c=corner.BR},
    {x=1,  y=7,  c=corner.TL},
    {x=1,  y=9,  c=corner.BL},
    {x=9,  y=9,  c=corner.TR},
    {x=9,  y=10, c=corner.BOT},
}
path_points = {}
enemies = {}
towers = {}
wave = 1
sending = 0 -- number of enemies to send this wave
gold = 50
lives = 20

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function _init()
    poke(0x5f5c, 9) -- button repeat delay
    poke(0x5f5d, 3) -- button repeat interval

    -- Set up auxiliary data structures
    init_selection()
    init_path_points()

    -- Initialize buy/upgrade/bonus menu
    init_menus()

    -- Make towers
    make_tower(TWR.red, 2, 4)
    make_tower(TWR.red, 3, 4)
    make_tower(TWR.red, 4, 4)
end

function do_buy(menu)
    local g = p2g(sel.dst_x, sel.dst_y)
    make_tower(menu.sel_twr, g.x, g.y)
end

function do_sell(menu)
    local twr = tbl_find(towers, twr_is_selected)
    del(towers, twr)
end

function do_upgrade(menu)
    local twr = tbl_find(towers, twr_is_selected)
    local g = p2g(sel.dst_x, sel.dst_y)
    make_tower(twr.type+3, g.x, g.y)
    del(towers, twr)
end

-- Helps impl of enemy movement
function init_path_points()
    for i = 1, #map do
        local p = g2p(map[i])
        add(path_points, {
            x = p.left + 6,
            y = p.top + 6,
        })
    end
end

function make_enemy(hp)
    add(enemies, {
        x=path_points[1].x,
        y=path_points[1].y,
        dx=0, dy=0.5,
        hp=hp, max_hp=hp,
        can_remove=false,
    })
end

function make_tower(type, x, y)
    add(towers, {
        type=type,
        x=x, y=y, -- in grid coordinates
        range=28,
        bullets={},
        cd=0, -- in frames
        dmg=2,
    })
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------
function _update60()
    t += 1
    -- Make enemy
    if sending > 0 and t%20 == 0 then
        local hp = 3*wave
        make_enemy(hp)
        sending -= 1
    end
    update_selection()

    buy_menu:update()
    upg_menu:update()

    -- Handle button press
    if buy_menu.is_open then
        buy_menu:handle_btn()
    elseif upg_menu.is_open then
        upg_menu:handle_btn()
    else
        if btnp(B.z) then
            local twr = tbl_find(towers, twr_is_selected)
            if twr then
                upg_menu:open()
            else
                buy_menu:open()
            end
        end
        if btnp(B.x) then
            if sending == 0 then
                -- Send next wave
                wave += 1
                sending = 10
            end
        end
    end

    -- Move enemies
    foreach(enemies, move_enemy)

    -- Move bullets
    foreach(towers, function(twr)
        foreach(twr.bullets, function(blt)
            -- update particles
            for p in all(blt.particles) do
                p.age += 1
                if p.age > 3 then
                    del(blt.particles, p)
                end
            end

            local enmy = blt.enemy
            local oldx, oldy = blt.x, blt.y
            local dx = enmy.x - blt.x
            local dy = enmy.y - blt.y
            blt.rotation = atan2(dx, dy)
            -- update bullet position
            blt.x = blt.x + cos(blt.rotation)*1
            blt.y = blt.y + sin(blt.rotation)*1

            -- handle collision
            if collide(blt, enmy) then
                enmy.hp = max(0, enmy.hp-twr.dmg)
                blt.can_remove = true
            else
                -- add particle
                if t%2 == 0 then
                    add(blt.particles, {x=oldx, y=oldy, age=1})
                end
            end
        end)
        -- remove bullets
        twr.bullets = tbl_filter(twr.bullets, function(blt)
            return not blt.can_remove
        end)
    end)
    -- Fire bullets
    foreach(towers, function(twr)
        twr.cd = max(0, twr.cd-1)
        if twr.cd > 0 then return end
        for enmy in all(enemies) do
            if is_in_range(enmy, twr) then
                -- Todo: what happens when enemy dies from another bullet?
                -- perhaps we keep enemy objects around with a 'dead' flag until
                -- all of them are dead?
                local p = g2p(twr)
                add(twr.bullets, {
                    x=p.left+6, y=p.top+6,
                    rotation=0,
                    enemy=enmy,
                    particles={},
                })
                twr.cd = 40
                break
            end
        end
    end)
    -- Remove enemies
    enemies = tbl_filter(enemies, function(enmy)
        return not enmy.can_remove and enmy.hp > 0
    end)
end

function collide(blt, enmy)
    return blt.x > enmy.x-1 and blt.x < enmy.x+1
       and blt.y > enmy.y-1 and blt.y < enmy.y+1
end

function line_contains_point(l1, l2, p)
    local is_vert = l1.x == l2.x
    if is_vert then
        return p.x == l1.x
            and p.y >= min(l1.y, l2.y)
            and p.y <= max(l1.y, l2.y)
    else
        return p.y == l1.y
            and p.x >= min(l1.x, l2.x)
            and p.x <= max(l1.x, l2.x)
    end
end

function move_enemy(e)
    -- Find the first line in the map that contains our position
    local l1, l2
    local p = 2
    while p <= #path_points do
        if line_contains_point(path_points[p-1], path_points[p], e) then
            l1 = path_points[p-1]
            l2 = path_points[p]
            break
        end
        p += 1
    end
    assert(l1) -- enemy should always be on the path

    if e.dx ~= 0 then -- moving horizontally
        local right = e.dx > 0
        local edge_x = right and max(l1.x, l2.x) or min(l1.x, l2.x)
        local overflow = right and ((e.x + e.dx) - edge_x)
                                or (edge_x - (e.x + e.dx))
        -- If the new position would go out of bounds on the path, split the
        -- travel distance into horizontal and vertical movement.
        if overflow > 0 then
            e.x = edge_x
            if path_points[p+1] then
                local going_down = path_points[p+1].y > path_points[p].y
                e.y = e.y + (going_down and overflow or -overflow)
                -- update direction
                e.dy = going_down and abs(e.dx) or -abs(e.dx)
                e.dx = 0
            else
                e.can_remove = true
            end
        else
            e.x += e.dx
        end
    elseif e.dy ~= 0 then -- moving vertically
        local down = e.dy > 0
        local edge_y = down and max(l1.y, l2.y) or min(l1.y, l2.y)
        local overflow = down and ((e.y + e.dy) - edge_y)
                               or (edge_y - (e.y + e.dy))
        if overflow > 0 then
            e.y = edge_y
            if path_points[p+1] then
                local going_right = path_points[p+1].x > path_points[p].x
                e.x = e.x + (going_right and overflow or -overflow)
                -- update direction
                e.dx = going_right and abs(e.dy) or -abs(e.dy)
                e.dy = 0
            else
                e.can_remove = true
            end
        else
            e.y += e.dy
        end
    end
end

-- Todo: perf
function is_in_range(enmy, twr)
    return (((enmy.x - twr.x*10)^2) + ((enmy.y - twr.y*10)^2)) < (twr.range^2)
end

function twr_is_selected(twr)
    local g = p2g(sel.dst_x, sel.dst_y)
    return twr.x == g.x and twr.y == g.y
end

--------------------------------------------------------------------------------
-- DRAW
--------------------------------------------------------------------------------
function _draw()
    cls(C.black)

    -- Draw grid lines
    for y = 10, 127, 12 do line(0, y, 127, y, C.dark_blue) end
    for x = 10, 127, 12 do line(x, 0, x, 127, C.dark_blue) end

    -- Draw path
    for i = 2, #map do
        local cell_a, cell_b = map[i-1], map[i]
        local ca = get_cell_corner(cell_a)
        local cb = get_cell_corner(cell_b)
        rectfill(ca.x, ca.y, cb.x, cb.y, C.black)
        rect(ca.x, ca.y, cb.x, cb.y, C.indigo)

        -- cover up unwanted borders
        local a = g2p(cell_a)
        if cell_a.c == corner.BL then
            line(a.right, a.bot-1, a.right, a.top+1, C.black)
        elseif cell_a.c == corner.BR then
            line(a.left+1, a.top, a.right-1, a.top, C.black)
        elseif cell_a.c == corner.TL then
            line(a.left+1, a.bot, a.right-1, a.bot, C.black)
        elseif cell_a.c == corner.TR then
            line(a.left, a.bot-1, a.left, a.top+1, C.black)
        end

        -- draw path decoration
        for j = 1, #map, #map-1 do
            local c = map[j].c
            local spr_x = (c == corner.TOP or c == corner.BOT) and 80 or 96
            local flip_x = c == corner.RIGHT
            local flip_y = c == corner.BOT
            local p = g2p(map[j])
            local top = mid(0, p.top, 116)
            local left = mid(0, p.left, 117)
            sspr(spr_x, 0, 12, 12, left, top, 12, 12, flip_x, flip_y)
        end
    end

    foreach(towers, function(twr)
        -- Draw tower
        local p = g2p(twr)
        spr(twr.type, p.left+3, p.top+3)
        -- if twr_is_selected(twr) then -- draw range
        --     circ(p.left+4, p.top+4, twr.range, C.light_gray)
        -- end

        -- Draw bullets
        for blt in all(twr.bullets) do
            pset(blt.x, blt.y, C.red)
            -- Draw particles
            for part in all(blt.particles) do
                pset(part.x, part.y, C.dark_purple)
            end
        end
    end)

    foreach(enemies, function(enmy)
        -- Draw enemy
        circ(enmy.x, enmy.y, 1, C.light_gray)
        -- Draw hp
        local hp_y = enmy.y - 4
        rect(enmy.x-1, hp_y, enmy.x+1, hp_y, C.dark_green)
        if enmy.hp > 0 then
            local hp_rem = ceil(enmy.hp / enmy.max_hp*3)
            rect(enmy.x-1, hp_y, (enmy.x-1)+hp_rem-1, hp_y, C.green)
        end
    end)

    draw_selection()

    -- Draw menus
    buy_menu:draw()
    upg_menu:draw()

    -- Draw stats
    do
        local lives = tostr(lives)
        local x = 127 - #lives*4
        local y = 2
        print(lives, x, y, C.light_gray)
        x -= 9
        spr(18, x, y)

        local gold = tostr(gold)
        x -= 3 + #gold*4
        print(gold, x, y, C.light_gray)
        x -= 7
        spr(17, x, y)
    end


    -- if sending == 0 then
    --     local c = (t%4 == 0 or (t-1)%4 == 0) and C.pink or C.orange
    --     print('❎ send wave', 22, 1, c)
    -- end
    color(C.red)
end

function get_cell_corner(grid_cell)
    local cell = g2p(grid_cell)
    local c = grid_cell.c
    if c == corner.TOP   then return {x = cell.left,  y = cell.top} end
    if c == corner.RIGHT then return {x = cell.right, y = cell.top} end
    if c == corner.BOT   then return {x = cell.right, y = cell.bot} end
    if c == corner.TL    then return {x = cell.left,  y = cell.bot} end
    if c == corner.BL    then return {x = cell.right, y = cell.bot} end
    if c == corner.BR    then return {x = cell.right, y = cell.top} end
    if c == corner.TR    then return {x = cell.left,  y = cell.top} end
end
