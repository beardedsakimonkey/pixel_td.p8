--[[

Juice:
- enemies bob up and down
- animate selection movement
- animation when trying to move selection fails
- bottom hud animates up/down
- screen shake on enemy reaching end
- spinning coin

Notes:
- x to send wave (if you're selecting a tower, it'll sell the tower, but you can
    just rebuy it without losing money)

]]

corner = {TL=1, TR=2, BL=3, BR=4, TOP=5, LEFT=6, RIGHT=7, BOT=8}

map = {
    {x=1,  y=0,  c=corner.TOP},
    {x=1,  y=3,  c=corner.BL},
    {x=3,  y=3,  c=corner.BR},
    {x=3,  y=1,  c=corner.TL},
    {x=6,  y=1,  c=corner.TR},
    {x=6,  y=3,  c=corner.BL},
    {x=8,  y=3,  c=corner.BR},
    {x=8,  y=1,  c=corner.TL},
    {x=11, y=1,  c=corner.TR},
    {x=11, y=6,  c=corner.BR},
    {x=1,  y=6,  c=corner.TL},
    {x=1,  y=10, c=corner.BL},
    {x=4,  y=10, c=corner.BR},
    {x=4,  y=8,  c=corner.TL},
    {x=8,  y=8,  c=corner.TR},
    {x=8,  y=10, c=corner.BL},
    {x=12, y=10, c=corner.RIGHT},
}

-- 2d array containing 1s for grid cells that are on the path and 0s otherwise
grid_bitmap = {}

local function init_grid_bitmap()
    for i = 1, 13 do
        add(grid_bitmap, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end
    for i = 2, #map do
        local ca, cb = map[i-1], map[i]
        if ca.x == cb.x then
            local step = ca.y < cb.y and 1 or -1
            for j = ca.y, cb.y, step do
                grid_bitmap[j+1][ca.x+1] = 1
            end
        elseif ca.y == cb.y then
            local step = ca.x < cb.x and 1 or -1
            for j = ca.x, cb.x, step do
                grid_bitmap[ca.y+1][j+1] = 1
            end
        end
    end
end

-- Array of points of the path. Helps impl of enemy movement.
path_points = {}

local function init_path_points()
    for i = 1, #map do
        add(path_points, {
            x = map[i].x * 10 + 4,
            y = map[i].y * 10 + 4,
        })
    end
end

-- Selection (not using grid coordinates because of animation)
sel = {
    -- Note: coordinates are of the top left corner of the cell
    dest_x=50, dest_y=50,
    -- for animation
    cur_x=50, cur_y=50,
    dx=0, dy=0,
}

enemies = {}
-- towers = {}

function make_enemy(x, y, dx, dy)
    local e = {
        x=x, y=y,
        dx=dx, dy=dy,
        hp=3, max_hp=3,
        can_remove=false,
    }
    add(enemies, e)
    return e
end

-- function make_tower(type, x, y)
--     local twr = {
--         type = type,
--         -- x and y denote the center of the tower
--         x = x, y = y,
--         range = 28,
--         bullets = {},
--         -- controls when the turret can deal damage
--         cd = 0,
--         is_attacking = false,
--     }
--     add(towers, twr)
--     return twr
-- end

-- function make_bullet(x, y, enemy)
--     local b = {
--         x = x, y = y,
--         enemy = enemy,
--     }
--     return b
-- end

-- _INIT (called once on startup)
function _init()
    -- Set up auxiliary data structures
    init_grid_bitmap()
    init_path_points()

    make_enemy(path_points[1].x, path_points[1].y, 0, 1)
    -- make_tower(0, 44, 44)
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
    while p <= #path_points do
        if line_contains_point(path_points[p-1], path_points[p], e) then
            l1 = path_points[p-1]
            l2 = path_points[p]
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
            if path_points[p+1] then
                local going_down = path_points[p+1].y > path_points[p].y
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
            if path_points[p+1] then
                local going_right = path_points[p+1].x > path_points[p].x
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

-- -- Todo: perf
-- function is_in_range(e, twr)
--     return (((e.x - twr.x)^2) + ((e.y - twr.y)^2)) < (twr.range^2)
-- end

-- function move_bullet(b)
-- end

-- function create_bullets(twr)
--     if twr.cd > 0 then return end
--     -- Find enemy in range of tower
--     for e in all(enemies) do
--         if is_in_range(e, twr) then
--             add(twr.bullets, make_bullet(x, y, e))
--             twr.cd = 1
--             e.hp = max(0, e.hp-1) -- instant damage from laser
--             break
--         end
--     end
-- end

-- function delete_bullets(twr)
--     for b in all(twr.bullets) do
--         if not is_in_range(b.enemy, twr) then
--             twr.bullets = {}
--             twr.cd = 0
--         end
--     end
-- end

local function try_move_selection(dir)
    -- convert selection to grid coordinates
    local cur_cell_x = sel.dest_x / 10
    local cur_cell_y = sel.dest_y / 10

    -- find destination cell
    local dst_cell_x = cur_cell_x
    local dst_cell_y = cur_cell_y
    local dx = dir == B.right and 1 or dir == B.left and -1 or 0
    local dy = dir == B.down and  1 or dir == B.up   and -1 or 0
    while true do
        dst_cell_x += dx
        dst_cell_y += dy

        -- don't move past boundaries
        if dst_cell_x <= 0 or dst_cell_y <= 0 or
            dst_cell_x >= 12 or dst_cell_y >= 12 then
            return
        end
        if grid_bitmap[dst_cell_y+1][dst_cell_x+1] == 0 then
            break
        end
    end

    -- move selection
    sel.dest_x = dst_cell_x * 10
    sel.dest_y = dst_cell_y * 10
    if dir == B.left then
        sel.dx = -4
    elseif dir == B.right then
        sel.dx = 4
    elseif dir == B.up then
        sel.dy = -4
    elseif dir == B.down then
        sel.dy = 4
    end
end

-- _UPDATE (called once per update at 30fps)
function _update()
    -- Update selection
    if btnp(B.left)  then try_move_selection(B.left) end
    if btnp(B.right) then try_move_selection(B.right) end
    if btnp(B.up)    then try_move_selection(B.up) end
    if btnp(B.down)  then try_move_selection(B.down) end

    if sel.dx ~= 0 then
        sel.cur_x += sel.dx
        if sel.dx > 0 and sel.cur_x > sel.dest_x
            or sel.dx < 0 and sel.cur_x < sel.dest_x then
            sel.cur_x = sel.dest_x
            sel.dx = 0
        end
    end

    if sel.dy ~= 0 then
        sel.cur_y += sel.dy
        if sel.dy > 0 and sel.cur_y > sel.dest_y
            or sel.dy < 0 and sel.cur_y < sel.dest_y then
            sel.cur_y = sel.dest_y
            sel.dy = 0
        end
    end

    -- Move enemies
    foreach(enemies, move_enemy)
    -- Remove enemies that have gone off screen
    enemies = tbl_filter(enemies, function(e) return not e.can_remove end)

    -- foreach(bullet, move_bullet)
    -- foreach(towers, function(twr)
    --     twr.cd = max(0, twr.cd-1)
    --     create_bullets(twr)
    --     if #twr.bullets > 0 then
    --         delete_bullets(twr)
    --     end
    -- end)
end

local function get_cell_corner(cell)
    local top   = (cell.y * 10) - 1
    local left  = (cell.x * 10) - 1
    local bot   = top + 10
    local right = left + 10
    if cell.c == corner.TOP   then return {x = left, y = top} end
    if cell.c == corner.RIGHT then return {x = right, y = top} end
    if cell.c == corner.TL    then return {x = left, y = bot} end
    if cell.c == corner.BL    then return {x = right, y = bot} end
    if cell.c == corner.BR    then return {x = right, y = top} end
    if cell.c == corner.TR    then return {x = left, y = top} end
end

-- _DRAW (called once per visible frame)
function _draw()
    cls(C.black)

    -- Draw grid lines
    for y = 9, 127, 10 do line(0, y, 127, y, C.dark_blue) end
    for x = 9, 127, 10 do line(x, 0, x, 127, C.dark_blue) end

    -- Draw path
    for i = 2, #map do
        local cell_a, cell_b = map[i-1], map[i]
        local ca = get_cell_corner(cell_a)
        local cb = get_cell_corner(cell_b)
        rectfill(ca.x, ca.y, cb.x, cb.y, C.black)
        rect(ca.x, ca.y, cb.x, cb.y, C.indigo)

        -- cover up unwanted borders
        local top   = (cell_a.y * 10) - 1
        local left  = (cell_a.x * 10) - 1
        local bot   = top + 10
        local right = left + 10
        if cell_a.c == corner.BL then
            line(right, bot-1, right, top+1, C.black)
        elseif cell_a.c == corner.BR then
            line(left+1, top, right-1, top, C.black)
        elseif cell_a.c == corner.TL then
            line(left+1, bot, right-1, bot, C.black)
        elseif cell_a.c == corner.TR then
            line(left, bot-1, left, top+1, C.black)
        end
    end

    -- Draw selection
    do
        local top   = sel.cur_y
        local left  = sel.cur_x
        local bot   = top + 8
        local right = left + 8
        -- top left corner
        line(left, top, left+2, top, C.light_gray)
        line(left, top, left, top+2, C.light_gray)
        -- top right corner
        line(right, top, right-2, top, C.light_gray)
        line(right, top, right, top+2, C.light_gray)
        -- bottom left corner
        line(left, bot, left+2, bot, C.light_gray)
        line(left, bot, left, bot-2, C.light_gray)
        -- bottom right corner
        line(right, bot, right-2, bot, C.light_gray)
        line(right, bot, right, bot-2, C.light_gray)
    end

    foreach(enemies, function(e)
        -- Draw enemy
        circ(e.x, e.y, 2, C.yellow)
        -- Draw hp
        local hp_y = e.y - 4
        rect(e.x-1, hp_y, e.x+1, hp_y, C.dark_green)
        if e.hp > 0 then
            rect(e.x-1, hp_y, (e.x-1)+e.hp-1, hp_y, C.green)
        end
    end)

    -- foreach(towers, function(twr)
    --     -- Draw tower
    --     spr(twr.type, twr.x-3, twr.y-3, 1, 1)
    --     -- circ(twr.x, twr.y, twr.range, C.light_gray) -- range

    --     -- Draw bullets
    --     for b in all(twr.bullets) do
    --         line(twr.x, twr.y, b.enemy.x, b.enemy.y, C.green)
    --     end
    -- end)

    -- Debug
    color(C.red)
    -- print('dx:' .. enemies[1].dx)
    -- print('dy:' .. enemies[1].dy)
end
