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
        if is_in_range(enmy, twr) then
            local p = g2p(twr)
            add(twr.bullets, {
                type=twr.type,
                x=p.left+6, y=p.top+6,
                rotation=0,
                enemy=enmy,
                particles={},
            })
            twr.cd = 40
            break
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
    if enmy.hp == 0 then
        del(twr.bullets, blt)
        return
    end
    if not is_in_range(enmy, twr) then
        del(twr.bullets, blt)
        return
    end
    local oldx, oldy = blt.enemy.x, blt.enemy.y
    -- add particle
    if t%3 == 0 then
        deli(blt.particles, 1)
        add(blt.particles, {x=oldx, y=oldy, age=1})
    end
end

local function draw_bullets_green(twr)
    local blt = twr.bullets[1]
    if blt then
        local t = g2p(twr)
        for part in all(blt.particles) do
            line(t.left+6, t.top+6, part.x, part.y, C.dark_green)
        end
        line(t.left+6, t.top+6, blt.enemy.x, blt.enemy.y, C.green)
        -- don't cover up center pixel
        pset(t.left+6, t.top+6, C.black)
        pset(blt.enemy.x, blt.enemy.y, C.black)
    end
end

local function fire_bullet_green(twr)
    if #twr.bullets > 0 then return end
    for enmy in all(enemies) do
        if is_in_range(enmy, twr) then
            add(twr.bullets, {
                type=twr.type,
                x=0, y=0,
                rotation=0,
                enemy=enmy,
                particles={},
            })
            break
        end
    end
end

--------------------------------------------------------------------------------

function update_bullets()
    foreach(towers, function(twr)
        if twr.type == TWR.red then
            foreach(twr.bullets, function(blt) update_bullet_red(twr, blt) end)
        elseif twr.type == TWR.green then
            foreach(twr.bullets, function(blt) update_bullet_green(twr, blt) end)
        end
    end)

    foreach(towers, function(twr)
        if twr.type == TWR.red then
            fire_bullet_red(twr)
        elseif twr.type == TWR.green then
            fire_bullet_green(twr)
        end
    end)
end

function draw_bullets()
    foreach(towers, function(twr)
        if twr.type == TWR.red then
            draw_bullets_red(twr)
        elseif twr.type == TWR.green then
            draw_bullets_green(twr)
        end
    end)
end
