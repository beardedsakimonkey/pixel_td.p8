show_hint_x = false
local OFFSCREEN_Y = -8
local y = OFFSCREEN_Y
local v = 0
local t = 0

local GLISTEN_DELAY = 300 -- 10 sec

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
        v = 200
    end
    local dest_y = show_hint_x and 1 or OFFSCREEN_Y
    y, v = spring(y, dest_y, v, {
        stiffness = 200,
        damping = 32,
        mass = 2,
        precision = 0.2,
    })
end

local function draw_hint_x()
    local x = 26
    -- Draw arrow
    spr(20, x, y)
    x += 6
    -- Draw button
    local s = max(0, (t\2)%(GLISTEN_DELAY+11) - GLISTEN_DELAY)
    sspr(s*9, 24, 9, 8, x, y)

    -- draw 'x'
    pset(x+3, y+2, C.dark_blue)
    pset(x+5, y+2, C.dark_blue)
    pset(x+3, y+4, C.dark_blue)
    pset(x+5, y+4, C.dark_blue)
    pset(x+4, y+3, C.dark_blue)
end

local function draw_hint_z()
    -- Draw arrow
    local flip = sel.x < 20
    local x = sel.x + (flip and 16 or -8)
    local y = sel.y + 3
    if sel.vx > 0 then x = ceil(x) end
    if sel.vy > 0 then y = ceil(y) end
    sspr(32, 8, 5, 8, x, y, 5, 8, not flip)
    if flip then
        x += 6
    else
        x -= 10
    end

    -- Draw button
    local s = max(0, (t\2)%(GLISTEN_DELAY+11) - GLISTEN_DELAY)
    sspr(s*9, 24, 9, 8, x, y)
    -- draw 'o'
    rect(x+3, y+2, x+5, y+4, C.dark_blue)
end

function draw_hint()
    pal(C.green, C.black)
    draw_hint_x()
    if show_hint_z() then
        draw_hint_z()
    end
    pal(0)
end
