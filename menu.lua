-- buy_menu = nil
-- upg_menu = nil
-- bonus_menu = nil

local Menu = {}

local OFFSCREEN = 131

function Menu.new(cfg)
    return setmetatable({
        x=cfg.x, dst_y=cfg.dst_y,
        w=cfg.w, h=cfg.h,
        is_open=false,
        items={},
        cur_idx=1,
        y=OFFSCREEN,
        v=0,
    }, {__index = Menu})
end

function Menu.draw(m)
    if m.y == OFFSCREEN then return end
    local x1, y1, x2, y2 = m.x, m.y, m.x+m.w-1, m.y+m.h-1
    rect(x1-2, y1-2, x2+2, y2+2, Black)
    rect(x1-1, y1-1, x2+1, y2+1, LightGray)
    rectfill(x1, y1, x2, y2, Black)

    for i, item in ipairs(m.items) do
        print(
            item.text, m.x+9, m.y+item.y,
            (item.is_disabled and item.is_disabled(m)) and DarkGray
                or i ~= m.cur_idx and LightGray
                or (item.text=='buy' or item.text=='upgrade') and Green
                or item.text=='sell' and Red
                or White
        )
    end

    spr(19, m.x+MAX_TWR, m.y+m.items[m.cur_idx].y)
end

function Menu.update(m)
    local dest_y = m.is_open and m.dst_y or OFFSCREEN
    m.y, m.v = spring(m.y, dest_y, m.v, {
        stiffness = 180,
        damping = 12,
        mass = 0.25,
    })
end

function Menu.handle_btn(m)
    local function move_selection(offset)
        sfx(42)
        m.cur_idx = wrap(1, m.cur_idx+offset, #m.items)
    end
    if btnp(⬆️) then move_selection(-1) end
    if btnp(⬇️) then move_selection(1) end
    if btnp(🅾️) then
        local item = m.items[m.cur_idx]
        if not (item.is_disabled and item.is_disabled(m)) then
            item.cb(m)
            m:close()
        else
            sfx(41)
        end
    end
    if btnp(❎) then
        sfx(51)
        m:close()
    end
end

function Menu.close(m)
    m.is_open = false
end

function Menu.open(m)
    m.is_open = true
    m.cur_idx = 1
end

function init_menus()
    -- Buy menu ----------------------------------------------------------------
    buy_menu = Menu.new{x=35, dst_y=98, w=59, h=27}
    add(buy_menu.items, {text='buy',    y=11, cb=do_buy,
        is_disabled=function(m) return gold < tower_cfg[m.sel_twr].buy end})
    add(buy_menu.items, {text='cancel', y=11+8, cb=do_close})

    buy_menu.sel_twr, buy_menu.carousel_x, buy_menu.carousel_sx, buy_menu.carousel_st = 1, 0, 0, 0

    buy_menu.handle_btn = function(m)
        Menu.handle_btn(m)
        -- Don't nudge if btn pressed down while disabled
        if m.pressing_right or (not m.pressing_right and m.sel_twr ~= MAX_TWR) then
            m.pressing_right = btn(➡️)
        end
        if m.pressing_left or (not m.pressing_left and m.sel_twr ~= 1) then
            m.pressing_left = btn(⬅️)
        end
        local function nav_carousel(offset)
            if offset==-1 and m.sel_twr>1 or offset==1 and m.sel_twr<MAX_TWR then
                sfx(40)
                m.sel_twr += offset
                m.carousel_sx = m.carousel_x
                m.carousel_st = time()
            else
                sfx(41)
            end
        end
        if btnp(⬅️) then nav_carousel(-1) end
        if btnp(➡️) then nav_carousel(1) end
    end

    local CAROUSEL_GAP = 20

    buy_menu.update = function(m)
        Menu.update(m)
        m.carousel_x = lerp(
            m.carousel_sx,
            (m.sel_twr-1)*-CAROUSEL_GAP,
            easeout(min(1, (time()-m.carousel_st)*MAX_TWR))
        )
    end

    buy_menu.draw = function(m)
        local x, y = m.x, m.y
        if y == OFFSCREEN then return end
        Menu.draw(m)
        if m.sel_twr ~= 1 or m.pressing_left then -- can go left
            local off_x = m.pressing_left and -1 or 0
            rectfill(x+16+off_x, y+3, x+18+off_x, y+7, DarkGray)
            print('⬅️', x+14+off_x, y+3, LightGray)
        else
            print('⬅️', x+14, y+3, DarkGray)
        end
        if m.sel_twr ~= MAX_TWR or m.pressing_right then -- can go right
            local off_x = m.pressing_right and 1 or 0
            rectfill(x+40+off_x, y+4, x+42+off_x, y+7, DarkGray)
            print('➡️', x+38+off_x, y+3, LightGray)
        else
            print('➡️', x+38, y+3, DarkGray)
        end
        clip(x+21, y+2, 17, 7)
        for i=1,MAX_TWR do
            spr(i, x+26 + (i-1)*CAROUSEL_GAP + m.carousel_x, y+2)
        end
        clip()
        print(tower_cfg[m.sel_twr].buy, x+26, y+11, Indigo)
    end

    buy_menu.open = function(m)
        Menu.open(m)
        m.sel_twr = 1
    end

    -- Upgrade menu ------------------------------------------------------------
    upg_menu = Menu.new{x=35, dst_y=89, w=59, h=36}
    add(upg_menu.items, {text='upgrade', y=12, cb=do_upgrade,
        is_disabled=function(m) return not m.twr.upg or gold < m.twr.upg end})
    add(upg_menu.items, {text='sell',    y=20, cb=do_sell})
    add(upg_menu.items, {text='cancel',  y=28, cb=do_close})

    upg_menu.update = function(m)
        Menu.update(m)
    end

    upg_menu.draw = function(m)
        if m.y == OFFSCREEN then return end
        Menu.draw(m)
        if m.twr.upg then
            print(m.twr.upg, m.x+44, m.y+12, Indigo)
        end
        print(m.twr.sell, m.x+44, m.y+20, Indigo)
        local x = m.x+26
        local y = m.y+2
        spr(m.twr.type, x, y)
    end

    upg_menu.open = function(m)
        Menu.open(m)
        m.twr = find_sel_tower()
    end

    -- Bonus menu --------------------------------------------------------------
    bonus_menu = Menu.new{x=20, dst_y=81, w=88, h=44}
    add(bonus_menu.items, {text='+2% damage',       y=12, cb=do_bonus_damage})
    add(bonus_menu.items, {text='+3% attack speed', y=20, cb=do_bonus_atkspd})
    add(bonus_menu.items, {text='+16% range',       y=28, cb=do_bonus_range})
    add(bonus_menu.items, {text='+1 gold per kill', y=36, cb=do_bonus_gold})

    bonus_menu.update = function(m)
        if wave > 0 and wave % BOSS_FREQ == 0 and not m.is_open and can_send_wave()
            -- need this condition to avoid immediately opening bonus menu after
            -- choosing a bonus.
            and #bonuses < wave \ BOSS_FREQ then
            sfx(52)
            upg_menu:close()
            buy_menu:close()
            Menu.open(m)
        end
        Menu.update(m)
    end

    bonus_menu.draw = function(m)
        if m.y == OFFSCREEN then return end
        Menu.draw(m)
        sspr(0, 88, 19, 6, 55, m.y+3) -- menu title
        if m.cur_idx ~= 1 then pal(Red, Indigo) end
        if m.cur_idx ~= 2 then pal(Orange, Indigo) end
        if m.cur_idx ~= 3 then pal(Green, Indigo) end
        if m.cur_idx ~= 4 then pal(Yellow, Indigo) end
        for i = 0,3 do
            spr(32+i, m.x+m.w-10, m.y+11+8*i)
        end
        pal(0)
    end

    bonus_menu.handle_btn = function(m)
        if btnp(❎) then
            sfx(41)
            return
        end
        Menu.handle_btn(m)
    end
end

function do_close(menu)
    sfx(51)
    menu:close()
end

function do_buy(menu)
    sfx(46)
    local twr = make_tower(menu.sel_twr, sel.dst_gx, sel.dst_gy)
    gold -= twr.buy
    has_bought_tower = true
end

function do_sell()
    sfx(43)
    local twr = find_sel_tower()
    gold += twr.sell
    del(towers, twr)
end

function do_upgrade()
    local twr = find_sel_tower()
    sfx(56 + (twr.type-1)\3)
    local new_twr = make_tower(twr.type+MAX_TWR, sel.dst_gx, sel.dst_gy)
    -- carry over existing bullets/cd
    new_twr.bullets = twr.bullets
    new_twr.cd = twr.cd
    gold -= twr.upg
    del(towers, twr)
end

function do_bonus_damage()
    sfx(43)
    add_bonus(36)
    bonus_dmg += .02
end

function do_bonus_atkspd()
    sfx(43)
    add_bonus(37)
    bonus_atkspd += .03
end

function do_bonus_range()
    sfx(43)
    add_bonus(38)
    bonus_rng += .16
end

function do_bonus_gold()
    sfx(43)
    add_bonus(39)
    bonus_gld += 1
end
