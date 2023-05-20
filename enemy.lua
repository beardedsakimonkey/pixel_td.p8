sending = 0
enemies = {}
-- Helps impl of enemy movement
local path_points = {}

function init_enemy_aux()
    local map = get_map()
    for i = 1, #map do
        local p = g2p(map[i])
        add(path_points, {
            x = p.left + 6,
            y = p.top + 6,
        })
    end
end

local MAX_DEATH_AGE = 3

local function make_enemy(type, max_hp, gold, dx, dy)
    add(enemies, {
        type=type,
        x=path_points[1].x,
        y=path_points[1].y,
        dx=dx, dy=dy,
        hp=max_hp, max_hp=max_hp,
        slow=1, slow_dur=0,
        gold=gold,
        death_age=nil,
    })
end

function spawn_enemy()
    if sending > 0 then
        local w = waves[wave]
        -- Send out enemies with a 10px gap
        -- speed (px/frame) * X frames = 10px
        --  => X = 10px / speed
        local frames = flr(10/w.speed)
        if t % frames == 0 then
            sending -= 1
            local dx, dy = 0, 0
            local map = get_map()
            if     map[1].c == CRNR.top   then dy = w.speed
            elseif map[1].c == CRNR.left  then dx = w.speed
            elseif map[1].c == CRNR.right then dx = -w.speed
            elseif map[1].c == CRNR.bot   then dy = -w.speed end
            if w.boss_hp and sending == 0 then
                make_enemy(ENMY.boss, w.boss_hp, w.boss_gold, dx, dy)
            else
                make_enemy(w.type, w.hp, w.gold, dx, dy)
            end
        end
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
    if e.death_age then return end
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
                e.death_age = MAX_DEATH_AGE
                remove_life()
            end
        else
            e.x += (e.dx * e.slow)
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
                e.death_age = MAX_DEATH_AGE
                remove_life()
            end
        else
            e.y += (e.dy * e.slow)
        end
    end
end

function update_enemies()
    foreach(enemies, function(enmy)
        -- update death animation
        if enmy.death_age then
            enmy.death_age += 1
        end
        -- update slow
        if enmy.slow_dur == 0 then
            enmy.slow = 1
        else
            enmy.slow_dur -= 1
        end
        -- update position
        move_enemy(enmy)
    end)
    foreach(enemies, function(enmy)
        -- delete enemy
        if enmy.hp == 0 and enmy.death_age == MAX_DEATH_AGE then
            del(enemies, enmy)
        end
    end)
end

function draw_enemies()
    foreach(enemies, function(enmy)
        -- Draw enemy
        if enmy.death_age then
            circ(enmy.x, enmy.y, enmy.death_age+1, C.pink)
            return
        end
        if enmy.type == ENMY.circ then
            circ(enmy.x, enmy.y, 1, C.light_gray)
        elseif enmy.type == ENMY.square then
            rect(enmy.x-1, enmy.y-1, enmy.x+1, enmy.y+1, C.light_gray)
        elseif enmy.type == ENMY.rect then
            rect(enmy.x-2, enmy.y-1, enmy.x+2, enmy.y+1, C.light_gray)
        elseif enmy.type == ENMY.diamond then
            line(enmy.x, enmy.y-2, enmy.x-2, enmy.y, C.light_gray) -- top left
            line(enmy.x, enmy.y+2) -- bot left
            line(enmy.x+2, enmy.y) -- bot right
            line(enmy.x, enmy.y-2) -- top right
        elseif enmy.type == ENMY.arrow then
            if enmy.dx ~= 0 then
                line(enmy.x, enmy.y-2,
                     enmy.x+(enmy.dx > 0 and 2 or -2), enmy.y, C.light_gray)
                line(enmy.x, enmy.y+2)
            else
                line(enmy.x-2, enmy.y,
                     enmy.x, enmy.y+(enmy.dy > 0 and 2 or -2), C.light_gray)
                line(enmy.x+2, enmy.y)
            end
        elseif enmy.type == ENMY.boss then
            circ(enmy.x, enmy.y, 2, C.yellow)
        end
        -- Draw hp
        local hp_y = enmy.y - 4
        rect(enmy.x-1, hp_y, enmy.x+1, hp_y, C.dark_green)
        local hp_rem = ceil(enmy.hp / enmy.max_hp*3)
        rect(enmy.x-1, hp_y, (enmy.x-1)+hp_rem-1, hp_y, C.green)
    end)
end

function can_send_wave()
    return sending == 0 and #enemies == 0
end

function send_wave()
    if can_send_wave() then
        wave += 1
        sending = 10
        show_hint = false
    end
end
