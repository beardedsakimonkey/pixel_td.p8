local OFFSCREEN_Y = -8
local x_y, x_v
local z_y, z_vy, z_x, z_vx
local t

local GLISTEN_DELAY = 300 -- 10 sec
local FLIP_Y = 20

function init_hint()
    show_hint_x = false
    x_y = OFFSCREEN_Y
    x_v = 0
    z_vy, z_vx = 0, 0
    z_y, z_x = sel.dst_y, sel.dst_x-28
    t = 0
end

local function show_hint_z()
    return not has_opened_shop and can_send_wave()
end

function update_hint()
    local show_x = can_send_wave() and not bonus_menu.is_open and has_bought_tower

    local dismissing_x = show_hint_x and not show_x

    show_hint_x = show_x

    if show_hint_x or show_hint_z() then
        t += 1
    end
    if dismissing_x then
        t = 0
        x_v = 200
    end
    local dest_y = show_hint_x and 1 or OFFSCREEN_Y
    x_y, x_v = spring(x_y, dest_y, x_v, {
        stiffness = 200,
        damping = 32,
        mass = 2,
        precision = 0.2,
    })
    if show_hint_z() then
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
        z_x, z_vx = spring(z_x, dest_x, z_vx, cfg)
        z_y, z_vy = spring(z_y, dest_y, z_vy, cfg)
    end
end

local function draw_hint_x()
    local x = 26
    -- Draw arrow
    spr(20, x, x_y)
    x += 6
    -- Draw button
    local s = max(0, (t\2)%(GLISTEN_DELAY+11) - GLISTEN_DELAY)
    sspr(s*9, 24, 9, 8, x, x_y)

    -- draw 'x'
    pset(x+3, x_y+2, C.dark_blue)
    pset(x+5, x_y+2, C.dark_blue)
    pset(x+3, x_y+4, C.dark_blue)
    pset(x+5, x_y+4, C.dark_blue)
    pset(x+4, x_y+3, C.dark_blue)
end

local function draw_hint_z()
    -- Draw arrow
    local flip = sel.dst_x < FLIP_Y
    sspr(32, 8, 5, 8, z_x+(flip and -6 or 10), z_y, 5, 8, not flip)

    -- Draw button
    local s = max(0, (t\2)%(GLISTEN_DELAY+11) - GLISTEN_DELAY)
    if t < 10 then -- fade in
        local c = t < 4 and C.dark_blue or C.dark_gray
        pal({
            [1]=C.black,  -- dark blue
            [6]=c,        -- light gray
            [10]=c,       -- yellow
            [13]=C.black, -- indigo
        })
    end
    sspr(s*9, 24, 9, 8, z_x, z_y)
    -- draw 'o'
    rect(z_x+3, z_y+2, z_x+5, z_y+4, C.dark_blue)
end

function draw_hint()
    pal(C.green, C.black)
    draw_hint_x()
    if show_hint_z() then
        draw_hint_z()
    end
    pal(0)
end
