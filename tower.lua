towers = {}

MAX_TWR = 3 -- how many types of towers are there

local tower_cfg = {
    [1]  = {dmg=2,   range=30, atkspd=40},  -- lvl 1 green
    [2]  = {dmg=0.2, range=30, atkspd=0},   -- lvl 1 red
    [3]  = {dmg=2,   range=30, atkspd=120}, -- lvl 1 yellow
    [4]  = {dmg=2,   range=30, atkspd=40},  -- lvl 2 green
    [5]  = {dmg=0.2, range=30, atkspd=0},   -- lvl 2 red
    [6]  = {dmg=2,   range=30, atkspd=120}, -- lvl 2 yellow
    [7]  = {dmg=2,   range=30, atkspd=40},  -- lvl 3 green
    [8]  = {dmg=0.2, range=30, atkspd=0},   -- lvl 3 red
    [9]  = {dmg=2,   range=30, atkspd=120}, -- lvl 3 yellow
    [10] = {dmg=2,   range=30, atkspd=40},  -- lvl 4 green
    [11] = {dmg=0.2, range=30, atkspd=0},   -- lvl 4 red
    [12] = {dmg=2,   range=30, atkspd=120}, -- lvl 4 yellow
}

function is_red_twr(type)    return type%3 == 1 end
function is_green_twr(type)  return type%3 == 2 end
function is_yellow_twr(type) return type%3 == 0 end

function init_towers()
    local GREEN, RED, YELLOW = 1, 2, 3
    make_tower(RED, 2, 4)
    -- make_tower(GREEN, 3, 4)
    -- make_tower(GREEN, 4, 4)
    make_tower(YELLOW, 4, 2)
    foreach(towers, function(twr) twr.age = nil end) -- don't animate
end

function make_tower(type, x, y)
    local cfg = tower_cfg[type]
    add(towers, {
        type=type,
        x=x, y=y, -- in grid coordinates
        bullets={},
        cd=0, -- in frames
        atkspd=cfg.atkspd,
        dmg=cfg.dmg,
        range=cfg.range,
        age=0, -- for flicker
    })
end

function update_towers()
    -- update age
    for tower in all(towers) do
        if tower.age then
            if tower.age < 24 then
                tower.age += 1
            else
                tower.age = nil
            end
        end
    end
end

function draw_towers()
    foreach(towers, function(twr)
        local p = g2p(twr)
        -- draw flicker
        if twr.age and (twr.age\2)%2 == 0 then
            pal({
                [0]=C.dark_gray,
                [1]=C.light_gray,
                [2]=C.light_gray,
                [3]=C.light_gray,
                [4]=C.light_gray,
                [5]=C.light_gray,
                [6]=C.white,
                [7]=C.white,
                [8]=C.light_gray,
                [9]=C.light_gray,
                [10]=C.light_gray,
                [11]=C.white,
                [12]=C.white,
                [13]=C.light_gray,
                [14]=C.white,
                [15]=C.white
            }, 0)
        end
        -- draw tower
        spr(twr.type, p.left+3, p.top+3)
        pal(0)
    end)

    -- draw tower range
    if upg_menu.is_open then
        foreach(towers, function(twr)
            local p = g2p(twr)
            if twr_is_selected(twr) then
                circ(p.left+4, p.top+4, twr.range, C.light_gray)
            end
        end)
    end
end
