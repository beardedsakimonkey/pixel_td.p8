-- BUTTON = {
--   z = 4,
--   x = 5,
-- }

COLOR = {
    black = 0,
    dark_blue = 1,
    white = 7,
    yellow = 10,
}

map = {
    {x = 0,  y = 34},
    {x = 94, y = 34},
    {x = 94, y = 94},
    {x = 34, y = 94},
    {x = 34, y = 127},
}

enemies = {}

function make_enemy(x, y)
    local e = {
        x = x,
        y = y,
        dx = 0,
        dy = 0,
    }
    add(enemies, e)
    return e
end

-- _INIT (called once on startup)
function _init()
    local e = make_enemy(0, 34)
    if map[1].y == map[2].y then
        e.dx = 1
    else
        e.dy = 1
    end
end

function line_contains_point(l1, l2, p)
    local is_vert = l1.x == l2.x
    if is_vert then
        return p.x == l1.x
            and p.y >= min(l1.y, l2.y)
            and p.y <= max(l1.y, l2.y)
    else
        return p.y == l1.y
            and p.x >= min(l1.x, l2.x)
            and p.x <= max(l1.x, l2.x)
    end
end

function move_enemy(e)
    -- Find the first line in the map that contains our position
    local l1, l2
    local p = 2
    while p <= #map do
        if line_contains_point(map[p-1], map[p], {x=e.x, y=e.y}) then
            l1 = map[p-1]
            l2 = map[p]
            break
        end
        p += 1
    end
    assert(l1)

    if e.dx > 0 then -- moving right
        local max_x = max(l1.x, l2.x)
        if e.x + e.dx > max_x then -- overflow
            local overflow = e.x + e.dx - max_x
            e.x = max_x
            local going_down = map[p+1] and map[p+1].y > map[p].y
            e.y = e.y + (going_down and overflow or -overflow)
            -- update direction
            e.dy = going_down and abs(e.dx) or -abs(e.dx)
            e.dx = 0
        else -- no overflow
            e.x += e.dx
        end
    elseif e.dx < 0 then -- moving left
        local min_x = min(l1.x, l2.x)
        if e.x + e.dx < min_x then -- overflow
            local overflow = min_x - e.x + e.dx
            e.x = min_x
            local going_down = map[p+1] and (map[p+1].y > map[p].y)
            e.y = e.y + (going_down and overflow or -overflow)
            -- update direction
            e.dy = going_down and abs(e.dx) or -abs(e.dx)
            e.dx = 0
        else -- no overflow
            e.x += e.dx
        end
    elseif e.dy > 0 then -- moving down
        local max_y = max(l1.y, l2.y)
        if e.y + e.dy > max_y then -- overflow
            local overflow = e.y + e.dy - max_y
            e.y = max_y
            local going_right = map[p+1] and map[p+1].x > map[p].x
            e.x = e.x + (going_right and overflow or -overflow)
            -- update direction
            e.dx = going_right and abs(e.dy) or -abs(e.dy)
            e.dy = 0
        else -- no overflow
            e.y += e.dy
        end
    elseif e.dy < 0 then -- moving up
        local min_y = min(l1.y, l2.y)
        if e.y + e.dy < min_y then -- overflow
            local overflow = min_y - e.y + e.dy
            e.y = min_y
            local going_right = map[p+1] and map[p+1].x > map[p].x
            e.x = e.x + (going_right and overflow or -overflow)
            -- update direction
            e.dx = going_right and abs(e.dy) or -abs(e.dy)
            e.dy = 0
        else -- no overflow
            e.y += e.dy
        end
    end
end

-- _UPDATE (called once per update at 30fps)
function _update()
    foreach(enemies, move_enemy)
end

-- _DRAW (called once per visible frame)
function _draw()
    cls(COLOR.black)

    -- Draw grid lines
    for y = 9, 128, 10 do
        line(0, y, 127, y, COLOR.dark_blue)
    end
    for x = 9, 128, 10 do
        line(x, 0, x, 127, COLOR.dark_blue)
    end

    -- Draw path
    for p = 2, #map do
        line(map[p-1].x, map[p-1].y, map[p].x, map[p].y, COLOR.white)
    end

    -- Draw enemies
    foreach(enemies, function(e)
        circ(e.x, e.y, 2, COLOR.yellow)
    end)
end
