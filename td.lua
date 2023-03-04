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
        can_remove = false,
    }
    add(enemies, e)
    return e
end

function tbl_filter(t, fn)
    local res = {}
    foreach(t, function(v)
        if fn(v) then
            add(res, v)
        end
    end)
    return res
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

    if e.dx ~= 0 then -- moving horizontally
        local right = e.dx > 0
        local lim_x = right and max(l1.x, l2.x) or min(l1.x, l2.x)
        local overflow = right and ((e.x + e.dx) - lim_x) or (lim_x - (e.x + e.dx))
        if overflow > 0 then
            e.x = lim_x
            if map[p+1] then
                local going_down = map[p+1].y > map[p].y
                e.y = e.y + (going_down and overflow or -overflow)
                -- update direction
                e.dy = going_down and abs(e.dx) or -abs(e.dx)
                e.dx = 0
            else
                e.can_remove = true
            end
        else
            e.x += e.dx
        end
    elseif e.dy ~= 0 then -- moving vertically
        local down = e.dy > 0
        local lim_y = down and max(l1.y, l2.y) or min(l1.y, l2.y)
        local overflow = down and ((e.y + e.dy) - lim_y) or (lim_y - (e.y + e.dy))
        if overflow > 0 then
            e.y = lim_y
            if map[p+1] then
                local going_right = map[p+1].x > map[p].x
                e.x = e.x + (going_right and overflow or -overflow)
                -- update direction
                e.dx = going_right and abs(e.dy) or -abs(e.dy)
                e.dy = 0
            else
                e.can_remove = true
            end
        else
            e.y += e.dy
        end
    end
end

-- _UPDATE (called once per update at 30fps)
function _update()
    foreach(enemies, move_enemy)
    enemies = tbl_filter(enemies, function(e) return not e.can_remove end)
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

    -- Debug
    -- print('dx:' .. enemies[1].dx)
    -- print('dy:' .. enemies[1].dy)
    -- print('x:' .. enemies[1].x)
    -- print('y:' .. enemies[1].y)
end
