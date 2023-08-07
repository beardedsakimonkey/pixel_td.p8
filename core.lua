--[[
 sound fx
 --------
 0-1:   custom instruments for sfx
 2-4:   custom instruments for hard mode
 5:     -
 6:     custom instrument for easy mode
 7:     -
 8-14:  music for easy mode
 15-18: -
 19-26: music for hard mode
 27-29: music for title screen
 30:    left/right
 31:    invalid
 32:    valid
 33:    confirm (e.g. sell, bonus)
 34:    enemy reaches end
 35:    start game / send wave
 36:    buy tower
 37:    enemy death 1
 38:    enemy death 2
 39:    enemy death 3
 40:    open menu
 41:    close menu
 42:    open bonus menu
 43:    -
 44:    game lost
 45:    game won
 46-48: upgrade tower

patterns
--------
0-9:   easy mode
40-49: hard mode
56-58: title screen

channels
--------
0-1: music
2-3: sfx
]]

maps = {
    parse_tbl[[
x=1,y=0,cnr=top
x=1,y=3,cnr=bl
x=3,y=3,cnr=br
x=3,y=1,cnr=tl
x=8,y=1,cnr=tr
x=8,y=5,cnr=br
x=2,y=5,cnr=tl
x=2,y=9,cnr=bl
x=7,y=9,cnr=br
x=7,y=7,cnr=tl
x=9,y=7,cnr=tr
x=9,y=10,cnr=bot
]],
    parse_tbl[[
x=0,y=2,cnr=left
x=3,y=2,cnr=tr
x=3,y=5,cnr=bl
x=7,y=5,cnr=tr
x=7,y=8,cnr=bl
x=10,y=8,cnr=right
]],
    parse_tbl[[
x=0,y=5,cnr=left
x=10,y=5,cnr=right
]],
}
BOSS_FREQ = 5 -- boss on every 5th wave
NUM_WAVES = 20
-- Note: `sell` prices computed in _init()
-- Note: order is red, green, blue
tower_cfg = parse_tbl[[
dmg=2.4,range=30,buy=40,upg=50
dmg=2.4,range=28,buy=40,upg=50
dmg=2.0,range=25,buy=50,upg=55

dmg=3.0,range=34,upg=55
dmg=3.0,range=32,upg=55
dmg=2.3,range=28,upg=60

dmg=3.1,range=37,upg=70
dmg=3.5,range=35,upg=70
dmg=2.4,range=30,upg=75

dmg=3.2,range=39
dmg=4.0,range=37
dmg=2.5,range=31
]]
local MAX_GOLD_INC_T = 48

local function end_game(state)
    game_over = state
    buy_menu:close()
    upg_menu:close()
    music(-1)
    sfx(state == 'lost' and 44 or 45)
    game_end_time = time()
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

function add_bonus(spr)
    add(bonuses, {spr=spr, y=134, v=0})
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function _init()
    poke(0x5f5c, 9) -- button repeat delay
    poke(0x5f5d, 3) -- button repeat interval
    cur_map = 1
    reinit()
end

function reinit()
    wave = 0
    gold = 100
    bonuses = {}
    bonus_dmg = 1
    bonus_rng = 1
    bonus_atkspd = 1
    t = 0
    start_t = 0 -- cant use `t` bc it overflows
    shake = 0
    screen = 'title' -- 'title' | 'game'
    has_opened_shop = false
    has_bought_tower = false
    gold_inc = nil -- gold increase animation
    gold_inc_t = 0
    game_over = nil -- nil | 'lost' | 'won'
    fade_t = 0 -- fade out of game over screen
    -- pressing_l, pressing_r, pressing_z, pressing_x = false, false, false, false
    game_start_time = 0
    game_end_time = 0

    init_enemy()
    init_menus()
    init_tower()
    init_title()
    music(56)
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------
function _update60()
    pressing_l = btn(⬅️)
    pressing_r = btn(➡️)
    pressing_z = btn(🅾️)
    pressing_x = btn(❎)

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
        lives = cur_map == 1 and 10 or cur_map == 2 and 5 or 1
        init_grid_bitmap()
        init_path_points()
        init_selection()
        init_hint() -- should go after init_selection()
        music(cur_map==3 and 40 or 0, nil, 0b11)
    end

    t = max(1, t+1)
    if start_t < 10 then start_t +=1 end
    if gold_inc_t > 0 then gold_inc_t += 1 end
    if gold_inc_t > MAX_GOLD_INC_T then
        gold_inc_t = 0
        gold_inc = nil
    end

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
    if not game_over and sending == 0 and #enemies == 0 and wave == NUM_WAVES then
        end_game'won'
    end
end

function shadow_color()
    return cur_map == 3 and Brown or DarkBlue
end

--------------------------------------------------------------------------------
-- DRAW
--------------------------------------------------------------------------------
function _draw()
    cls(Black)
    pal(1) -- reset display palette
    -- Hidden palette
    pal(Peach, 140, 1)
    if cur_map == 3 then
        pal(Brown, 130, 1)
    end

    -- Draw grid lines
    for y = 10, 127, 12 do line(0, y, 127, y, shadow_color()) end
    for x = 10, 127, 12 do line(x, 0, x, 127, shadow_color()) end

    if screen == 'title' then
        draw_title()
        return
    end

    -- Fade out of game over screen
    if fade_t > 0 then
        local shadow = cur_map==3 and 130 or DarkBlue
        local color = fade_t <= 6 and DarkGray
                   or fade_t <= 10 and shadow
                   or Black
        pal({
            shadow, -- 1 (DarkBlue)
            shadow, -- 2 (DarkPurple)
            DarkBlue, -- 3 (DarkGreen)
            cur_map==3 and 130 or color, -- 4 (Brown)
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
    local wave_str = wave .. '/' .. NUM_WAVES
    print_outlined(wave_str, hcenter(wave_str), 122, shadow_color())

    draw_path(0)
    draw_towers()
    draw_bullets()
    draw_tower_ranges()
    draw_enemies()
    draw_selection()

    -- Draw bonuses
    for i, bonus in ipairs(bonuses) do
        spr(
            bonus.spr,
            1+12*(i-1), -- x
            bonus.y-1 -- y
        )
    end

    buy_menu:draw()
    upg_menu:draw()
    bonus_menu:draw()

    draw_hint()
    draw_hud()

    camera() -- things drawn below will not be affected by screen shake

    if game_over then
        draw_game_over(game_over, Red)
    end
    -- cursor(2, 2, Orange)
    -- for dbg in all(debug or {}) do
    --     print(dbg)
    -- end
end

function draw_path(t)
    local map = get_map()
    for i = 1, #map-1 do
        local c1, c2 = map[i], map[i+1]
        local p1, p2 = g2p(c1), g2p(c2)

        -- cover grid lines
        rectfill(p1.left+2, p1.bot-2, p2.right-2, p2.top+2, Black)

        -- draws a line with inset border
        local function l(side, x1, y1, x2, y2)
            line(x1, y1, x2, y2, Indigo)
            local x1o = side == 'left' and 1 or side == 'right' and -1 or 0
            local y1o = side == 'top' and 1 or side == 'bot' and -1 or 0
            local x2o, y2o = x1o, y1o
            local function get_offset(c)
                return (c.cnr=='bl' or c.cnr=='tr') and -1
                    or (c.cnr=='tl' or c.cnr=='br') and 1 or 0
            end
            if side == 'top' then
                x1o += get_offset(c1)
                x2o += get_offset(c2)
            elseif side == 'bot' then
                x1o += -get_offset(c1)
                x2o += -get_offset(c2)
            elseif side == 'left' then
                y1o += get_offset(c1)
                y2o += get_offset(c2)
            elseif side == 'right' then
                y1o += -get_offset(c1)
                y2o += -get_offset(c2)
            end
            line(x1+x1o, y1+y1o, x2+x2o, y2+y2o, shadow_color())
        end

        local p1_left, p1_right, p1_top, p1_bot = p1.left, p1.right, p1.top, p1.bot
        local p2_left, p2_right, p2_top, p2_bot = p2.left, p2.right, p2.top, p2.bot
        local c1_cnr, c2_cnr = c1.cnr, c2.cnr

        if c1_cnr == 'top' then
            -- left line
            l('left', p1_left,  p1_top, p2_left,  c2_cnr=='br' and p2_top or p2_bot)
            -- right line
            l('right', p1_right, p1_top, p2_right, c2_cnr=='bl' and p2_top or p2_bot)
        elseif c1_cnr == 'left' then
            -- top line
            l('top', p1_left, p1_top, c2_cnr=='br' and p2_left or p2_right, p2_top)
            -- bottom line
            l('bot', p1_left, p1_bot, c2_cnr=='tr' and p2_left or p2_right, p2_bot)
        elseif c1_cnr == 'bl' then
            if p2_right > p1_right then -- exiting right
                -- top line
                l('top', p1_right, p1_top, c2_cnr=='br' and p2_left or p2_right, p2_top)
                -- bottom line
                l('bot', p1_left,  p1_bot, c2_cnr=='tr' and p2_left or p2_right, p2_bot)
            else -- exiting up
                -- left line
                l('left', p1_left,  p1_bot, p2_left,  c2_cnr=='tr' and p2_bot or p2_top)
                -- right line
                l('right', p1_right, p1_top, p2_right, c2_cnr=='tl' and p2_bot or p2_top)
            end
        elseif c1_cnr == 'tl' then
            if p2_right > p1_right then -- exiting right
                -- top line
                l('top', p1_left,  p1_top, c2_cnr=='br' and p2_left or p2_right, p2_top)
                -- bottom line
                l('bot', p1_right, p1_bot, c2_cnr=='tr' and p2_left or p2_right, p2_bot)
            else -- exiting down
                -- left line
                l('left', p1_left,  p1_top, p2_left,  c2_cnr=='br' and p2_top or p2_bot)
                -- right line
                l('right', p1_right, p1_bot, p2_right, c2_cnr=='bl' and p2_top or p2_bot)
            end
        elseif c1_cnr == 'br' then
            if p2_left < p1_left then -- exiting left
                -- top line
                l('top', p1_left,  p1_top, c2.cnr=='bl' and p2_right or p2_left, p2_top)
                -- bottom line
                l('bot', p1_right, p1_bot, c2_cnr=='tl' and p2_right or p2_left, p2_bot, Indigo)
            else -- exiting up
                -- left line
                l('left', p1_left,  p1_top, p2_left,  c2_cnr=='tr' and p2_bot or p2_top)
                -- right line
                l('right', p1_right, p1_bot, p2_right, c2_cnr=='tl' and p2_bot or p2_top)
            end
        elseif c1_cnr == 'tr' then
            if p2_left < p1_left then -- exiting left
                -- top line
                l('top', p1_right, p1_top, c2_cnr=='tl' and p2_left or p2_right, p2_top)
                -- bottom line
                l('bot', p1_left,  p1_bot, c2_cnr=='bl' and p2_left or p2_right, p2_bot)
            else -- exiting down
                -- left line
                l('left', p1_left,  p1_bot, p2_left,  c2_cnr=='br' and p2_top or p2_bot)
                -- right line
                l('right', p1_right, p1_top, p2_right, c2_cnr=='bl' and p2_top or p2_bot)
            end
        end
    end

    -- draw path entrance/exit decoration
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

function draw_hud()
    local c = start_t <= 4 and DarkBlue
           or start_t <= 8 and DarkGray or nil
    if c then
        pal{
            [DarkPurple]=c,
            [LightGray]=c,
            [Red]=c,
            [Orange]=c,
            [Yellow]=c,
        }
    end
    local lives = tostr(lives)
    local x = 127 - #lives*4
    print(lives, x, 2, (shake > 0 and t%2 == 0) and Red or LightGray)
    x -= 9
    spr(18, x, 2)

    local gold = tostr(flr(gold))
    x -= 3 + #gold*4
    local right = print(gold, x, 2, LightGray)
    x -= 7
    spr(17, x, 2)
    pal(0)

    -- Draw gold earned
    if gold_inc then
        -- `t` is between 1 and 12 (but hits 13 on the very last frame)
        local t = gold_inc_t\(MAX_GOLD_INC_T/12) + 1
        local str = '+' .. gold_inc
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

function draw_game_over(game_over, color)
    pal(game_over == 'lost' and Green or Pink, Black)
    sspr(
        0, game_over == 'lost' and 64 or 74,
        56, 9,
        game_over == 'lost' and 36 or 39, 42
    )
    pal(Green, Black)
    local x = 56
    local y = 63
    -- Draw restart button
    print_outlined('restart', x, y, LightGray)
    sspr(96, pressing_z and 72 or 64, 9, 8, x-13, y-1)
end
