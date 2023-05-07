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
waves = {
    {hp=3,  speed=0.5, type=ENMY.circ},
    {hp=6,  speed=0.5, type=ENMY.rect},
    {hp=9,  speed=0.5, type=ENMY.diamond},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
    {hp=12, speed=0.8, type=ENMY.arrow},
}
wave = 0
gold = 500
lives = 20
t = 0

function remove_life()
    lives -= 1
end

function find_sel_tower()
    return tbl_find(towers, function(twr)
        return twr.gx == sel.dst_gx and twr.gy == sel.dst_gy
    end)
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function _init()
    poke(0x5f5c, 9) -- button repeat delay
    poke(0x5f5d, 3) -- button repeat interval

    -- Set up auxiliary data structures
    init_selection_aux()
    init_enemy_aux()

    init_menus()
    init_towers()
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------
function _update60()
    debug = {}
    t += 1
    update_selection()

    -- Handle button press
    if buy_menu.is_open then
        buy_menu:handle_btn()
    elseif upg_menu.is_open then
        upg_menu:handle_btn()
    else
        if btnp(B.z) then
            local twr = find_sel_tower()
            if twr then
                upg_menu:open()
            else
                buy_menu:open()
            end
        end
        if btnp(B.x) then
            send_wave()
        end
    end

    buy_menu:update()
    upg_menu:update()

    spawn_enemy()
    update_enemies()
    update_bullets()
    update_towers()
    update_hint()
end

--------------------------------------------------------------------------------
-- DRAW
--------------------------------------------------------------------------------
function _draw()
    cls(C.black)

    -- Draw grid lines
    for y = 10, 127, 12 do line(0, y, 127, y, C.dark_blue) end
    for x = 10, 127, 12 do line(x, 0, x, 127, C.dark_blue) end

    -- Draw wave count
    do
        local str = wave .. '/' .. #waves
        local mid = 128/2 - 1  -- sub one because its zero-indexed
        local pxlen = #str*4 - 1 -- don't count seperator of 1st char
        local left = mid - pxlen\2
        local right = mid + pxlen\2
        local top = 123
        rectfill(left-1, top-1, right+1, top+5, C.black)
        print(str, left, top, C.dark_blue)
    end

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
            sspr(spr_x, 8, 12, 12, left, top, 12, 12, flip_x, flip_y)
        end
    end

    draw_towers()
    draw_bullets()
    draw_enemies()
    draw_selection()

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

    draw_hint()

    -- Draw debug messages
    color(C.light_gray)
    cursor(2, 2)
    for msg in all(debug) do
        print(msg)
    end
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
