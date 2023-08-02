local LETTER_HEIGHT = 19
local OFFSCREEN_Y = -LETTER_HEIGHT

local z_age, t, title_t, letters, pressing_left, pressing_right

function init_title()
    z_age = nil
    t = 0
    title_t = 0
    letters = {
        {x=0,  w=13}, -- P
        {x=13, w=7},  -- I
        {x=21, w=17}, -- X
        {x=38, w=13}, -- E
        {x=51, w=13}, -- L
        {x=64, w=14}, -- T
        {x=78, w=13}, -- D
    }
    -- saving tokens..
    for l in all(letters) do
        l.y = OFFSCREEN_Y
        l.v = 0
        l.dest_y = 13
    end
end

function update_title()
    if title_t < 100 then title_t += 1 end
    t += 1
    if z_age then
        z_age += 1
        if z_age >= 60 then
            screen = 'game'
            return
        end
    end
    -- Handle button press
    if z_age == nil then
        if btnp(🅾️) then -- start game
            sfx(35)
            z_age = 0
            music(-1, 1000) -- fade title music out
        end
        -- Don't dim if btn pressed down while disabled
        if pressing_right or (not pressing_right and cur_map < #maps) then
            pressing_right = btn(➡️)
        end
        if pressing_left or (not pressing_left and cur_map > 1) then
            pressing_left = btn(⬅️)
        end
        if btnp(⬅️) then
            if cur_map > 1 then
                sfx(30)
                cur_map -= 1
            else
                sfx(31)
            end
        end
        if btnp(➡️) then
            if cur_map < #maps then
                sfx(30)
                cur_map += 1
            else
                sfx(31)
            end
        end
    end

    -- Send letters up
    if z_age and z_age >= 10 then
        for i, l in pairs(letters) do
            if l.dest_y ~= OFFSCREEN_Y and z_age >= (10+(i-1)*2) then
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

local function draw_arrow_btn(is_left, y)
    local can_press, is_pressed
    if is_left then
        can_press = cur_map > 1 or pressing_left
        is_pressed = pressing_l
    else
        can_press = cur_map < #maps or pressing_right
        is_pressed = pressing_r
    end
    sspr(
        80, not can_press and 80 or is_pressed and 72 or 64,
        9, 8, is_left and 40 or 80, 49, 9, 8, is_left
    )
end

function draw_title()
    -- Draw map
    draw_path(t)

    -- Draw title
    pal(Pink, Black)
    for l in all(letters) do
        sspr(l.x, 32, l.w, LETTER_HEIGHT, 19+l.x, l.y)
    end
    pal(0)

    -- Draw difficulty
    if z_age == nil or z_age < 27 then
        pal(Green, Black)
        -- fade out
        if z_age and z_age > 14 then
            local c = z_age < 22 and DarkGray or DarkBlue
            pal{
                [DarkBlue]=Black,
                [LightGray]=c,
                [Red]=c,
                [Yellow]=c,
                [Indigo]=Black,
            }
        end
        -- Draw arrow buttons
        draw_arrow_btn(true)
        draw_arrow_btn(false)

        -- Draw start button
        local x = hcenter'start' + 3
        print_outlined('start', x, 74, LightGray)
        sspr(96, pressing_z and 72 or 64, 9, 8, x-13, 74-1)
        pal(0)

        local str2 = ({'easy', 'medium', 'hard'})[cur_map]
        print_outlined(str2, hcenter(str2), 50, ({Green, Yellow, Red})[cur_map])
    end
end
