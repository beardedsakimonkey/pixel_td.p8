_map_easy = {
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
_map_medium = {
    {x=0,  y=1,  cnr=CNR.left},
    {x=3,  y=1,  cnr=CNR.tr},
    {x=3,  y=5,  cnr=CNR.bl},
    {x=7,  y=5,  cnr=CNR.tr},
    {x=7,  y=9,  cnr=CNR.bl},
    {x=10,  y=9, cnr=CNR.right},
}
_map_hard = {
    {x=0,  y=5,  cnr=CNR.left},
    {x=10,  y=5, cnr=CNR.right},
}
maps = {_map_easy, _map_medium, _map_hard}
function get_map()
    return maps[cur_map]
end
BOSS_FREQ = 5 -- boss on every 5th wave
waves = {
    {hp=6,   type='SQUARE'},
    {hp=10,  type='DIAMOND'},
    {hp=15,  type='RECTANGLE'},
    {hp=10,  type='ARROW'},
    {hp=17,  type='CIRCLE'},
    {hp=22,  type='SQUARE'},
    {hp=26,  type='DIAMOND'},
    {hp=34,  type='RECTANGLE'},
    {hp=26,  type='ARROW'},
    {hp=36,  type='CIRCLE'},
    {hp=40,  type='SQUARE'},
    {hp=48,  type='DIAMOND'},
    {hp=58,  type='RECTANGLE'},
    {hp=50,  type='ARROW'},
    {hp=60,  type='CIRCLE'},
    {hp=64,  type='SQUARE'},
    {hp=70,  type='DIAMOND'},
    {hp=82,  type='RECTANGLE'},
    {hp=72,  type='ARROW'},
    {hp=84,  type='CIRCLE'},
    {hp=90,  type='SQUARE'},
    {hp=96,  type='DIAMOND'},
    {hp=110, type='RECTANGLE'},
    {hp=100, type='ARROW'},
    {hp=118, type='CIRCLE'},
}
-- Note: `sell` prices computed in init()
tower_cfg = {
    -- level 1
    {dmg=0.2, range=30,                           buy=50, upg=30}, -- green
    {dmg=2,   range=30, atkspd=40, max_bullets=1, buy=50, upg=30}, -- red
    {dmg=1,   range=30, atkspd=80, max_bullets=1, buy=40, upg=30}, -- blue
    -- level 2
    {dmg=0.4, range=32,                           upg=40}, -- green
    {dmg=2,   range=32, atkspd=40, max_bullets=2, upg=40}, -- red
    {dmg=2,   range=32, atkspd=70, max_bullets=2, upg=40}, -- blue
    -- level 3
    {dmg=0.6, range=34,                           upg=50}, -- green
    {dmg=2,   range=34, atkspd=40, max_bullets=3, upg=50}, -- red
    {dmg=3,   range=34, atkspd=60, max_bullets=3, upg=50}, -- blue
    -- level 4
    {dmg=0.8, range=36},                           -- green
    {dmg=2,   range=36, atkspd=40, max_bullets=4}, -- red
    {dmg=4,   range=36, atkspd=50, max_bullets=4}, -- blue
}

local function set_game_over(state)
    game_over = state
    buy_menu:close()
    upg_menu:close()
end

function remove_life()
    sfx(6)
    lives = max(lives-1, 0)
    if lives == 0 then
        set_game_over('lost')
    end
    shake = 3
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function _init()
    poke(0x5f5c, 9) -- button repeat delay
    poke(0x5f5d, 3) -- button repeat interval
    pal(Peach, 140, 1) -- hidden palette
    reinit()
end

function reinit()
    cur_map = 1
    wave = 0
    gold = 100
    bonuses = {}
    interest = 3
    bonus_dmg = 1
    bonus_rng = 1
    t = 0
    start_age = 0 -- cant use `t` bc it overflows
    shake = 0
    screen = 'title' -- 'title' | 'game'
    has_opened_shop = false
    has_bought_tower = false
    game_over = nil -- nil | 'lost' | 'won'

    init_enemy()
    init_menus()
    init_tower()
    init_title()
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------
function _update60()
    -- debug_msgs = {}
    if screen == 'title' then
        update_title()
        -- if screen changed to 'game', continue with the update function
        -- *before* drawing
        if screen == 'title' then
            return
        end
    end
    -- Initialize once we know the map
    if t == 0 then
        lives = cur_map == 1 and 20 or cur_map == 2 and 10 or 5
        init_grid_bitmap()
        init_path_points()
        init_selection()
        init_hint() -- should go after init_selection()
    end

    t = max(1, t+1)
    if start_age < 10 then start_age +=1 end

    update_selection()

    -- Handle button press
    if game_over then
        if btnp(🅾️) then
            sfx(0)
            reinit()
        end
    else
        if buy_menu.is_open then
            has_opened_shop = true
            buy_menu:handle_btn()
        elseif upg_menu.is_open then
            upg_menu:handle_btn()
        elseif bonus_menu.is_open then
            bonus_menu:handle_btn()
        else
            if btnp(🅾️) then
                sfx(4)
                local twr = find_sel_tower()
                if twr then
                    upg_menu:open()
                else
                    buy_menu:open()
                end
            end
            if btnp(❎) and can_send_wave() then
                sfx(7)
                send_wave()
            end
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
        set_game_over('won')
        return
    end
end

--------------------------------------------------------------------------------
-- DRAW
--------------------------------------------------------------------------------
function _draw()
    cls(Black)
    -- Draw grid lines
    for y = 10, 127, 12 do line(0, y, 127, y, DarkBlue) end
    for x = 10, 127, 12 do line(x, 0, x, 127, DarkBlue) end

    if screen == 'title' then
        draw_title()
        return
    end

    -- Draw wave count
    do
        local str = wave .. '/' .. #waves
        print_outlined(str, hcenter(str), 122, DarkBlue)
    end

    draw_path(0)
    draw_towers()
    draw_bullets()
    draw_tower_ranges()
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

    if game_over then
        if game_over == 'lost' then
            draw_game_over('game over', Red)
        else
            draw_game_over('you win', Orange)
        end
    end

    -- Draw debug messages
    -- color(LightGray)
    -- cursor(2, 2)
    -- for msg in all(debug_msgs) do
    --     print(msg)
    -- end
end

function draw_path(t)
    local map = get_map()
    for i = 2, #map do
        local cell_a, cell_b = map[i-1], map[i]
        local ca = get_cell_corner(g2p(cell_a), cell_a.cnr)
        local cb = get_cell_corner(g2p(cell_b), cell_b.cnr)
        rectfill(ca.x, ca.y, cb.x, cb.y, Black)
        rect(ca.x, ca.y, cb.x, cb.y, Indigo)

        -- cover up unwanted borders
        local a = g2p(cell_a)
        if cell_a.cnr == CNR.bl then
            line(a.right, a.bot-1, a.right, a.top+1, Black)
        elseif cell_a.cnr == CNR.br then
            line(a.left+1, a.top, a.right-1, a.top, Black)
        elseif cell_a.cnr == CNR.tl then
            line(a.left+1, a.bot, a.right-1, a.bot, Black)
        elseif cell_a.cnr == CNR.tr then
            line(a.left, a.bot-1, a.left, a.top+1, Black)
        end

        -- draw path decoration
        if cur_map == 3 then pal(DarkBlue, DarkPurple) end
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
    local c = start_age <= 4 and DarkBlue
           or start_age <= 8 and DarkGray or nil
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
    print(lives, x, y, LightGray)
    x -= 9
    spr(18, x, y)

    local gold = tostr(flr(gold))
    x -= 3 + #gold*4
    print(gold, x, y, LightGray)
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

function draw_game_over(text, color)
    do
        local y = 50
        local x, w = print_outlined(text, hcenter(text), y, color)
        for x1 in all{x-7, x+w+2} do
            local y1 = y+2
            local x2 = x1+3
            rectfill(x1-1, y1-1, x2+1, y1+1, Black)
            rectfill(x1, y1, x2, y1, color)
        end
    end
    -- draw restart
    do
        local y = 68
        local str = 'restart'
        local x = print_outlined(str, hcenter(str)+4, y, LightGray)
        pal(Green, Black)
        spr(92, x-12, y-1)
        pal(0)
    end
end

-- function debug(msg)
--     add(debug_msgs, msg)
-- end
