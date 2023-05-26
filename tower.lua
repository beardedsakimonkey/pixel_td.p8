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
        if prev then
            cfg.sell = prev.upg + prev.sell
        else
            cfg.sell = cfg.buy
        end
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
        local p = g2p({x=twr.gx, y=twr.gy})
        spr(twr.type, p.left+3, p.top+3)
        pal(0)
    end)
end

local function draw_range(x, y, range)
    for x_off in all({-1, 0, 1}) do
        for y_off in all({-1, 0, 1}) do
            circ(x+x_off, y+y_off, range, C.black)
        end
    end
    circ(x, y, range, C.dark_blue)
end

function draw_tower_ranges()
    if upg_menu.is_open then
        local twr = find_sel_tower()
        if twr then
            draw_range(twr.x, twr.y, get_twr_range(twr))
        end
    elseif buy_menu.is_open then
        local range = get_twr_range({range = tower_cfg[buy_menu.sel_twr].range})
        draw_range(sel.x+6, sel.y+6, range)
    end
end
