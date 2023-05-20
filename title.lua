local LETTER_HEIGHT = 19
local OFFSCREEN_Y = -LETTER_HEIGHT
local z_age = nil
local t = 0
local letters = {
    {x=0,  w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- P
    {x=13, w=7,  y=OFFSCREEN_Y, v=0, dest_y=12}, -- I
    {x=21, w=17, y=OFFSCREEN_Y, v=0, dest_y=12}, -- X
    {x=38, w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- E
    {x=51, w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- L
    {x=64, w=14, y=OFFSCREEN_Y, v=0, dest_y=12}, -- T
    {x=78, w=13, y=OFFSCREEN_Y, v=0, dest_y=12}, -- D
}

function update_title()
    t += 1
    if z_age then
        z_age += 1
        if z_age >= 50 then
            screen = 'game'
            return
        end
    end
    if btnp(B.z) then
        z_age = 0
    end

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
        if t >= (i-1)*2 then
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
    draw_path()

    -- Draw title
    pal(C.pink, C.black)
    for l in all(letters) do
        sspr(l.x, 32, l.w, LETTER_HEIGHT, 19+l.x, l.y)
    end
    pal(0)

    -- Draw difficulty
    do
        local y = 62
        pal(C.green, C.black)
        sspr(96, 32, 9, 8, 38, y-1, 9, 8, true)
        sspr(96, 32, 9, 8, 80, y-1)
        pal(0)

        local str = 'easy'
        local x = 56
        rectfill(x-1, y-1, x-1+(#str*4-1)+1, y-1+6, C.black)
        print(str, x, y, C.light_gray)
    end
end
