MAX_DEATH_AGE = 20

function init_death_particles()
    return parse_arr'-1,-1|1,-1|1,1|-1,1|-1,-1|1,-1|1,1|-1,1'
end

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

function spawn_enemy()
    if sending > 0 then
        local type = ({'CIRCLE', 'SQUARE', 'DIAMOND', 'RECTANGLE', 'ARROW'})[wave%5+1]
        local hp = flr(3+3*(wave^(cur_map==3 and 1.34 or 1.3)))
        hp *= 1 + (wave\BOSS_FREQ)*.02 -- adjust hp to account for bonus
        if type == 'ARROW'  then hp = flr(0.9*hp) end
        if type == 'CIRCLE' then hp = flr(0.9*hp) end
        local gap = 10
        local speed = cur_map==3 and (type == 'ARROW' and 1/3 or 0.27)
                                  or (type == 'ARROW' and 0.4 or 1/3)
        -- Send out enemies every X frames
        -- speed (px/frame) * X = gap (px)
        --  => X = gap / speed
        if t % (gap\speed) == 0 then
            sending -= 1
            local cnr = get_map()[1].cnr
            local dx, dy = cnr=='left' and speed or cnr=='right' and -speed or 0,
                           cnr=='top' and speed or cnr=='bot' and -speed or 0
            if wave % BOSS_FREQ == 0 and sending == 0 then
                type = 'BOSS'
                hp = 12*wave
            end
            local size = type == 'CIRCLE' and 3 or type == 'SQUARE' and 4 or 5
            add(enemies, {
                type=type,
                x=path_points[1].x,
                y=path_points[1].y,
                dx=dx, dy=dy,
                hp=hp, max_hp=hp,
                slows={},
                gold=flr(3+1*sqrt(wave)),
                death_age=nil,
                death_particles=nil,
                width=size, height=size, -- for collision detection
                dmg_age=nil, -- for flicker
            })
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

local function get_slow(enmy)
    if #enmy.slows == 0 then
        return 1
    end
    -- the more slows applied, the less cumulative effect it has
    return ({0.5, 0.44, 0.40, 0.37, 0.35})[#enmy.slows] or 0.35
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
            else -- enemy reached the end
                on_reached_end(e)
            end
        else
            e.x += e.dx * get_slow(e)
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
            else -- enemy reached the end
                on_reached_end(e)
            end
        else
            e.y += e.dy * get_slow(e)
        end
    end
end

function update_enemies()
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
                local offsets = parse_arr'-1,0|-1,0|0,1|-1,0|0,1|0,1|-1,0|0,1'
                for i=1,7 do
                    for j=0,1 do
                        enmy.death_particles[i][1+j] += rand(unpack(offsets[i+j]))
                    end
                end
            end
        end
        -- update slows
        for slow in all(enmy.slows) do
            slow.duration -= 1
            if slow.duration <= 0 then
                del(enmy.slows, slow)
            end
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
        if enmy.hp <= 0 and enmy.death_age >= MAX_DEATH_AGE then
            del(enemies, enmy)
        end
    end)
end

function draw_enemies()
    foreach(enemies, function(enmy)
        -- Draw enemy
        if enmy.death_age then
            for part in all(enmy.death_particles) do
                local c1, c2 = unpack(({
                    RECTANGLE={Blue, DarkBlue},
                    ARROW={Orange, Brown},
                    CIRCLE={LightGray, DarkGray},
                    BOSS={Yellow, Brown},
                    SQUARE={Pink, DarkPurple},
                    DIAMOND={Pink, DarkPurple},
                })[enmy.type])
                if enmy.death_age < MAX_DEATH_AGE*0.5 then
                    circfill(enmy.x, enmy.y, enmy.death_age/2,
                         enmy.death_age%2 == 0 and c2 or c1)
                end
                pset(enmy.x+part[1], enmy.y+part[2],
                    enmy.death_age > (MAX_DEATH_AGE*0.5) and c2 or c1)
            end
            return
        end
        pal(Green, Black)
        local top  = enmy.y - enmy.height\2
        local left = enmy.x - enmy.width\2
        local flash = enmy.dmg_age and (enmy.dmg_age\3)%2 == 0
        if enmy.type == 'ARROW' then
            if flash then pal(Orange, White) end
            if enmy.dx ~= 0 then
                -- left/right
                sspr(80, 56, 5, 5, left, top, 5, 5, enmy.dx<0)
            else
                -- up/down
                sspr(88, 56, 5, 5, left, top, 5, 5, false, enmy.dy<0)
            end
        else
            local s = ({CIRCLE=112, SQUARE=114, DIAMOND=116, RECTANGLE=118, BOSS=120})[enmy.type]
            spr(s+(flash and 1 or 0), left, top)
        end
        pal(0)
        -- Draw health bar
        local hp_y = top-2
        local hp_width = enmy.type == 'ARROW' and 5 or enmy.width
        local left = enmy.x - enmy.width\2
        local hp_rem = ceil(enmy.hp/enmy.max_hp * hp_width)
        rect(left, hp_y, left+hp_width-1, hp_y, DarkGreen)
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
