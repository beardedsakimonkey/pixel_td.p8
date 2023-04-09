enemies = {}
-- Helps impl of enemy movement
local path_points = {}

function make_enemy(hp)
    add(enemies, {
        x=path_points[1].x,
        y=path_points[1].y,
        dx=0, dy=0.5,
        hp=hp, max_hp=hp,
    })
end

function init_enemy_aux()
    for i = 1, #map do
        local p = g2p(map[i])
        add(path_points, {
            x = p.left + 6,
            y = p.top + 6,
        })
    end
end

local function line_contains_point(l1, l2, p)
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

local function move_enemy(e)
    -- Find the first line in the map that contains our position
    local l1, l2
    local p = 2
    while p <= #path_points do
        if line_contains_point(path_points[p-1], path_points[p], e) then
            l1 = path_points[p-1]
            l2 = path_points[p]
            break
        end
        p += 1
    end
    assert(l1) -- enemy should always be on the path

    if e.dx ~= 0 then -- moving horizontally
        local right = e.dx > 0
        local edge_x = right and max(l1.x, l2.x) or min(l1.x, l2.x)
        local overflow = right and ((e.x + e.dx) - edge_x)
                                or (edge_x - (e.x + e.dx))
        -- If the new position would go out of bounds on the path, split the
        -- travel distance into horizontal and vertical movement.
        if overflow > 0 then
            e.x = edge_x
            if path_points[p+1] then
                local going_down = path_points[p+1].y > path_points[p].y
                e.y = e.y + (going_down and overflow or -overflow)
                -- update direction
                e.dy = going_down and abs(e.dx) or -abs(e.dx)
                e.dx = 0
            else
                -- enemy got to the end
                e.hp = 0
                remove_life()
            end
        else
            e.x += e.dx
        end
    elseif e.dy ~= 0 then -- moving vertically
        local down = e.dy > 0
        local edge_y = down and max(l1.y, l2.y) or min(l1.y, l2.y)
        local overflow = down and ((e.y + e.dy) - edge_y)
                               or (edge_y - (e.y + e.dy))
        if overflow > 0 then
            e.y = edge_y
            if path_points[p+1] then
                local going_right = path_points[p+1].x > path_points[p].x
                e.x = e.x + (going_right and overflow or -overflow)
                -- update direction
                e.dx = going_right and abs(e.dy) or -abs(e.dy)
                e.dy = 0
            else
                -- enemy got to the end
                e.hp = 0
                remove_life()
            end
        else
            e.y += e.dy
        end
    end
end

local function del_enemy(enmy)
    if enmy.hp == 0 then
        del(enemies, enmy)
    end
end

function update_enemies()
    foreach(enemies, move_enemy)
    foreach(enemies, del_enemy)
end

function draw_enemies()
    foreach(enemies, function(enmy)
        -- Draw enemy
        circ(enmy.x, enmy.y, 1, C.light_gray)
        -- Draw hp
        local hp_y = enmy.y - 4
        rect(enmy.x-1, hp_y, enmy.x+1, hp_y, C.dark_green)
        local hp_rem = ceil(enmy.hp / enmy.max_hp*3)
        rect(enmy.x-1, hp_y, (enmy.x-1)+hp_rem-1, hp_y, C.green)
    end)
end
