-- TODO: add hint for z
-- TODO: dont show hint for x until player has bought a tower

show_hint = true

local prev_show_hint = show_hint

local OFFSCREEN_Y = -6
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
    local dest_y = show_hint and 2 or OFFSCREEN_Y
    y, v = spring(y, dest_y, v, {
        stiffness = 200,
        damping = 32,
        mass = 2,
        precision = 0.2,
    })
    prev_show_hint = show_hint
end

function draw_hint()
    local x = 27
    -- Draw arrow
    pal(C.green, C.black)
    spr(20, x-1, y-1)
    pal(0)
    x += 6
    -- Draw button
    local glisten_delay = 300 -- 10 sec
    local s = 48 + max(0, (t\2)%(glisten_delay+11) - glisten_delay)
    spr(s, x, y)
end
