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
                LightGray, -- 1 (dark blue)
                LightGray, -- 2 (dark purple)
                LightGray, -- 3 (dark green)
                LightGray, -- 4 (brown)
                LightGray, -- 5 (dark gray)
                White,      -- 6 (light gray)
                White,      -- 7 (white)
                LightGray, -- 8 (red)
                LightGray, -- 9 (orange)
                LightGray, -- 10 (yellow)
                White,      -- 11 (green)
                White,      -- 12 (blue)
                LightGray, -- 13 (indigo)
                White,      -- 14 (pink)
                White,      -- 15 (peach)
                DarkGray,  -- 0 (black)
            }, 0)
        end
        -- draw tower
        local p = g2p({x=twr.gx, y=twr.gy})
        spr(twr.type, p.left+3, p.top+3)
        pal(0)
    end)
end
