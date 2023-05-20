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
    local dest_y = not z_age and 12 or OFFSCREEN_Y
    for i, l in pairs(letters) do
        if t >= (i-1)*2 then
            l.y, l.v = spring(l.y, dest_y, l.v, {
                stiffness = 200,
                damping = 12,
                mass = 3,
                precision = 0.2,
            })
        end
    end
end

local function g2p33(cell)
    local top  = cell.y * 3
    local left = cell.x * 3
    return {top=top, left=left, bot=top+2, right=left+2}
end

local function draw_map(x, y)
    -- Draw borders
    rect(x-2, y-2, x+32+2, y+32+2, C.black)
    rect(x-1, y-1, x+32+1, y+32+1, C.light_gray)

    -- Draw background
    rectfill(x, y, x+32, y+32, C.dark_blue)

    -- Draw path
    for i = 2, #map do
        local cell_a, cell_b = map[i-1], map[i]
        local ca = get_cell_corner(g2p33(cell_a), cell_a.c)
        local cb = get_cell_corner(g2p33(cell_b), cell_b.c)
        rectfill(x+ca.x, y+ca.y, x+cb.x, y+cb.y, C.indigo)
    end

    -- Draw inner border
    rect(x, y, x+32, y+32, C.dark_blue)
end

function draw_title()
    -- Draw title
    pal(C.pink, C.black)
    -- sspr(0, 32, 90, LETTER_HEIGHT, 19, y)
    for l in all(letters) do
        sspr(l.x, 32, l.w, LETTER_HEIGHT, 19+l.x, l.y)
    end
    pal(0)

    -- Draw map (33x33)
    draw_map(7, 52)
    pal({
        [1]=C.black,
        [6]=C.dark_blue,
        [13]=C.dark_blue,
    })
    draw_map(48, 52)
    draw_map(89, 52)
    pal(0)

    do
        local y = 99
        -- Draw buttons
        pal(C.green, C.black)
        sspr(96, 32, 9, 8, 38, y-1, 9, 8, true)
        sspr(96, 32, 9, 8, 80, y-1)
        pal(0)

        -- Draw difficulty
        local str = 'easy'
        local x = 56
        rectfill(x-1, y-1, x-1+(#str*4-1)+1, y-1+6, C.black)
        print(str, x, y, C.light_gray)
    end
end
