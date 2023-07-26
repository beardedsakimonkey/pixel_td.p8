MAX_TWR = 3 -- how many types of towers are there

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
        cfg.sell = prev and prev.upg+prev.sell or cfg.buy
    end
end

function make_tower(type, gx, gy)
    local cfg = tower_cfg[type]
    local p = g2p{x=gx, y=gy}
    local update_bullets = ({update_bullets_blue,
                             update_bullets_green,
                             update_bullets_red})[type%MAX_TWR + 1]
    local fire_bullet = ({fire_bullet_blue,
                          fire_bullet_green,
                          fire_bullet_red})[type%MAX_TWR + 1]
    local draw_bullets = ({draw_bullets_blue,
                           draw_bullets_green,
                           draw_bullets_red})[type%MAX_TWR + 1]
    return add(towers, {
        type=type,
        gx=gx, gy=gy, -- in grid coordinates
        x=p.left+6, y=p.top+6, -- in pixel coordinates
        bullets={},
        max_bullets=cfg.max_bullets or 1,
        cd=0, -- in frames
        start_cd=cfg.cd or 0,
        dmg=cfg.dmg,
        range=cfg.range,
        age=0, -- for flicker
        buy=cfg.buy, sell=cfg.sell, upg=cfg.upg,
        update_bullets=update_bullets,
        fire_bullet=fire_bullet,
        draw_bullets=draw_bullets,
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

local range, range_v, is_visible = nil, 0, false

function update_tower_ranges()
    local was_visible = is_visible
    is_visible = buy_menu.is_open or upg_menu.is_open
    if is_visible then
        local dest_range = get_twr_range(find_sel_tower()
                                or {range = tower_cfg[buy_menu.sel_twr].range})
        if was_visible then -- update
            range, range_v = spring(range, dest_range, range_v, {
                stiffness = 120,
                precision = 0.1,
            })
        else -- initialize
            range = dest_range*0.9
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
    circ(x, y, range, DarkBlue)
end

function draw_tower_ranges()
    if upg_menu.is_open then
        local twr = find_sel_tower()
        draw_range(twr.x, twr.y, range)
    elseif buy_menu.is_open then
        draw_range(sel.x+6, sel.y+6, range)
    end
end
