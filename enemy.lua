-- Helps impl of enemy movement
local path_points

function init_enemy()
    sending = 0
    enemies = {}
end

function init_path_points()
    path_points = {}
    local map = get_map()
    for i = 1, #map do
        local p = g2p(map[i])
        local cnr = map[i].cnr
        -- extend first and last point to edge of screen
        local xoff = cnr == 'left' and -6 or cnr == 'right' and 6 or 0
        local yoff = cnr == 'top'  and -6 or cnr == 'bot'   and 6 or 0
        -- move enemies down a bit to account for health bar
        yoff += (cnr ~= 'top' and cnr ~= 'bot') and 1 or 0
        add(path_points, {
            x = p.left + 6 + xoff,
            y = p.top + 6 + yoff,
        })
    end
end

local MAX_DEATH_AGE = 20

local function make_enemy(type, max_hp, gold, dx, dy)
    local size = type == 'CIRCLE' and 3 or type == 'SQUARE' and 4 or 5
    add(enemies, {
        type=type,
        x=path_points[1].x,
        y=path_points[1].y,
        dx=dx, dy=dy,
        hp=max_hp, max_hp=max_hp,
        slow=1, slow_dur=0,
        gold=gold,
        death_age=nil,
        death_particles=nil,
        width=size, height=size, -- for collision detection
        dmg_age=nil,
    })
end

function spawn_enemy()
    if sending > 0 then
        local type = wave%5==0 and 'CIRCLE' or
                     wave%4==0 and 'ARROW' or
                     wave%3==0 and 'RECTANGLE' or
                     wave%2==0 and 'DIAMOND' or 'SQUARE'
        local hp = cur_map == 3 and flr(4+2*wave^1.6) or flr(4+2*wave^1.5)
        if type == 'ARROW' then hp = flr(0.8*hp) end
        local gap = type == 'ARROW' and 12 or 10
        local speed = cur_map == 3 and (type == 'ARROW' and 1/3 or 0.25)
                                   or (type == 'ARROW' and 0.5 or 1/3)
        -- Send out enemies every X frames
        -- speed (px/frame) * X = gap (px)
        --  => X = gap / speed
        local frames = gap \ speed
        if t % frames == 0 then
            sending -= 1
            local cnr = get_map()[1].cnr
            local dx, dy = cnr=='left' and speed or cnr=='right' and -speed or 0,
                           cnr=='top' and speed or cnr=='bot' and -speed or 0
            if wave % BOSS_FREQ == 0 and sending == 0 then
                type = 'BOSS'
                hp = 10*wave
            end
            local gold = flr(4+2*sqrt(wave))
            make_enemy(type, hp, gold, dx, dy)
        end
    end
end

function kill_enemy(enmy)
    sfx(37 + rand(0, 2))
    enmy.death_age = 0
    enmy.death_particles = {
        {-1, -1},
        {1,  -1},
        {1,  1},
        {-1, 1},
        {-1, -1},
        {1,  -1},
        {1,  1},
        {-1, 1},
    }
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
            l1, l2 = path_points[p-1], path_points[p]
            break
        end
        p += 1
    end

    if e.dx ~= 0 then -- moving horizontally
        local right = e.dx > 0
        local edge_x = right and max(l1.x, l2.x) or min(l1.x, l2.x)
        local overflow = right and (e.x + e.dx) - edge_x
                                or edge_x - (e.x + e.dx)
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
                remove_life(e)
            end
        else
            e.x += e.dx * e.slow
        end
    elseif e.dy ~= 0 then -- moving vertically
        local down = e.dy > 0
        local edge_y = down and max(l1.y, l2.y) or min(l1.y, l2.y)
        local overflow = down and (e.y + e.dy) - edge_y
                               or edge_y - (e.y + e.dy)
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
                remove_life(e)
            end
        else
            e.y += e.dy * e.slow
        end
    end
end

function update_enemies()
    local had_enemies = #enemies > 0
    foreach(enemies, function(enmy)
        -- update flashing
        if enmy.dmg_age then
            if enmy.dmg_age > 8 then
                enmy.dmg_age = nil
            else
                enmy.dmg_age += 1
            end
        end
        -- update death animation
        if enmy.death_age then
            enmy.death_age += 1
            if enmy.death_age%2 == 0 then
                local offsets = {
                    {-1, 0}, {-1, 0}, -- particle 1 x/y
                    {0, 1}, {-1, 0},  -- particle 2 x/y
                    {0, 1}, {0, 1},   -- particle 3 x/y
                    {-1, 0}, {0, 1},  -- particle 4 x/y
                }
                for i=1,7 do
                    for j=0,1 do
                        enmy.death_particles[i][1+j] += rand(unpack(offsets[i+j]))
                    end
                end
            end
        end
        -- update slow
        if enmy.slow_dur == 0 then
            enmy.slow = 1
        else
            enmy.slow_dur -= 1
        end
        -- update position
        if not enmy.death_age then
            move_enemy(enmy)
        end
        -- update hitbox
        if enmy.type == 'ARROW' then
            if enmy.dx ~= 0 then
                enmy.width, enmy.height = 3, 5
            else
                enmy.width, enmy.height = 5, 3
            end
        end
    end)
    foreach(enemies, function(enmy)
        -- delete enemy
        if enmy.hp == 0 and enmy.death_age == MAX_DEATH_AGE then
            del(enemies, enmy)
        end
    end)
    -- apply interest on wave complete (except final wave)
    if had_enemies and #enemies == 0 and wave < NUM_WAVES and not game_over then
        interest_t = 1
        interest_gained = round(gold * interest)
        -- update stats
        total_bonus_int += interest_gained - round(gold * initial_int)
        gold += interest_gained
        -- don't play sfx on boss waves
        if wave % BOSS_FREQ ~= 0 then
            sfx(43)
        end
    end
end

function draw_enemies()
    foreach(enemies, function(enmy)
        -- Draw enemy
        if enmy.death_age then
            for part in all(enmy.death_particles) do
                local c, c2 = Pink, DarkPurple
                if enmy.type == 'RECTANGLE' then
                    c, c2 = Blue, DarkBlue
                elseif enmy.type == 'ARROW' then
                    c, c2 = Orange, Brown
                elseif enmy.type == 'CIRCLE' then
                    c, c2 = LightGray, DarkGray
                elseif enmy.type == 'BOSS' then
                    c, c2 = Yellow, Brown
                end
                if enmy.death_age < MAX_DEATH_AGE*0.5 then
                    circfill(enmy.x, enmy.y, enmy.death_age/2,
                         enmy.death_age%2 == 0 and c2 or c)
                end
                pset(enmy.x+part[1], enmy.y+part[2],
                    enmy.death_age > (MAX_DEATH_AGE*0.5) and c2 or c)
            end
            return
        end
        pal(Green, Black)
        local top  = enmy.y - enmy.height\2
        local left = enmy.x - enmy.width\2
        local flash = enmy.dmg_age and (enmy.dmg_age\3)%2 == 0
        if enmy.type == 'CIRCLE' then
            if flash then pal(LightGray, White) end
            spr(112, left, top)
        elseif enmy.type == 'SQUARE' then
            -- if flash then pal(Pink, Peach) end
            if flash then pal(Pink, White) end
            spr(113, left, top)
        elseif enmy.type == 'DIAMOND' then
            if flash then pal(Red, Pink) end
            spr(114, left, top)
        elseif enmy.type == 'RECTANGLE' then
            if flash then pal(Blue, White) end
            spr(115, left, top)
        elseif enmy.type == 'BOSS' then
            if flash then pal(Yellow, Pink) end
            spr(116, left, top)
        elseif enmy.type == 'ARROW' then
            if flash then pal(Orange, White) end
            if enmy.dx ~= 0 then
                -- left/right
                sspr(40, 56, 5, 5, left, top, 5, 5, enmy.dx<0)
            else
                -- up/down
                sspr(48, 56, 5, 5, left, top, 5, 5, false, enmy.dy<0)
            end
        end
        pal(0)
        -- Draw health bar
        local hp_y = top-2
        local hp_width = enmy.type == 'ARROW' and 5 or enmy.width
        local left = enmy.x - enmy.width\2
        rect(left, hp_y, left+hp_width-1, hp_y, DarkGreen)
        local hp_rem = ceil(enmy.hp / enmy.max_hp*hp_width)
        rect(left, hp_y, left+hp_rem-1, hp_y, Green)
    end)
end

function can_send_wave()
    return sending == 0 and #enemies == 0 and wave < NUM_WAVES and not game_over
end

function send_wave()
    wave += 1
    sending = 10
    show_hint = false
end
