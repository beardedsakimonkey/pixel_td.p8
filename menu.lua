buy_menu = nil
upg_menu = nil
bonus_menu = nil

local Menu = {}

local OFFSCREEN = 131

function Menu.new(cfg)
    local m = {
        x=cfg.x, dst_y=cfg.dst_y,
        w=cfg.w, h=cfg.h,
        is_open=false,
        items={},
        cur_idx=1,
        y=OFFSCREEN,
        v=0,
    }
    setmetatable(m, {__index = Menu})
    return m
end

function Menu.draw(m)
    if m.y == OFFSCREEN then return end
    do
        local x1, y1, x2, y2 = m.x, m.y, m.x+m.w-1, m.y+m.h-1
        rect(x1-2, y1-2, x2+2, y2+2, C.black)
        rect(x1-1, y1-1, x2+1, y2+1, C.light_gray)
        rectfill(x1, y1, x2, y2, C.dark_blue)
    end

    for i, item in ipairs(m.items) do
        local c = item.disabled and C.dark_gray
                or (i == m.cur_idx) and C.white
                or C.light_gray
        print(item.text, m.x+9, m.y+item.y, c)
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
    if btnp(B.up)   then m.cur_idx = wrap(1, m.cur_idx-1, #m.items) end
    if btnp(B.down) then m.cur_idx = wrap(1, m.cur_idx+1, #m.items) end
    if btnp(B.z) then
        local item = m.items[m.cur_idx]
        if not item.disabled then
            item.cb(m)
            m:close()
        end
    end
    if btnp(B.x) then
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
    buy_menu = Menu.new({x=35, dst_y=98, w=59, h=27})
    add(buy_menu.items, {text='buy',    y=11+8*0, cb=do_buy})
    add(buy_menu.items, {text='cancel', y=11+8*1, cb=buy_menu.close})

    buy_menu.sel_twr = 1
    buy_menu.carousel_x = 0
    buy_menu.carousel_sx = 0
    buy_menu.carousel_st = 0

    buy_menu.handle_btn = function(m)
        Menu.handle_btn(m)
        -- Don't nudge if btn pressed down while disabled
        if m.pressing_right or (not m.pressing_right and m.sel_twr ~= MAX_TWR) then
            m.pressing_right = btn(B.right)
        end
        if m.pressing_left or (not m.pressing_left and m.sel_twr ~= 1) then
            m.pressing_left = btn(B.left)
        end
        if btnp(B.left) and m.sel_twr > 1 then
            m.sel_twr -= 1
            m.carousel_sx = m.carousel_x
            m.carousel_st = time()
        end
        if btnp(B.right) and m.sel_twr < MAX_TWR then
            m.sel_twr += 1
            m.carousel_sx = m.carousel_x
            m.carousel_st = time()
        end
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
        if m.y == OFFSCREEN then return end
        Menu.draw(m)
        local can_left  = m.sel_twr ~= 1 or m.pressing_left
        local can_right = m.sel_twr ~= MAX_TWR or m.pressing_right
        if can_left then
            local off_x = m.pressing_left and -1 or 0
            rectfill(m.x+16+off_x, m.y+3, m.x+18+off_x, m.y+7, C.dark_gray)
            print('⬅️', m.x+14+off_x, m.y+3, C.light_gray)
        else
            print('⬅️', m.x+14, m.y+3, C.dark_gray)
        end
        if can_right then
            local off_x = m.pressing_right and 1 or 0
            rectfill(m.x+40+off_x, m.y+4, m.x+42+off_x, m.y+7, C.dark_gray)
            print('➡️', m.x+38+off_x, m.y+3, C.light_gray)
        else
            print('➡️', m.x+38, m.y+3, C.dark_gray)
        end
        clip(m.x+21, m.y+2, 17, 7)
        for i=1,MAX_TWR do
            if m.sel_twr <= MAX_TWR then pal(C.dark_blue, C.black) end
            spr(i, m.x+26+((i-1)*CAROUSEL_GAP)+m.carousel_x, m.y+2)
            pal(0)
        end
        clip()
        print(tower_cfg[m.sel_twr].buy, m.x+26, m.y+11+8*0, C.indigo)
    end

    buy_menu.open = function(m)
        Menu.open(m)
        m.sel_twr = 1
        -- Todo: update this dynamically
        m.items[1].disabled = gold < tower_cfg[m.sel_twr].buy
    end

    -- Upgrade menu ------------------------------------------------------------
    upg_menu = Menu.new({x=35, dst_y=89, w=59, h=36})
    add(upg_menu.items, {text='upgrade', y=12+8*0, cb=do_upgrade})
    add(upg_menu.items, {text='sell',    y=12+8*1, cb=do_sell})
    add(upg_menu.items, {text='cancel',  y=12+8*2, cb=upg_menu.close})

    upg_menu.draw = function(m)
        if m.y == OFFSCREEN then return end
        Menu.draw(m)
        if m.twr.upg then
            print(m.twr.upg, m.x+44, m.y+12+8*0, C.indigo)
        end
        print(m.twr.sell, m.x+44, m.y+12+8*1, C.indigo)
        if m.twr.type <= MAX_TWR then pal(C.dark_blue, C.black) end
        spr(m.twr.type, m.x+26, m.y+2)
        pal(0)
    end

    upg_menu.open = function(m)
        Menu.open(m)
        m.twr = find_sel_tower()
        m.items[1].disabled = not m.twr.upg or gold < m.twr.upg
    end

    -- Bonus menu --------------------------------------------------------------
    bonus_menu = Menu.new({x=31, dst_y=89, w=70, h=36})
    add(bonus_menu.items, {text='+3% interest', y=12+8*0, cb=do_bonus_int})
    add(bonus_menu.items, {text='+5% damage',   y=12+8*1, cb=do_bonus_dmg})
    add(bonus_menu.items, {text='+10% range',   y=12+8*2, cb=do_bonus_rng})

    bonus_menu.update = function(m)
        local has_boss = wave > 0 and waves[wave].boss_hp ~= nil
        if has_boss and not m.is_open and can_send_wave()
            -- need this condition to avoid immediately opening bonus menu after
            -- choosing a bonus.
            and #bonuses < wave\5 then
            Menu.open(m)
        end
        Menu.update(m)
    end

    bonus_menu.draw = function(m)
        if m.y == OFFSCREEN then return end
        Menu.draw(m)
        print('bonus', m.x+25, m.y+3, C.light_gray)
        if m.cur_idx == 1 then pal(C.indigo, C.yellow) end
        spr(32, 91, m.y+11+8*0)
        pal(0)
        if m.cur_idx == 2 then pal(C.indigo, C.red) end
        spr(33, 91, m.y+11+8*1)
        pal(0)
        if m.cur_idx == 3 then pal(C.indigo, C.green) end
        spr(34, 91, m.y+11+8*2)
        pal(0)
    end

    bonus_menu.handle_btn = function(m)
        if btnp(B.x) then return end
        Menu.handle_btn(m)
    end
end

function do_buy(menu)
    local twr = make_tower(menu.sel_twr, sel.dst_gx, sel.dst_gy)
    gold -= twr.buy
end

function do_sell(menu)
    local twr = find_sel_tower()
    gold += twr.sell
    del(towers, twr)
end

function do_upgrade(menu)
    local twr = find_sel_tower()
    make_tower(twr.type+MAX_TWR, sel.dst_gx, sel.dst_gy)
    gold -= twr.upg
    del(towers, twr)
end

function do_bonus_int(menu) add(bonuses, BNS.int); interest += 3 end
function do_bonus_dmg(menu) add(bonuses, BNS.dmg); bonus_dmg += 0.05 end
function do_bonus_rng(menu) add(bonuses, BNS.rng); bonus_rng += 0.1 end
