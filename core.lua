--[[
 sound fx
 --------
 0-7:  custom instruments
 8-29: music
 30:   left/right
 31:   invalid
 32:   valid
 33:   confirm (e.g. sell, bonus)
 34:   enemy reaches end
 35:   start game / send wave
 36:   enemy death
 37:   buy tower
 38:   red bullet
 39:   blue bullet
 40:   open menu
 41:   close menu
 42:   open bonus menu
 43:   earned interest
 44:   game lost
 45:   game won
 46-48: upgrade tower

channels
--------
0-1: music (TODO)
2:   towers, bullets
3:   all other sfx
]]

maps = {
    -- easy
    {
        {x=1,  y=0,  cnr='top'},
        {x=1,  y=3,  cnr='bl'},
        {x=3,  y=3,  cnr='br'},
        {x=3,  y=1,  cnr='tl'},
        {x=7,  y=1,  cnr='tr'},
        {x=7,  y=3,  cnr='bl'},
        {x=9,  y=3,  cnr='tr'},
        {x=9,  y=5,  cnr='br'},
        {x=8,  y=5,  cnr='tl'},
        {x=8,  y=7,  cnr='br'},
        {x=5,  y=7,  cnr='bl'},
        {x=5,  y=5,  cnr='tr'},
        {x=2,  y=5,  cnr='tl'},
        {x=2,  y=7,  cnr='br'},
        {x=1,  y=7,  cnr='tl'},
        {x=1,  y=9,  cnr='bl'},
        {x=9,  y=9,  cnr='tr'},
        {x=9,  y=10, cnr='bot'},
    },
    -- medium
    {
        {x=0,  y=2, cnr='left'},
        {x=3,  y=2, cnr='tr'},
        {x=3,  y=5, cnr='bl'},
        {x=7,  y=5, cnr='tr'},
        {x=7,  y=8, cnr='bl'},
        {x=10, y=8, cnr='right'},
    },
    -- hard
    {
        {x=0,  y=5, cnr='left'},
        {x=10, y=5, cnr='right'},
    }
}
BOSS_FREQ = 5 -- boss on every 5th wave
-- TODO: ramp gold and enemy hp
waves = {
    {hp=6},   -- SQUARE
    {hp=10},  -- DIAMOND
    {hp=20},  -- RECTANGLE
    {hp=10},  -- ARROW
    {hp=17},  -- CIRCLE
    {hp=22},  -- SQUARE
    {hp=26},  -- DIAMOND
    {hp=40},  -- RECTANGLE
    {hp=22},  -- ARROW
    {hp=36},  -- CIRCLE
    {hp=40},  -- SQUARE
    {hp=48},  -- DIAMOND
    {hp=64},  -- RECTANGLE
    {hp=44},  -- ARROW
    {hp=60},  -- CIRCLE
    {hp=64},  -- SQUARE
    {hp=70},  -- DIAMOND
    {hp=90},  -- RECTANGLE
    {hp=60},  -- ARROW
    {hp=84},  -- CIRCLE
    {hp=90},  -- SQUARE
    {hp=96},  -- DIAMOND
    {hp=130}, -- RECTANGLE
    {hp=90},  -- ARROW
    {hp=118}, -- CIRCLE
}
-- Note: `sell` prices computed in _init()
tower_cfg = {
    -- level 1
    {dmg=0.25, range=30, cd=5,                 buy=40, upg=40}, -- green
    {dmg=2.3,  range=30, cd=38, max_bullets=1, buy=40, upg=40}, -- red
    {dmg=2,    range=30, cd=60, max_bullets=1, buy=30, upg=30}, -- blue
    -- level 2
    {dmg=0.6,  range=32, cd=5,                 upg=40}, -- green
    {dmg=2.8,  range=32, cd=38, max_bullets=2, upg=40}, -- red
    {dmg=2.3,  range=32, cd=55, max_bullets=2, upg=40}, -- blue
    -- level 3
    {dmg=0.9,  range=34, cd=5,                 upg=50}, -- green
    {dmg=2.8,  range=34, cd=38, max_bullets=3, upg=50}, -- red
    {dmg=2.4,  range=34, cd=50, max_bullets=3, upg=50}, -- blue
    -- level 4
    {dmg=1.3,  range=36, cd=5},                 -- green
    {dmg=3,    range=36, cd=38, max_bullets=4}, -- red
    {dmg=2.5,  range=36, cd=45, max_bullets=4}, -- blue
}
local MAX_INTEREST_T = 48

local function end_game(state)
    game_over = state
    buy_menu:close()
    upg_menu:close()
    sfx(state == 'lost' and 44 or 45)
end

function remove_life(enmy)
    sfx(34, 2)
    lives = max(lives - (enmy.type == 'BOSS' and 5 or 1), 0)
    if lives == 0 and not game_over then
        end_game'lost'
    end
    shake = 3
end

function get_map()
    return maps[cur_map]
end

function add_bonus(type)
    add(bonuses, {type=type, y=134, v=0})
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function _init()
    poke(0x5f5c, 9) -- button repeat delay
    poke(0x5f5d, 3) -- button repeat interval
    cur_map = 1
    reinit()
    -- music(0, 200)
end

function reinit()
    wave = 0
    gold = 100
    bonuses = {}
    interest = 3
    bonus_dmg = 1
    bonus_rng = 1
    t = 0
    start_t = 0 -- cant use `t` bc it overflows
    shake = 0
    screen = 'title' -- 'title' | 'game'
    has_opened_shop = false
    has_bought_tower = false
    game_over = nil -- nil | 'lost' | 'won'
    fade_t = 0 -- fade out of game over screen
    pressing_l, pressing_r, pressing_z = false, false, false
    interest_t = 0
    -- interest_gained = nil

    init_enemy()
    init_menus()
    init_tower()
    init_title()
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------
function _update60()
    pressing_l = btn(⬅️)
    pressing_r = btn(➡️)
    pressing_z = btn(🅾️)

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
    if start_t < 10 then start_t +=1 end
    if interest_t > 0 then interest_t += 1 end
    if interest_t > MAX_INTEREST_T then interest_t = 0; interest_gained = nil end

    update_selection()

    -- Handle button press
    if game_over then
        if fade_t > 0 then
            if fade_t == 14 then
                reinit()
            else
                fade_t += 1
            end
        else
            if btnp(🅾️) then
                sfx(32)
                fade_t = 1
            end
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
                sfx(40)
                local twr = find_sel_tower()
                if twr then
                    upg_menu:open()
                else
                    buy_menu:open()
                end
            end
            if btnp(❎) and can_send_wave() then
                sfx(35)
                send_wave()
            end
        end
    end

    spawn_enemy()
    update_enemies()
    update_bullets()
    update_towers()
    update_tower_ranges()

    buy_menu:update()
    upg_menu:update()
    bonus_menu:update() -- should go after update_enemies()

    update_hint() -- should go after bonus_menu:update()

    -- Animate bonuses
    for bonus in all(bonuses) do
        bonus.y, bonus.v = spring(bonus.y, 122, bonus.v, {
            stiffness = 80,
            damping = 16,
        })
    end

    -- Shake camera
    if shake > 0 then
        local shake_x = rnd(shake) - shake/2
        local shake_y = rnd(shake) - shake/2
        camera(shake_x, shake_y)
        shake *= 0.9
        if shake < 0.3 then shake = 0 end
    end

    -- should go after spawning enemies
    if not game_over and sending == 0 and #enemies == 0 and wave == #waves then
        end_game'won'
    end
end

--------------------------------------------------------------------------------
-- DRAW
--------------------------------------------------------------------------------
function _draw()
    cls(Black)
    pal(1) -- reset display palette
    pal(Peach, 140, 1) -- hidden palette

    -- Draw grid lines
    for y = 10, 127, 12 do line(0, y, 127, y, DarkBlue) end
    for x = 10, 127, 12 do line(x, 0, x, 127, DarkBlue) end

    if screen == 'title' then
        draw_title()
        return
    end

    -- Fade out of game over screen
    if fade_t > 0 then
        local color = fade_t <= 6 and DarkGray or fade_t <= 10 and DarkBlue or Black
        pal({
            DarkBlue, -- 1
            DarkPurple, -- 2
            color, -- 3
            color, -- 4
            color, -- 5
            color, -- 6
            color, -- 7
            color, -- 8
            color, -- 9
            color, -- 10
            color, -- 11
            color, -- 12
            color, -- 13
            color, -- 14
            color, -- 15
            Black, -- 0
        }, 1)
    end

    -- Draw wave count
    local wave_str = wave .. '/' .. #waves
    print_outlined(wave_str, hcenter(wave_str), 122, DarkBlue)

    draw_path(0)
    draw_towers()
    draw_bullets()
    draw_tower_ranges()
    draw_enemies()
    draw_selection()

    -- Draw bonuses
    for i, bonus in ipairs(bonuses) do
        spr(
            bonus.type == 'INTEREST' and 35 or bonus.type == 'DAMAGE' and 36 or 37,
            2+12*(i-1), -- x
            bonus.y -- y
        )
    end

    buy_menu:draw()
    upg_menu:draw()
    bonus_menu:draw()

    draw_hint()
    draw_stats()

    camera() -- things drawn below will not be affected by screen shake

    if game_over == 'lost' then
        draw_game_over('game over', Red)
    elseif game_over == 'won' then
        draw_game_over('you win', Orange)
    end
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
        if cell_a.cnr == 'bl' then
            line(a.right, a.bot-1, a.right, a.top+1, Black)
        elseif cell_a.cnr == 'br' then
            line(a.left+1, a.top, a.right-1, a.top, Black)
        elseif cell_a.cnr == 'tl' then
            line(a.left+1, a.bot, a.right-1, a.bot, Black)
        elseif cell_a.cnr == 'tr' then
            line(a.left, a.bot-1, a.left, a.top+1, Black)
        end

        -- draw path decoration
        if cur_map == 3 then pal(DarkBlue, DarkPurple) end
        for j = 1, #map, #map-1 do
            local cnr = map[j].cnr
            local p = g2p(map[j])
            local sx, sy, w, h, dx, dy
            local flip_x, flip_y = false, false
            local off = (t\7)%4
            if cnr == 'top' or cnr == 'bot' then
                w = 11; h = 6
                flip_y = cnr == 'bot'
                sx = cnr == 'bot' and 84-off or 80+off
                sy = 8
                dy = cnr == 'bot' and 128-h or 0
                dx = mid(0, p.left, 117)
                if dx > 0 then dx += 1 end -- account for cell border
            else
                w = 6; h = 11
                flip_x = cnr == 'right'
                sx = 96
                sy = cnr == 'right' and 12-off or 8+off
                dx = cnr == 'right' and 128-w or 0
                dy = mid(0, p.top, 116)
                if dy > 0 then dy += 1 end -- account for cell border
            end
            sspr(sx, sy, w, h, dx, dy, w, h, flip_x, flip_y)
        end
        pal(0)
    end
end

function draw_stats()
    local c = start_t <= 4 and DarkBlue
           or start_t <= 8 and DarkGray or nil
    if c then
        pal{
            [2]=c, -- dark purple
            [6]=c, -- light gray
            [8]=c, -- red
            [9]=c, -- orange
            [10]=c, -- yellow
        }
    end
    local lives = tostr(lives)
    local x = 127 - #lives*4
    local y = 2
    print(lives, x, y, (shake > 0 and t%2 == 0) and Red or LightGray)
    x -= 9
    spr(18, x, y)

    local gold = tostr(flr(gold))
    x -= 3 + #gold*4
    local right = print(gold, x, y, LightGray)
    x -= 7
    spr(17, x, y)
    pal(0)

    -- draw interest earned
    if interest_t > 0 then
        -- `t` is between 1 and 12 (but hits 13 on the very last frame)
        local t = interest_t\(MAX_INTEREST_T/12) + 1
        local str = '+' .. flr(interest_gained)
        local width = print(str, 0, -20)
        print_outlined(
            str,
            right - width + 3,
            13-t\2,
            (t==1 or t>=11) and DarkGray or t==2 and LightGray or Yellow,
            (t==1 or t>=11) and Black or DarkBlue
        )
    end
end

function get_cell_corner(cell, cnr)
    if cnr == 'top'   then return {x = cell.left,  y = cell.top} end
    if cnr == 'right' then return {x = cell.right, y = cell.top} end
    if cnr == 'left'  then return {x = cell.left,  y = cell.bot} end
    if cnr == 'bot'   then return {x = cell.right, y = cell.bot} end
    if cnr == 'tl'    then return {x = cell.left,  y = cell.bot} end
    if cnr == 'bl'    then return {x = cell.right, y = cell.bot} end
    if cnr == 'br'    then return {x = cell.right, y = cell.top} end
    if cnr == 'tr'    then return {x = cell.left,  y = cell.top} end
end

function draw_game_over(text, color)
    local text = '- ' .. text .. ' -'
    print_outlined(text, hcenter(text), 44, color)
    -- draw restart
    local str = 'restart'
    local x = hcenter(str)+4
    local y = 68
    print_outlined(str, x, y, LightGray)
    pal(Green, Black)
    spr(pressing_z and 94 or 92, x-12, y-1)
    pal(0)
end
