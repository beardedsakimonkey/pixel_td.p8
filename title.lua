-- TODO: animate each letter seperately, staggered

local TITLE_HEIGHT = 17
local OFFSCREEN_Y = -TITLE_HEIGHT
local y = OFFSCREEN_Y
local v = 0
local started = false

function update_title()
    if btnp(B.z) then
        started = true
        v = 200
    end
    local dest_y = not started and 12 or OFFSCREEN_Y
    y, v = spring(y, dest_y, v, {
        stiffness = 200,
        damping = 12,
        mass = 2,
        precision = 0.2,
    })
    if y <= OFFSCREEN_Y then
        screen = 'game'
    end
end

function draw_title()
    -- Draw title
    sspr(0, 32, 88, TITLE_HEIGHT, 20, y)
    if not started then
        print('🅾️ to start', 43, 100, C.light_gray)
    end
end
