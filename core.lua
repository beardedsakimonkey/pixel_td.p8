-- TODO: create maps
_map = {
    {x=1,  y=0,  cnr=CNR.top},
    {x=1,  y=3,  cnr=CNR.bl},
    {x=3,  y=3,  cnr=CNR.br},
    {x=3,  y=1,  cnr=CNR.tl},
    {x=7,  y=1,  cnr=CNR.tr},
    {x=7,  y=3,  cnr=CNR.bl},
    {x=9,  y=3,  cnr=CNR.tr},
    {x=9,  y=5,  cnr=CNR.br},
    {x=8,  y=5,  cnr=CNR.tl},
    {x=8,  y=7,  cnr=CNR.br},
    {x=5,  y=7,  cnr=CNR.bl},
    {x=5,  y=5,  cnr=CNR.tr},
    {x=2,  y=5,  cnr=CNR.tl},
    {x=2,  y=7,  cnr=CNR.br},
    {x=1,  y=7,  cnr=CNR.tl},
    {x=1,  y=9,  cnr=CNR.bl},
    {x=9,  y=9,  cnr=CNR.tr},
    {x=9,  y=10, cnr=CNR.bot},
}
_map2 = {
    {x=0,  y=3,  cnr=CNR.left},
    {x=3,  y=3,  cnr=CNR.br},
    {x=3,  y=1,  cnr=CNR.tl},
    {x=7,  y=1,  cnr=CNR.tr},
    {x=7,  y=3,  cnr=CNR.bl},
    {x=9,  y=3,  cnr=CNR.tr},
    {x=9,  y=5,  cnr=CNR.br},
    {x=8,  y=5,  cnr=CNR.tl},
    {x=8,  y=7,  cnr=CNR.br},
    {x=5,  y=7,  cnr=CNR.bl},
    {x=5,  y=5,  cnr=CNR.tr},
    {x=2,  y=5,  cnr=CNR.tl},
    {x=2,  y=7,  cnr=CNR.br},
    {x=1,  y=7,  cnr=CNR.tl},
    {x=1,  y=9,  cnr=CNR.bl},
    {x=10,  y=9, cnr=CNR.right},
}
_map3 = {
    {x=1,  y=0,  cnr=CNR.top},
    {x=1,  y=3,  cnr=CNR.bl},
    {x=3,  y=3,  cnr=CNR.br},
    {x=3,  y=1,  cnr=CNR.tl},
    {x=7,  y=1,  cnr=CNR.tr},
    {x=7,  y=3,  cnr=CNR.bl},
    {x=9,  y=3,  cnr=CNR.tr},
    {x=9,  y=5,  cnr=CNR.br},
    {x=8,  y=5,  cnr=CNR.tl},
    {x=8,  y=7,  cnr=CNR.br},
    {x=5,  y=7,  cnr=CNR.bl},
    {x=5,  y=5,  cnr=CNR.tr},
    {x=2,  y=5,  cnr=CNR.tl},
    {x=2,  y=7,  cnr=CNR.br},
    {x=1,  y=7,  cnr=CNR.tl},
    {x=1,  y=9,  cnr=CNR.bl},
    {x=9,  y=9,  cnr=CNR.tr},
    {x=9,  y=10, cnr=CNR.bot},
}
maps = {_map, _map2, _map3}
function get_map()
    return maps[cur_map]
end
-- Note: bosses must be on every 5th wave
waves = {
    {hp=6,  speed=0.25, gold=4, type='RECTANGLE'},
    {hp=9,  speed=0.25, gold=4, type='DIAMOND'},
    {hp=12, speed=0.2,  gold=4, type='RECTANGLE'},
    {hp=7,  speed=0.5,  gold=4, type='ARROW'},
    {hp=15, speed=0.25, gold=4, type='CIRCLE', boss_hp=10, boss_gold=10},
    {hp=18, speed=0.25, gold=4, type='SQUARE'},
    {hp=21, speed=0.25, gold=4, type='DIAMOND'},
    {hp=25, speed=0.2,  gold=4, type='RECTANGLE'},
    {hp=16, speed=0.5,  gold=4, type='ARROW'},
    {hp=24, speed=0.25, gold=4, type='CIRCLE', boss_hp=10, boss_gold=10},
    {hp=27, speed=0.25, gold=4, type='SQUARE'},
    {hp=30, speed=0.25, gold=4, type='DIAMOND'},
    {hp=35, speed=0.2,  gold=4, type='RECTANGLE'},
    {hp=25, speed=0.5,  gold=4, type='ARROW'},
    {hp=33, speed=0.25, gold=4, type='CIRCLE', boss_hp=10, boss_gold=10},
    {hp=36, speed=0.25, gold=4, type='SQUARE'},
    {hp=39, speed=0.25, gold=4, type='DIAMOND'},
    {hp=45, speed=0.2,  gold=4, type='RECTANGLE'},
    {hp=34, speed=0.5,  gold=4, type='ARROW'},
    {hp=42, speed=0.25, gold=4, type='CIRCLE', boss_hp=10, boss_gold=10},
    {hp=45, speed=0.25, gold=4, type='SQUARE'},
    {hp=48, speed=0.25, gold=4, type='DIAMOND'},
    {hp=55, speed=0.2,  gold=4, type='RECTANGLE'},
    {hp=43, speed=0.5,  gold=4, type='ARROW'},
    {hp=52, speed=0.25, gold=4, type='CIRCLE', boss_hp=10, boss_gold=10},
}
tower_cfg = {
    -- level 1
    {dmg=0.2, range=30,                           buy=40, upg=30, sell=40}, -- green
    {dmg=2,   range=30, atkspd=40,                buy=40, upg=30, sell=40}, -- red
    {dmg=2,   range=30, atkspd=80,                buy=30, upg=30, sell=30}, -- yellow
    -- level 2
    {dmg=0.4, range=33,                           upg=40, sell=70}, -- green
    {dmg=2,   range=33, atkspd=40, max_bullets=2, upg=40, sell=70}, -- red
    {dmg=3,   range=33, atkspd=70, max_bullets=2, upg=40, sell=70}, -- yellow
    -- level 3
    {dmg=0.6, range=36,                           upg=50, sell=110}, -- green
    {dmg=2,   range=36, atkspd=40, max_bullets=3, upg=50, sell=110}, -- red
    {dmg=4,   range=36, atkspd=60, max_bullets=3, upg=50, sell=110}, -- yellow
    -- level 4
    {dmg=0.8, range=39,                           sell=160}, -- green
    {dmg=2,   range=39, atkspd=40, max_bullets=4, sell=160}, -- red
    {dmg=5,   range=39, atkspd=50, max_bullets=4, sell=160}, -- yellow
}


function remove_life()
    lives -= 1
    shake = 3
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function reinit()
    cur_map = 1
    wave = 0
    gold = 100
    lives = 10
    bonuses = {}
    interest = 3
    bonus_dmg = 1
    bonus_rng = 1
    t = 0
    start_age = 0 -- cant use `t` bc it wraps to 0
    shake = 0
    screen = 'title'
    has_opened_shop = false
    has_bought_tower = false

    init_enemy()
    init_menus()
    init_selection()
    init_hint() -- should go after init_selection()
    init_tower()
    init_title()
end

function _init()
    poke(0x5f5c, 9) -- button repeat delay
    poke(0x5f5d, 3) -- button repeat interval
    reinit()
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------
function _update60()
    debug_msgs = {}
    if screen == 'title' then
        update_title()
        return
    end
    if screen == 'game_over' then
        update_game_over()
        return
    end
    -- Initialize once we know the map
    if t == 0 then
        init_grid_bitmap()
        init_path_points()
    end

    t = max(1, t+1)
    if start_age < 10 then start_age +=1 end

    update_selection()

    -- Handle button press
    if buy_menu.is_open then
        has_opened_shop = true
        buy_menu:handle_btn()
    elseif upg_menu.is_open then
        upg_menu:handle_btn()
    elseif bonus_menu.is_open then
        bonus_menu:handle_btn()
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

    spawn_enemy()
    update_enemies()
    update_bullets()
    update_towers()

    buy_menu:update()
    upg_menu:update()
    bonus_menu:update() -- should go after update_enemies()

    update_hint() -- should go after bonus_menu:update()

    -- Shake camera
    if shake > 0 then
        local shake_x = rnd(shake) - shake/2
        local shake_y = rnd(shake) - shake/2
        camera(shake_x, shake_y)
        shake *= 0.9
        if shake < 0.3 then shake = 0 end
    end

    -- should go after spawning enemies
    if sending == 0 and #enemies == 0 and wave == #waves then
        screen = 'game_over'
        return
    end
end

--------------------------------------------------------------------------------
-- DRAW
--------------------------------------------------------------------------------
function _draw()
    cls(C.black)
    -- Draw grid lines
    for y = 10, 127, 12 do line(0, y, 127, y, C.dark_blue) end
    for x = 10, 127, 12 do line(x, 0, x, 127, C.dark_blue) end

    if screen == 'title' then
        draw_title()
        return
    end

    if screen == 'game_over' then
        draw_game_over()
        return
    end

    -- Draw wave count
    do
        local str = wave .. '/' .. #waves
        print_outlined(str, center_horz(str), 122, C.dark_blue, C.black)
    end

    draw_path(0)
    draw_towers()
    draw_bullets()
    draw_enemies()
    draw_selection()

    -- Draw bonuses
    for i, bonus in ipairs(bonuses) do
        local s
        if     bonus == 'INTEREST' then s = 35
        elseif bonus == 'DAMAGE' then s = 36
        elseif bonus == 'RANGE' then s = 37 end
        spr(s, 2+12*(i-1), 122)
    end

    buy_menu:draw()
    upg_menu:draw()
    bonus_menu:draw()

    draw_hint()
    camera() -- things drawn below will not be affected by screen shake
    draw_stats()

    -- Draw debug messages
    color(C.light_gray)
    cursor(2, 2)
    for msg in all(debug_msgs) do
        print(msg)
    end
end

function draw_path(t)
    local map = get_map()
    for i = 2, #map do
        local cell_a, cell_b = map[i-1], map[i]
        local ca = get_cell_corner(g2p(cell_a), cell_a.cnr)
        local cb = get_cell_corner(g2p(cell_b), cell_b.cnr)
        rectfill(ca.x, ca.y, cb.x, cb.y, C.black)
        rect(ca.x, ca.y, cb.x, cb.y, C.indigo)

        -- cover up unwanted borders
        local a = g2p(cell_a)
        if cell_a.cnr == CNR.bl then
            line(a.right, a.bot-1, a.right, a.top+1, C.black)
        elseif cell_a.cnr == CNR.br then
            line(a.left+1, a.top, a.right-1, a.top, C.black)
        elseif cell_a.cnr == CNR.tl then
            line(a.left+1, a.bot, a.right-1, a.bot, C.black)
        elseif cell_a.cnr == CNR.tr then
            line(a.left, a.bot-1, a.left, a.top+1, C.black)
        end

        -- draw path decoration
        if cur_map == 3 then pal(C.dark_blue, C.dark_purple) end
        for j = 1, #map, #map-1 do
            local cnr = map[j].cnr
            local p = g2p(map[j])
            local sx, sy, w, h, dx, dy
            local flip_x, flip_y = false, false
            if cnr == CNR.top or cnr == CNR.bot then
                w = 11; h = 6
                flip_y = cnr == CNR.bot
                sx = cnr == CNR.bot and (80+4 - (t\7)%4) or (80 + (t\7)%4)
                sy = 8
                dy = cnr == CNR.bot and 128-h or 0
                dx = mid(0, p.left, 117)
                if dx > 0 then dx += 1 end -- account for cell border
            else
                w = 6; h = 11
                flip_x = cnr == CNR.right
                sx = 96
                sy = cnr == CNR.right and (8+4 - (t\7)%4) or (8 + (t\7)%4)
                dx = cnr == CNR.right and 128-w or 0
                dy = mid(0, p.top, 116)
                if dy > 0 then dy += 1 end -- account for cell border
            end
            sspr(sx, sy, w, h, dx, dy, w, h, flip_x, flip_y)
        end
        pal(0)
    end
end

function draw_stats()
    local c = start_age <= 4 and C.dark_blue
           or start_age <= 8 and C.dark_gray or nil
    if c then
        pal({
            [2]=c, -- dark purple
            [6]=c, -- light gray
            [8]=c, -- red
            [9]=c, -- orange
            [10]=c, -- yellow
        })
    end
    local lives = tostr(lives)
    local x = 127 - #lives*4
    local y = 2
    print(lives, x, y, C.light_gray)
    x -= 9
    spr(18, x, y)

    local gold = tostr(flr(gold))
    x -= 3 + #gold*4
    print(gold, x, y, C.light_gray)
    x -= 7
    spr(17, x, y)
    pal(0)
end

function get_cell_corner(cell, cnr)
    if cnr == CNR.top   then return {x = cell.left,  y = cell.top} end
    if cnr == CNR.right then return {x = cell.right, y = cell.top} end
    if cnr == CNR.left  then return {x = cell.left,  y = cell.bot} end
    if cnr == CNR.bot   then return {x = cell.right, y = cell.bot} end
    if cnr == CNR.tl    then return {x = cell.left,  y = cell.bot} end
    if cnr == CNR.bl    then return {x = cell.right, y = cell.bot} end
    if cnr == CNR.br    then return {x = cell.right, y = cell.top} end
    if cnr == CNR.tr    then return {x = cell.left,  y = cell.top} end
end

function debug(msg)
    add(debug_msgs, msg)
end
