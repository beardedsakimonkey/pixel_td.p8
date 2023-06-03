local function is_in_range(enmy, twr)
    if enmy.hp == 0 then
        return false
    end
    return (enmy.x - twr.x)^2 + (enmy.y - twr.y)^2 < get_twr_range(twr)^2
end

-- Red -------------------------------------------------------------------------

local function collide(blt, enmy)
    local left  = enmy.x - enmy.width/2
    local right = enmy.x + enmy.width/2
    local top   = enmy.y - enmy.height/2
    local bot   = enmy.y + enmy.height/2
    return blt.x >= left and blt.x <= right
       and blt.y >= top  and blt.y <= bot
end

local function update_bullet_red(twr, blt)
    if blt.enemy.hp == 0 then
        -- enemy died, try to find new target
        local new_target = tbl_find(enemies, function(enmy)
            return enmy.hp > 0
        end)
        if new_target then
            blt.enemy = new_target
        else
            del(twr.bullets, blt)
        end
        return
    end
    local enmy = blt.enemy

    -- update particles
    for p in all(blt.particles) do
        p.age += 1
        if p.age > 3 then
            del(blt.particles, p)
        end
    end

    local oldx, oldy = blt.x, blt.y

    -- update bullet position
    local dx = enmy.x - blt.x
    local dy = enmy.y - blt.y
    local angle = atan2(dx, dy)
    blt.x += cos(angle) * blt.acc
    blt.y += sin(angle) * blt.acc
    blt.acc *= 1.04

    -- handle collision
    if collide(blt, enmy) then
        enmy.hp = max(0, enmy.hp - get_twr_damage(twr))
        sfx(10)
        if enmy.dmg_age == nil then enmy.dmg_age = 0 end
        if enmy.hp == 0 then
            gold += enmy.gold
            kill_enemy(enmy)
        end
        del(twr.bullets, blt)
    else
        -- add particle
        if t%2 == 0 then
            add(blt.particles, {x=oldx, y=oldy, age=1})
        end
    end
end

local function fire_bullet_red(twr)
    twr.cd = max(0, twr.cd-1)
    if twr.cd > 0 then return end
    for enmy in all(enemies) do
        if #twr.bullets < twr.max_bullets and is_in_range(enmy, twr) then
            add(twr.bullets, {
                x=twr.x, y=twr.y,
                acc=0.4,
                enemy=enmy,
                particles={},
            })
            twr.cd = twr.start_cd
        end
    end
end

local function draw_bullets_red(twr)
    for blt in all(twr.bullets) do
        pset(blt.x, blt.y, Red)
        for part in all(blt.particles) do
            pset(part.x, part.y, DarkPurple)
        end
    end
end

-- Green -----------------------------------------------------------------------

local function update_bullet_green(twr, blt)
    local enmy = blt.enemy
    if not is_in_range(enmy, twr) then
        del(twr.bullets, blt)
        if #twr.bullets == 0 then sfx(12, -2) end
    else
        blt.age += 1
        if blt.age % twr.start_cd == 0 then -- don't trigger damage every frame
            enmy.hp = max(0, enmy.hp - get_twr_damage(twr))
            if enmy.dmg_age == nil then enmy.dmg_age = 0 end
            if enmy.hp == 0 then
                gold += enmy.gold
                kill_enemy(enmy)
            end
        end
    end
end

local function fire_bullet_green(twr)
    if #twr.bullets > 0 then return end
    for enmy in all(enemies) do
        if is_in_range(enmy, twr) then
            sfx(12, 1)
            add(twr.bullets, {
                age=0,
                enemy=enmy,
            })
            return
        end
    end
end

local function draw_bullets_green(twr)
    for blt in all(twr.bullets) do
        local a = cos((blt.age%61)/60)
        line(
            twr.x, twr.y,
            blt.enemy.x, blt.enemy.y,
            a > 0.95 and DarkBlue or a > 0.6 and DarkGreen or Green
        )
        -- don't cover up center pixel
        pset(twr.x, twr.y, Black)
    end
end

-- Blue ------------------------------------------------------------------------

local function update_bullets_blue(twr)
    local REGISTER_DMG = 30
    local num_bullets = #twr.bullets
    local misfires = 0 -- enemy died before bullet registered damage
    for blt in all(twr.bullets) do
        if blt.enemy.hp == 0 then
            if blt.age < REGISTER_DMG then
                misfires += 1
            end
            del(twr.bullets, blt)
        else
            blt.age += 1
        end
    end
    -- if all bullets misfired, reset cd
    if misfires > 0 and misfires == num_bullets then
        twr.cd = 0
        return
    end
    if #twr.bullets == 0 then return end
    if twr.bullets[1].age >= 60 then
        twr.bullets = {}
    else
        if twr.bullets[1].age == REGISTER_DMG then
            sfx(11)
            -- register damage & slow
            for blt in all(twr.bullets) do
                local enmy = blt.enemy
                enmy.hp = max(0, enmy.hp - get_twr_damage(twr))
                if enmy.dmg_age == nil then enmy.dmg_age = 0 end
                if enmy.hp == 0 then
                    gold += enmy.gold
                    kill_enemy(enmy)
                end
                enmy.slow = 0.3
                enmy.slow_dur = 100
            end
        end
    end
end

local function fire_bullet_blue(twr)
    twr.cd = max(0, twr.cd-1)
    if twr.cd > 0 or #twr.bullets > 0 then return end
    -- Avoid targeting already-slowed enemies at first. If we have bullets
    -- remaining, then we'll target the skipped enemies.
    -- NOTE: we could choose to avoid multiple blue towers targeting the same
    -- enemy on the same frame.
    local skipped = {}
    for i, enmy in ipairs(enemies) do
        if is_in_range(enmy, twr) then
            if enmy.slow_dur ~= 0 then
                add(skipped, i)
            else
                add(twr.bullets, {
                    age=0,
                    enemy=enmy,
                })
            end
            twr.cd = twr.start_cd
        end
        if #twr.bullets == twr.max_bullets then
            return
        end
    end
    for i in all(skipped) do
        if #twr.bullets < twr.max_bullets then
            add(twr.bullets, {
                age=0,
                enemy=enemies[i],
            })
        end
    end
end

local function draw_bullets_blue(twr)
    for blt in all(twr.bullets) do
        local color
        if blt.age >= 20 and blt.age <= 42 then
            if     blt.age <= 23 then color = DarkBlue
            elseif blt.age <= 26 then color = Peach
            elseif blt.age <= 28 then color = Blue
            elseif blt.age <= 31 then color = White
            elseif blt.age <= 36 then color = Blue
            elseif blt.age <= 38 then color = Peach
            else                      color = DarkBlue end
            line(twr.x, twr.y, blt.enemy.x, blt.enemy.y, color)
            -- don't cover up center pixel
            pset(twr.x, twr.y, Black)
        end
    end
end

--------------------------------------------------------------------------------

function update_bullets()
    foreach(towers, function(twr)
        if is_red_twr(twr.type) then
            foreach(twr.bullets, function(blt)
                update_bullet_red(twr, blt)
            end)
        elseif is_green_twr(twr.type) then
            foreach(twr.bullets, function(blt)
                update_bullet_green(twr, blt)
            end)
        elseif is_blue_twr(twr.type) then
            update_bullets_blue(twr)
        end
    end)
    foreach(towers, function(twr)
        if is_red_twr(twr.type) then
            fire_bullet_red(twr)
        elseif is_green_twr(twr.type) then
            fire_bullet_green(twr)
        elseif is_blue_twr(twr.type) then
            fire_bullet_blue(twr)
        end
    end)
end

function draw_bullets()
    foreach(towers, function(twr)
        if is_red_twr(twr.type) then
            draw_bullets_red(twr)
        elseif is_green_twr(twr.type) then
            draw_bullets_green(twr)
        elseif is_blue_twr(twr.type) then
            draw_bullets_blue(twr)
        end
    end)
end
