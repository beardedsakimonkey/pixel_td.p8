show_hint = true

local prev_show_hint = show_hint

local OFFSCREEN_Y = -6
local hint_y = OFFSCREEN_Y
local hint_v = 0

function update_hint()
    show_hint = show_hint or can_send_wave()
    if show_hint ~= prev_show_hint then
        hint_v = 200
    end
    local dest_y = show_hint and 2 or OFFSCREEN_Y
    hint_y, hint_v = spring(hint_y, dest_y, hint_v, {
        stiffness = 200,
        damping = 32,
        mass = 2,
        precision = 0.2,
    })
    prev_show_hint = show_hint
end

function draw_hint()
    local x = 27
    spr(20, x + (cos(time()/2)+2)*1.2 - 2, hint_y)
    x += 6
    print('❎', x, hint_y+1, C.indigo)
    rectfill(x+2, hint_y+1, x+4, hint_y+3, C.black)
    print('❎', x, hint_y, C.light_gray)
end
