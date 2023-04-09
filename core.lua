t = 0
map = {
    {x=1,  y=0,  c=CRNR.top},
    {x=1,  y=3,  c=CRNR.bl},
    {x=3,  y=3,  c=CRNR.br},
    {x=3,  y=1,  c=CRNR.tl},
    {x=7,  y=1,  c=CRNR.tr},
    {x=7,  y=3,  c=CRNR.bl},
    {x=9,  y=3,  c=CRNR.tr},
    {x=9,  y=5,  c=CRNR.br},
    {x=8,  y=5,  c=CRNR.tl},
    {x=8,  y=7,  c=CRNR.br},
    {x=5,  y=7,  c=CRNR.bl},
    {x=5,  y=5,  c=CRNR.tr},
    {x=2,  y=5,  c=CRNR.tl},
    {x=2,  y=7,  c=CRNR.br},
    {x=1,  y=7,  c=CRNR.tl},
    {x=1,  y=9,  c=CRNR.bl},
    {x=9,  y=9,  c=CRNR.tr},
    {x=9,  y=10, c=CRNR.bot},
}
towers = {}
wave = 1
sending = 0
gold = 50
lives = 20

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function _init()
    poke(0x5f5c, 9) -- button repeat delay
    poke(0x5f5d, 3) -- button repeat interval

    -- Set up auxiliary data structures
    init_selection_aux()
    init_enemy_aux()

    -- Set up buy/upgrade/bonus menu
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

function make_tower(type, x, y)
    add(towers, {
        type=type,
        x=x, y=y, -- in grid coordinates
        range=30,
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

    buy_menu:update()
    upg_menu:update()

    update_enemies()

    -- Move bullets
    foreach(towers, function(twr)
        foreach(twr.bullets, function(blt)
            local enmy = blt.enemy
            if enmy.hp == 0 then
                del(twr.bullets, blt)
                return
            end

            -- update particles
            for p in all(blt.particles) do
                p.age += 1
                if p.age > 3 then
                    del(blt.particles, p)
                end
            end

            local oldx, oldy = blt.x, blt.y

            -- update bullet position
            local dx = enmy.x - blt.x
            local dy = enmy.y - blt.y
            blt.rotation = atan2(dx, dy)
            blt.x = blt.x + cos(blt.rotation)*1
            blt.y = blt.y + sin(blt.rotation)*1

            -- handle collision
            if collide(blt, enmy) then
                enmy.hp = max(0, enmy.hp-twr.dmg)
                del(twr.bullets, blt)
            else
                -- add particle
                if t%2 == 0 then
                    add(blt.particles, {x=oldx, y=oldy, age=1})
                end
            end
        end)
    end)

    -- Fire bullets
    foreach(towers, function(twr)
        twr.cd = max(0, twr.cd-1)
        if twr.cd > 0 then return end
        for enmy in all(enemies) do
            if is_in_range(enmy, twr) then
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
end

function collide(blt, enmy)
    return blt.x > enmy.x-1 and blt.x < enmy.x+1
       and blt.y > enmy.y-1 and blt.y < enmy.y+1
end

-- Todo: perf
function is_in_range(enmy, twr)
    return (enmy.x - twr.x*10)^2 + (enmy.y - twr.y*10)^2 < twr.range^2
end

function twr_is_selected(twr)
    local g = p2g(sel.dst_x, sel.dst_y)
    return twr.x == g.x and twr.y == g.y
end

function remove_life()
    lives -= 1
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
        if cell_a.c == CRNR.bl then
            line(a.right, a.bot-1, a.right, a.top+1, C.black)
        elseif cell_a.c == CRNR.br then
            line(a.left+1, a.top, a.right-1, a.top, C.black)
        elseif cell_a.c == CRNR.tl then
            line(a.left+1, a.bot, a.right-1, a.bot, C.black)
        elseif cell_a.c == CRNR.tr then
            line(a.left, a.bot-1, a.left, a.top+1, C.black)
        end

        -- draw path decoration
        for j = 1, #map, #map-1 do
            local c = map[j].c
            local spr_x = (c == CRNR.top or c == CRNR.bot) and 80 or 96
            local flip_x = c == CRNR.right
            local flip_y = c == CRNR.bot
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
        if twr_is_selected(twr) then -- draw range
            circ(p.left+4, p.top+4, twr.range, C.light_gray)
        end

        -- Draw bullets
        for blt in all(twr.bullets) do
            pset(blt.x, blt.y, C.red)
            -- Draw particles
            for part in all(blt.particles) do
                pset(part.x, part.y, C.dark_purple)
            end
        end
    end)

    draw_enemies()
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
    if c == CRNR.top   then return {x = cell.left,  y = cell.top} end
    if c == CRNR.right then return {x = cell.right, y = cell.top} end
    if c == CRNR.bot   then return {x = cell.right, y = cell.bot} end
    if c == CRNR.tl    then return {x = cell.left,  y = cell.bot} end
    if c == CRNR.bl    then return {x = cell.right, y = cell.bot} end
    if c == CRNR.br    then return {x = cell.right, y = cell.top} end
    if c == CRNR.tr    then return {x = cell.left,  y = cell.top} end
end
