MAX_TWR = 3 -- how many types of towers are there

function get_twr_range(twr) return round(twr.range * bonus_rng) end
function get_twr_damage(twr) return twr.dmg * bonus_dmg end
function get_twr_start_cd(twr)
    local diff = twr.start_cd * bonus_atkspd - twr.start_cd
    return twr.start_cd - diff
end
function get_twr_level(type)
    return ceil(type/3)
end

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
        local sell = prev and prev.upg+prev.sell or cfg.buy
        cfg.sell = flr(0.9*sell)
    end
end

function make_tower(type, gx, gy)
    local cfg = tower_cfg[type]
    local p = g2p{x=gx, y=gy}
    local type_idx = type%MAX_TWR + 1
    return add(towers, {
        type=type,
        gx=gx, gy=gy, -- in grid coordinates
        x=p.left+6, y=p.top+6, -- in pixel coordinates
        bullets={},
        max_bullets=get_twr_level(type),
        cd=0, -- in frames
        start_cd=({
            90, -- blue
            38, -- red
            50, -- green
        })[type_idx],
        dmg=cfg.dmg,
        range=cfg.range,
        age=0, -- for flicker
        buy=cfg.buy, sell=cfg.sell, upg=cfg.upg,
        update_bullets=({update_bullets_blue,
                         update_bullets_red,
                         update_bullets_green})[type_idx],
        fire_bullet=({fire_bullet_blue,
                      fire_bullet_red,
                      fire_bullet_green})[type_idx],
        draw_bullets=({draw_bullets_blue,
                       draw_bullets_red,
                       draw_bullets_green})[type_idx],
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
            pal{
                LightGray, -- 1 (dark blue)
                LightGray, -- 2 (dark purple)
                LightGray, -- 3 (dark green)
                LightGray, -- 4 (brown)
                LightGray, -- 5 (dark gray)
                White,     -- 6 (light gray)
                White,     -- 7 (white)
                LightGray, -- 8 (red)
                LightGray, -- 9 (orange)
                LightGray, -- 10 (yellow)
                White,     -- 11 (green)
                White,     -- 12 (blue)
                LightGray, -- 13 (indigo)
                White,     -- 14 (pink)
                White,     -- 15 (peach)
                DarkGray,  -- 0 (black)
            }
        end
        -- draw tower
        local p = g2p{x=twr.gx, y=twr.gy}
        spr(twr.type, p.left+3, p.top+3)
        pal(0)
    end)
end

-- Range animation -------------------------------------------------------------

local range, range_v, is_visible, dest_range, is_growing = nil, 0, false, nil, true

function update_tower_ranges()
    local was_visible = is_visible
    is_visible = buy_menu.is_open or upg_menu.is_open
    if is_visible then
        local prev_dest_range = dest_range
        dest_range = get_twr_range(find_sel_tower()
                                or {range = tower_cfg[buy_menu.sel_twr].range})
        if dest_range ~= prev_dest_range then
            is_growing = prev_dest_range == nil or dest_range > prev_dest_range
        end
        if was_visible then -- update
            range, range_v = spring(range, dest_range, range_v, {
                stiffness = 120,
                precision = 0.1,
            })
        else -- initialize
            range = dest_range-4
            range_v = 0
        end
    end
end

local function draw_range(x, y, range)
    for x_off in all(split'-1,0,1') do
        for y_off in all(split'-1,0,1') do
            circ(x+x_off, y+y_off, range, Black)
        end
    end
    circ(x, y, range, shadow_color())
end

function draw_tower_ranges()
    if upg_menu.is_open then
        local twr = find_sel_tower()
        draw_range(twr.x, twr.y, range)
    elseif buy_menu.is_open then
        draw_range(sel.x+6, sel.y+6, is_growing and flr(range) or ceil(range))
    end
end
