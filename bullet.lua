local function is_in_range(enmy, twr)
    if enmy.hp == 0 then
        return false
    end
    return (enmy.x - twr.x)^2 + (enmy.y - twr.y)^2 < get_twr_range(twr)^2
end

local function register_damage(enmy, twr)
    enmy.hp = max(0, enmy.hp - get_twr_damage(twr))
    -- fixed point workaround
    if enmy.hp <= 0x0000.0007 then
        enmy.hp = 0
    end
    if enmy.dmg_age == nil then -- start flicker
        enmy.dmg_age = 0
    end
    if enmy.hp == 0 then
        enmy.death_age = 0
        sfx(47 + rand(0, 2))
        enmy.death_particles = init_death_particles()
        add_gold(enmy)
    end
end

-- Red -------------------------------------------------------------------------

local function collide(blt, enmy)
    return blt.x >= (enmy.x - enmy.width/2) -- left
       and blt.x <= (enmy.x + enmy.width/2) -- right
       and blt.y >= (enmy.y - enmy.height/2) -- top
       and blt.y <= (enmy.y + enmy.height/2) -- bot
end

function update_bullets_red(twr)
    foreach(twr.bullets, function(blt)
        if blt.enemy.hp == 0 then
            -- enemy died, try to find new target
            local new_target = tbl_find(enemies, function(enmy)
                return enmy.hp > 0 and not enmy.death_age
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
        local angle = atan2(enmy.x-blt.x, enmy.y-blt.y)
        blt.x += cos(angle) * blt.acc
        blt.y += sin(angle) * blt.acc
        blt.acc *= 1.04

        -- handle collision
        if collide(blt, enmy) then
            register_damage(enmy, twr)
            del(twr.bullets, blt)
        else
            -- add particle
            if t%2 == 0 then
                add(blt.particles, {x=oldx, y=oldy, age=1})
            end
        end
    end)
end

function fire_bullet_red(twr)
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
            twr.cd = get_twr_start_cd(twr)
        end
    end
end

function draw_bullets_red(twr)
    for blt in all(twr.bullets) do
        pset(blt.x, blt.y, Red)
        for part in all(blt.particles) do
            pset(part.x, part.y, DarkPurple)
        end
    end
end

-- Green -----------------------------------------------------------------------

function update_bullets_green(twr)
    local blt = twr.bullets[1]
    if not blt then
        return
    end
    local REGISTER_DMG = 11
    if blt.enemy.hp == 0 then
        del(twr.bullets, blt)
        if blt.age < REGISTER_DMG then -- enemy died before bullet registered damage
            twr.cd = 0
            return
        end
    else
        blt.age += 1
    end
    if blt.age > 22 then
        twr.bullets = {}
    else
        if blt.age == REGISTER_DMG then
            register_damage(blt.enemy, twr)
        end
        -- Update chain bullets
        for chain_blt in all(blt.chain_blts) do
            if chain_blt.enemy.hp == 0 then
                del(blt.chain_blts, chain_blt)
            else
                chain_blt.age += 1
            end
            if chain_blt.age == REGISTER_DMG then
                register_damage(chain_blt.enemy, twr)
            end
        end
    end
end

local function find_neighbors(enemy, level)
    local n1_dist, n2_dist  = 0x7fff.ffff, 0x7fff.ffff
    local n1_enmy, n2_enmy
    for enmy in all(enemies) do
        if enmy ~= enemy and enmy.hp > 0 then
            local dist = distance(enemy, enmy)
            local max_dist = ({13, 14, 15, 16})[level]
            if dist < max_dist then
                if dist < n1_dist then
                    n1_dist, n1_enmy = dist, enmy
                elseif dist < n2_dist then
                    n2_dist, n2_enmy = dist, enmy
                end
            end
        end
    end
    return {n1_enmy, n2_enmy}
end

function fire_bullet_green(twr)
    twr.cd = max(0, twr.cd-1)
    if twr.cd > 0 or #twr.bullets > 0 then return end

    local function fire_bullet(enmy)
        -- look for chain target
        local chain_blts = {}
        local neighbors = find_neighbors(enmy, get_twr_level(twr.type))
        for i = 1, twr.max_bullets-1 do
            if neighbors[i] then
                add(chain_blts, {
                    age=0,
                    enemy=neighbors[i],
                })
            end
        end
        add(twr.bullets, {
            age=0,
            enemy=enmy,
            chain_blts=chain_blts,
        })
        twr.cd = get_twr_start_cd(twr)
    end

    -- Prefer second enemy so that we can reach two neighbors
    if twr.max_bullets > 2 and enemies[2] and is_in_range(enemies[2], twr) then
        fire_bullet(enemies[2])
        return
    else
        for enmy in all(enemies) do
            if is_in_range(enmy, twr) then
                fire_bullet(enmy)
                return
            end
        end
    end
end

function draw_bullets_green(twr)
    local blt = twr.bullets[1]
    if not blt then return end
    local function get_bullet_color(age)
        if     age <=  3 then return DarkBlue
        elseif age <=  6 then return DarkGreen
        elseif age <=  8 then return Green
        elseif age <= 11 then return White
        elseif age <= 16 then return Green
        elseif age <= 18 then return DarkGreen
        else                  return DarkBlue end
    end
    -- Draw primary bullet
    line(twr.x, twr.y, blt.enemy.x, blt.enemy.y, get_bullet_color(blt.age))
    pset(twr.x, twr.y, Black) -- don't cover up center pixel
    -- Draw chain bullet
    for chain_blt in all(blt.chain_blts) do
        line(blt.enemy.x, blt.enemy.y, chain_blt.enemy.x, chain_blt.enemy.y,
             get_bullet_color(chain_blt.age))
    end
end

-- Blue ------------------------------------------------------------------------

function update_bullets_blue(twr)
    local REGISTER_DMG = 11
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
    if twr.bullets[1].age >= 22 then
        twr.bullets = {}
    else
        if twr.bullets[1].age == REGISTER_DMG then
            -- register damage & slow
            for blt in all(twr.bullets) do
                local enmy = blt.enemy
                register_damage(enmy, twr)
                add(enmy.slows, {duration=50, amount=0.5})
            end
        end
    end
end

function fire_bullet_blue(twr)
    twr.cd = max(0, twr.cd-1)
    if twr.cd > 0 or #twr.bullets > 0 then return end
    -- Avoid targeting already-slowed enemies at first. If we have bullets
    -- remaining, then we'll target the skipped enemies.
    -- NOTE: we could choose to avoid multiple blue towers targeting the same
    -- enemy on the same frame.
    local skipped = {}
    if #enemies > 0 and enemies[#enemies].type == 'BOSS' then
        local boss = enemies[#enemies]
        if is_in_range(boss, twr) then
            add(twr.bullets, {
                age=0,
                enemy=boss,
            })
            twr.cd = get_twr_start_cd(twr)
            if #twr.bullets == twr.max_bullets then
                return
            end
        end
    end
    for i = #enemies, 1, -1 do
        local enmy = enemies[i]
        if is_in_range(enmy, twr) and enmy.type ~= 'BOSS' then
            if #enmy.slows == 0 then
                add(twr.bullets, {
                    age=0,
                    enemy=enmy,
                })
            else
                add(skipped, i)
            end
            twr.cd = get_twr_start_cd(twr)
            if #twr.bullets == twr.max_bullets then
                return
            end
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

function draw_bullets_blue(twr)
    for blt in all(twr.bullets) do
        local color
        if     blt.age <=  3 then color = DarkBlue
        elseif blt.age <=  6 then color = Peach
        elseif blt.age <=  8 then color = Blue
        elseif blt.age <= 11 then color = White
        elseif blt.age <= 16 then color = Blue
        elseif blt.age <= 18 then color = Peach
        else                      color = DarkBlue end
        line(twr.x, twr.y, blt.enemy.x, blt.enemy.y, color)
        -- don't cover up center pixel
        pset(twr.x, twr.y, Black)
    end
end

--------------------------------------------------------------------------------

function update_bullets()
    for twr in all(towers) do twr:update_bullets() end
    for twr in all(towers) do twr:fire_bullet() end
end

function draw_bullets()
    for twr in all(towers) do twr:draw_bullets() end
end
