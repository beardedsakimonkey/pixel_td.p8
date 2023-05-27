MAX_TWR = 3 -- how many types of towers are there

function is_green_twr(type) return type % MAX_TWR == 1 end
function is_red_twr(type)   return type % MAX_TWR == 2 end
function is_blue_twr(type)  return type % MAX_TWR == 0 end

function get_twr_range(twr)  return round(twr.range * bonus_rng) end
function get_twr_damage(twr) return twr.dmg * bonus_dmg end

function find_sel_tower()
    return tbl_find(towers, function(twr)
        return twr.gx == sel.dst_gx and twr.gy == sel.dst_gy
    end)
end

function init_tower()
    towers = {}
    -- Compute sell prices
    for i, cfg in pairs(tower_cfg) do
        local prev = tower_cfg[i-MAX_TWR]
        local sell
        if prev then
            sell = prev.upg + prev.sell
        else
            sell = cfg.buy
        end
        cfg.sell = flr(sell*0.9)
    end
end

function make_tower(type, gx, gy)
    local cfg = tower_cfg[type]
    local p = g2p({x=gx, y=gy})
    return add(towers, {
        type=type,
        gx=gx, gy=gy, -- in grid coordinates
        x=p.left+6, y=p.top+6, -- in pixel coordinates
        bullets={},
        max_bullets=cfg.max_bullets or 1,
        cd=0, -- in frames
        atkspd=cfg.atkspd or 0,
        dmg=cfg.dmg,
        range=cfg.range,
        age=0, -- for flicker
        buy=cfg.buy, sell=cfg.sell, upg=cfg.upg,
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
        -- draw flicker
        if twr.age and (twr.age\2)%2 == 0 then
            pal({
                C.light_gray, -- 1 (dark blue)
                C.light_gray, -- 2 (dark purple)
                C.light_gray, -- 3 (dark green)
                C.light_gray, -- 4 (brown)
                C.light_gray, -- 5 (dark gray)
                C.white,      -- 6 (light gray)
                C.white,      -- 7 (white)
                C.light_gray, -- 8 (red)
                C.light_gray, -- 9 (orange)
                C.light_gray, -- 10 (yellow)
                C.white,      -- 11 (green)
                C.white,      -- 12 (blue)
                C.light_gray, -- 13 (indigo)
                C.white,      -- 14 (pink)
                C.white,      -- 15 (peach)
                C.dark_gray,  -- 0 (black)
            }, 0)
        end
        -- draw tower
        local p = g2p({x=twr.gx, y=twr.gy})
        spr(twr.type, p.left+3, p.top+3)
        pal(0)
    end)
end
