-- TODO: add hint for z
-- TODO: dont show hint for x until player has bought a tower

show_hint = true

local prev_show_hint = show_hint

local OFFSCREEN_Y = -8
local y = OFFSCREEN_Y
local v = 0
local t = 0

function update_hint()
    show_hint = show_hint or (can_send_wave() and not bonus_menu.is_open)
    if show_hint then
        t += 1
    else
        t = 0
    end
    if prev_show_hint and not show_hint then -- dismissing hint
        v = 200
    end
    local dest_y = show_hint and 1 or OFFSCREEN_Y
    y, v = spring(y, dest_y, v, {
        stiffness = 200,
        damping = 32,
        mass = 2,
        precision = 0.2,
    })
    prev_show_hint = show_hint
end

function draw_hint()
    local x = 26
    -- Draw arrow
    pal(C.green, C.black)
    spr(20, x, y)
    x += 6
    -- Draw button
    local glisten_delay = 300 -- 10 sec
    local s = max(0, (t\2)%(glisten_delay+11) - glisten_delay)
    sspr(s*9, 24, 9, 8, x, y)

    -- draw 'x'
    pset(x+3, y+2, C.dark_blue)
    pset(x+5, y+2, C.dark_blue)
    pset(x+3, y+4, C.dark_blue)
    pset(x+5, y+4, C.dark_blue)
    pset(x+4, y+3, C.dark_blue)
    pal(0)
end
