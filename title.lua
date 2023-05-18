-- TODO: animate each letter seperately, staggered

local TITLE_HEIGHT = 19
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
    sspr(0, 32, 90, TITLE_HEIGHT, 20, y)
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

    -- if not started then
    --     print('🅾️ to start', 43, 100, C.light_gray)
    -- end
end
