local LETTER_HEIGHT = 19
local OFFSCREEN_Y = -LETTER_HEIGHT

local z_age
local t
local title_t -- non-wrapping `t`
local letters
local pressing_l, pressing_r, pressing_z

function init_title()
    z_age = nil
    t = 0
    title_t = 0
    letters = {
        {x=0,  w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- P
        {x=13, w=7,  y=OFFSCREEN_Y, v=0, dest_y=12}, -- I
        {x=21, w=17, y=OFFSCREEN_Y, v=0, dest_y=12}, -- X
        {x=38, w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- E
        {x=51, w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- L
        {x=64, w=14, y=OFFSCREEN_Y, v=0, dest_y=12}, -- T
        {x=78, w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- D
    }
end

function update_title()
    if title_t < 100 then title_t += 1 end
    t += 1
    if z_age then
        z_age += 1
        if z_age >= 50 then
            screen = 'game'
            return
        end
    end
    -- Handle button press
    if z_age == nil then
        if btnp(B.z) then
            z_age = 0
        end
        if btnp(B.left) then
            sel_map = wrap(1, sel_map-1, #maps)
        end
        if btnp(B.right) then
            sel_map = wrap(1, sel_map+1, #maps)
        end
    end
    pressing_l = btn(B.left)
    pressing_r = btn(B.right)
    pressing_z = btn(B.z)

    -- Send letters up
    if z_age then
        for i, l in pairs(letters) do
            if l.dest_y ~= OFFSCREEN_Y and z_age >= (i-1)*2 then
                l.dest_y = OFFSCREEN_Y
                l.v = 300
            end
        end
    end

    -- Update letters
    for i, l in pairs(letters) do
        if title_t >= (i-1)*2 then -- staggering
            if l.dest_y == OFFSCREEN_Y and l.y <= OFFSCREEN_Y then
                -- avoid letter bouncing back out from the top
            else
                l.y, l.v = spring(l.y, l.dest_y, l.v, {
                    stiffness = 180,
                    damping = 14,
                    mass = 3,
                    precision = 0.1,
                })
            end
        end
    end
end

function draw_title()
    -- Draw map
    draw_path(t)

    -- Draw title
    pal(C.pink, C.black)
    for l in all(letters) do
        sspr(l.x, 32, l.w, LETTER_HEIGHT, 19+l.x, l.y)
    end
    pal(0)

    -- Draw difficulty
    if z_age == nil or z_age < 27 then
        local y = 54
        pal(C.green, C.black)
        if z_age and z_age > 14 then -- fade out
            local c = z_age < 22 and C.dark_gray or C.dark_blue
            pal({
                [1]=C.black,  -- dark blue
                [6]=c,        -- light gray
                [10]=c,       -- yellow
                [13]=C.black, -- indigo
            })
        end
        -- draw buttons
        sspr(pressing_l and 112 or 96, 32, 9, 8, 38, y-1, 9, 8, true)
        sspr(pressing_r and 112 or 96, 32, 9, 8, 80, y-1)

        local str = sel_map == 1 and 'easy' or sel_map == 2 and 'medium' or 'hard'
        local c = sel_map == 3 and C.red or C.yellow
        print_outlined(str, center_horz(str), y, c, C.black)

        local str2 = 'start'
        local y2 = 73
        print_outlined(str2, center_horz(str2)+2, y2, C.light_gray, C.black)
        sspr(pressing_z and 112 or 96, 40, 9, 8, 43, y2-1)
        pal(0)
    end
end
