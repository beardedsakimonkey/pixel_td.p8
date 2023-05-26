local show_hint_X
local X_pos
local X_v
local X_t

local Z_x
local Z_y
local Z_vx
local Z_vy
local Z_t

local OFFSCREEN = -8
local SHINE_DELAY = 300 -- 10 sec
local FLIP_Y = 20
local FADE_DURATION = 9

function init_hint()
    show_hint_X = false
    X_pos = OFFSCREEN
    X_v = 0
    Z_x = sel.dst_x-28
    Z_y = sel.dst_y
    Z_vx, Z_vy = 0, 0
    Z_t, X_t = 0, 0
end

local function can_show_hint_X()
    return can_send_wave() and not bonus_menu.is_open and has_bought_tower
end

local function can_show_hint_Z()
    return not has_opened_shop and can_send_wave()
end

function update_hint()
    local dismissing_X = show_hint_X and not can_show_hint_X()
    show_hint_X = can_show_hint_X()
    local show_hint_Z = can_show_hint_Z()

    if show_hint_X then
        X_t = max(0, X_t+1)
    elseif show_hint_Z then
        Z_t += 1
        if Z_t < 0 then Z_t = FADE_DURATION+1 end
    end
    if dismissing_X then
        X_t = 0
        X_v = 200
    end
    local dest_pos = show_hint_X and 1 or OFFSCREEN
    X_pos, X_v = spring(X_pos, dest_pos, X_v, {
        stiffness = 200,
        damping = 32,
        mass = 2,
        precision = 0.2,
    })
    if show_hint_Z then
        local flip = sel.dst_x < FLIP_Y
        local dest_x = sel.dst_x + (flip and 21 or -18)
        local dest_y = sel.dst_y + 3
        if sel.vx > 0 then dest_x = ceil(dest_x) end
        if sel.vy > 0 then dest_y = ceil(dest_y) end
        local cfg = {
            stiffness = 100,
            damping = 20,
            mass = 2,
            precision = 0.1,
        }
        Z_x, Z_vx = spring(Z_x, dest_x, Z_vx, cfg)
        Z_y, Z_vy = spring(Z_y, dest_y, Z_vy, cfg)
    end
end

local function draw_X_btn(x, y)
    local s = max(0, (X_t\2)%(SHINE_DELAY+11) - SHINE_DELAY)
    sspr(s*9, 24, 9, 8, x, y)
    pset(x+3, y+2, C.dark_blue)
    pset(x+5, y+2)
    pset(x+3, y+4)
    pset(x+5, y+4)
    pset(x+4, y+3)
end

local function draw_hint_X()
    -- Draw arrow
    if cur_map == 1 then
        spr(20, 25, X_pos)
    elseif cur_map == 2 then
        spr(21, 1, X_pos)
    else
        spr(21, X_pos, 50)
    end
    -- Draw button
    if cur_map == 1 then
        draw_X_btn(30, X_pos)
    elseif cur_map == 2 then
        draw_X_btn(10, X_pos)
    else
        draw_X_btn(X_pos, 43)
    end
end

local function draw_hint_Z()
    -- Draw arrow
    local flip = sel.dst_x < FLIP_Y
    sspr(32, 8, 5, 8, Z_x+(flip and -6 or 10), Z_y, 5, 8, not flip)

    -- Draw button
    local s = max(0, (Z_t\2)%(SHINE_DELAY+11) - SHINE_DELAY)
    if Z_t <= FADE_DURATION then -- fade in
        local c = Z_t < 4 and C.dark_blue or C.dark_gray
        pal({
            [1]=C.black,  -- dark blue
            [6]=c,        -- light gray
            [10]=c,       -- yellow
            [13]=C.black, -- indigo
        })
    end
    sspr(s*9, 24, 9, 8, Z_x, Z_y)
    -- draw 'o'
    rect(Z_x+3, Z_y+2, Z_x+5, Z_y+4, C.dark_blue)
end

function draw_hint()
    pal(C.green, C.black)
    draw_hint_X()
    if can_show_hint_Z() then
        draw_hint_Z()
    end
    pal(0)
end
