-- BUTTON = {
--   z = 4,
--   x = 5,
-- }

COLOR = {
    black = 0,
    dark_blue = 1,
    dark_purple = 2,
    dark_green = 3,
    brown = 4,
    dark_gray = 5,
    light_gray = 6,
    white = 7,
    red = 8,
    orange = 9,
    yellow = 10,
    green = 11,
    blue = 12,
    indigo = 13,
    pink = 14,
    peach = 15,
}

map = {
    {x = 0,  y = 24},
    {x = 104, y = 24},
    {x = 104, y = 54},
    {x = 24, y = 54},
    {x = 24, y = 94},
    {x = 104, y = 94},
    {x = 104, y = 127},
}

enemies = {}
towers = {}
bullets = {}

function make_enemy(x, y)
    local e = {
        x = x, y = y,
        dx = 0, dy = 0,
        hp = 3, max_hp = 3,
        can_remove = false,
    }
    add(enemies, e)
    return e
end

function make_tower(type, x, y)
    local twr = {
        type = type,
        -- x and y denote the center of the tower
        x = x, y = y,
        range = 28
    }
    add(towers, twr)
    return twr
end

function make_bullet(x, y, enemy)
    local b = {
        x = x, y = y,
        enemy = enemy,
    }
    add(bullets, b)
    return b
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
    local e = make_enemy(map[1].x, map[1].y)
    local _ = make_tower(2, 44, 44)
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
        if line_contains_point(map[p-1], map[p], e) then
            l1 = map[p-1]
            l2 = map[p]
            break
        end
        p += 1
    end
    assert(l1)

    if e.dx ~= 0 then -- moving horizontally
        local right = e.dx > 0
        local edge_x = right and max(l1.x, l2.x) or min(l1.x, l2.x)
        local overflow = right and ((e.x + e.dx) - edge_x) or (edge_x - (e.x + e.dx))
        -- If the new position would go out of bounds on the path, split the
        -- travel distance into horizontal and vertical movement.
        if overflow > 0 then
            e.x = edge_x
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
        local edge_y = down and max(l1.y, l2.y) or min(l1.y, l2.y)
        local overflow = down and ((e.y + e.dy) - edge_y) or (edge_y - (e.y + e.dy))
        if overflow > 0 then
            e.y = edge_y
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

function is_in_range(e, twr)
    return (e.x - twr.x)^2 + (e.y - twr.y)^2 < twr.range^2
end

function move_bullet(b)
end

function create_bullet(twr)
    if t() % 20 then
        -- Find enemy in range of tower
        for e in all(enemies) do
            if is_in_range(e, twr) then
                local b = make_bullet(twr.x, twr.y, e)
                break
            end
        end
    end
end

-- _UPDATE (called once per update at 30fps)
function _update()
    foreach(enemies, move_enemy)
    -- Remove enemies that have gone off screen
    enemies = tbl_filter(enemies, function(e) return not e.can_remove end)
    foreach(bullet, move_bullet)
    foreach(towers, create_bullet)
end

-- _DRAW (called once per visible frame)
function _draw()
    cls(COLOR.black)

    -- Draw grid lines
    for y = 9, 127, 10 do
        line(0, y, 127, y, COLOR.dark_blue)
    end
    for x = 9, 127, 10 do
        line(x, 0, x, 127, COLOR.dark_blue)
    end

    -- Draw path
    local function round(v, up)
        return (flr((v+1)/10) + (up and 1 or 0)) * 10 - 1
    end
    for p = 2, #map do
        rectfill(round(map[p-1].x), round(map[p-1].y),
            round(map[p].x, true), round(map[p].y, true), COLOR.black)
        rect(round(map[p-1].x), round(map[p-1].y),
            round(map[p].x, true), round(map[p].y, true), COLOR.indigo)
    end

    -- Draw enemies
    foreach(enemies, function(e)
        circ(e.x, e.y, 2, COLOR.yellow)
        local hp_y = e.y - 4
        rect(e.x-1, hp_y, e.x+1, hp_y, COLOR.dark_green)
        if e.hp > 0 then
            rect(e.x-1, hp_y, (e.x-1)+e.hp-1, hp_y, COLOR.green)
        end
    end)

    -- Draw towers
    foreach(towers, function(twr)
        spr(twr.type, twr.x-3, twr.y-3, 1, 1)
        -- range
        -- circ(twr.x, twr.y, twr.range, COLOR.light_gray)
    end)

    -- Draw bullets
    foreach(bullet, function(b)
        pset(b.x, b.y, COLOR.red)
    end)

    -- Debug
    -- print('dx:' .. enemies[1].dx)
    -- print('dy:' .. enemies[1].dy)
    -- print('x:' .. enemies[1].x)
    -- print('y:' .. enemies[1].y)
end
