-- Todo: support variable hitbox
local function collide(blt, enmy)
    return blt.x > enmy.x-1 and blt.x < enmy.x+1
       and blt.y > enmy.y-1 and blt.y < enmy.y+1
end

-- Todo: perf
local function is_in_range(enmy, twr)
    return (enmy.x - twr.x)^2 + (enmy.y - twr.y)^2 < twr.range^2
end

-- Red -------------------------------------------------------------------------

local function update_bullet_red(twr, blt)
    local enmy = blt.enemy
    if enmy.hp == 0 then
        del(twr.bullets, blt)
        return
    end

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
    blt.rotation = atan2(dx, dy)
    blt.x = blt.x + cos(blt.rotation)*1
    blt.y = blt.y + sin(blt.rotation)*1

    -- handle collision
    if collide(blt, enmy) then
        enmy.hp = max(0, enmy.hp-twr.dmg)
        if enmy.hp == 0 then
            gold += enmy.gold
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
                rotation=0,
                enemy=enmy,
                particles={},
            })
            twr.cd = twr.atkspd
        end
    end
end

local function draw_bullets_red(twr)
    for blt in all(twr.bullets) do
        pset(blt.x, blt.y, C.red)
        for part in all(blt.particles) do
            pset(part.x, part.y, C.dark_purple)
        end
    end
end

-- Green -----------------------------------------------------------------------

local function update_bullet_green(twr, blt)
    local enmy = blt.enemy
    if enmy.hp == 0 or not is_in_range(enmy, twr) then
        del(twr.bullets, blt)
    else
        blt.age += 1
        if blt.age%3 == 0 then -- don't trigger damage every frame
            enmy.hp = max(0, enmy.hp-twr.dmg)
            if enmy.hp == 0 then
                gold += enmy.gold
            end
        end
    end
end

local function fire_bullet_green(twr)
    if #twr.bullets > 0 then return end
    for enmy in all(enemies) do
        if is_in_range(enmy, twr) then
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
        local v = cos((blt.age%61)/60)
        local color = v > 0.95 and C.dark_blue
                    or v > 0.6 and C.dark_green
                    or C.green
        line(twr.x, twr.y, blt.enemy.x, blt.enemy.y, color)
        -- don't cover up center pixel
        pset(twr.x, twr.y, C.black)
        pset(blt.enemy.x, blt.enemy.y, C.black)
    end
end

-- Yellow ----------------------------------------------------------------------

local function update_bullets_yellow(twr)
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
    -- if all bullets were misfired, reset cd
    if misfires > 0 and misfires == num_bullets then
        twr.cd = 0
        return
    end
    if #twr.bullets == 0 then return end
    if twr.bullets[1].age >= 60 then
        twr.bullets = {}
    else
        if twr.bullets[1].age == REGISTER_DMG then
            -- register damage & slow
            for blt in all(twr.bullets) do
                local enmy = blt.enemy
                enmy.hp = max(0, enmy.hp-twr.dmg)
                if enmy.hp == 0 then
                    gold += enmy.gold
                end
                enmy.slow = 0.3
                enmy.slow_dur = 100
            end
        end
    end
end

local function fire_bullet_yellow(twr)
    twr.cd = max(0, twr.cd-1)
    if twr.cd > 0 or #twr.bullets > 0 then return end
    for enmy in all(enemies) do
        if #twr.bullets < twr.max_bullets and is_in_range(enmy, twr) then
            add(twr.bullets, {
                age=0,
                enemy=enmy,
            })
            twr.cd = twr.atkspd
        end
    end
end

local function draw_bullets_yellow(twr)
    for blt in all(twr.bullets) do
        local color
        if blt.age >= 20 and blt.age <= 42 then
            if     blt.age <= 23 then color = C.dark_blue
            elseif blt.age <= 26 then color = C.brown
            elseif blt.age <= 28 then color = C.orange
            elseif blt.age <= 30 then color = C.yellow
            elseif blt.age <= 36 then color = C.peach
            elseif blt.age <= 37 then color = C.white
            elseif blt.age <= 39 then color = C.peach
            elseif blt.age <= 40 then color = C.yellow
            elseif blt.age <= 41 then color = C.orange
            else                      color = C.brown end
            line(twr.x, twr.y, blt.enemy.x, blt.enemy.y, color)
            -- don't cover up center pixel
            pset(twr.x, twr.y, C.black)
            pset(blt.enemy.x, blt.enemy.y, C.black)
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
        elseif is_yellow_twr(twr.type) then
            update_bullets_yellow(twr)
        end
    end)
    foreach(towers, function(twr)
        if is_red_twr(twr.type) then
            fire_bullet_red(twr)
        elseif is_green_twr(twr.type) then
            fire_bullet_green(twr)
        elseif is_yellow_twr(twr.type) then
            fire_bullet_yellow(twr)
        end
    end)
end

function draw_bullets()
    foreach(towers, function(twr)
        if is_red_twr(twr.type) then
            draw_bullets_red(twr)
        elseif is_green_twr(twr.type) then
            draw_bullets_green(twr)
        elseif is_yellow_twr(twr.type) then
            draw_bullets_yellow(twr)
        end
    end)
end
