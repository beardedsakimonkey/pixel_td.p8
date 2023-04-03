buy_menu = nil
upg_menu = nil

--------------------------------------------------------------------------------
local Menu = {}

local OFFSCREEN = 130

function Menu.new(cfg)
    local m = {
        x=cfg.x, dst_y=cfg.dst_y,
        w=cfg.w, h=cfg.h,
        is_open=false,
        items={},
        cur_idx=1,
        y=OFFSCREEN,
        -- track start time & y of animation to make it interruptible
        st=0, sy=OFFSCREEN,
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
        local color = (i == m.cur_idx) and C.white or C.light_gray
        print(item.text, m.x+9, m.y+item.y, color)
    end

    -- print('>', m.x+3, m.y+m.items[m.cur_idx].y, C.light_gray)
    spr(19, m.x+3, m.y+m.items[m.cur_idx].y)
end

function Menu.update(m)
    if m.is_open and m.y ~= m.dst_y then
        m.y = lerp(m.sy, m.dst_y, easeout(min(1, (time()-m.st)*6)))
    elseif not m.is_open and m.y ~= OFFSCREEN then
        m.y = lerp(m.sy, OFFSCREEN, easeout(min(1, (time()-m.st)*6)))
    end
end

function Menu.handle_btn(m)
    if btnp(B.up)   then m.cur_idx = wrap(1, m.cur_idx-1, #m.items) end
    if btnp(B.down) then m.cur_idx = wrap(1, m.cur_idx+1, #m.items) end
    if btnp(B.z) then
        m.items[m.cur_idx].cb(m)
        m:close()
    end
    if btnp(B.x) then
        m:close()
    end
end

function Menu.close(m)
    m.is_open = false
    m.st = time()
    m.sy = m.y
end

function Menu.open(m)
    m.cur_idx = 1
    m.is_open = true
    m.st = time()
    m.sy = m.y
end
--------------------------------------------------------------------------------

function init_menus()
    buy_menu = Menu.new({x=35, dst_y=97, w=59, h=27})
    add(buy_menu.items, {text='buy',    y=11+8*0, cb=do_buy})
    add(buy_menu.items, {text='cancel', y=11+8*1, cb=buy_menu.close})

    buy_menu.sel_twr = 1

    buy_menu.handle_btn = function(m)
        Menu.handle_btn(m)
        -- Don't nudge if btn pressed down while disabled
        if m.pressing_right or (not m.pressing_right and m.sel_twr ~= 3) then
            m.pressing_right = btn(B.right)
        end
        if m.pressing_left or (not m.pressing_left and m.sel_twr ~= 1) then
            m.pressing_left = btn(B.left)
        end
        if btnp(B.left)  then m.sel_twr = mid(1, m.sel_twr-1, 3) end
        if btnp(B.right) then m.sel_twr = mid(1, m.sel_twr+1, 3) end
    end

    buy_menu.draw = function(m)
        if m.y == OFFSCREEN then return end
        Menu.draw(m)
        local can_left  = m.sel_twr ~= 1 or m.pressing_left
        local can_right = m.sel_twr ~= 3 or m.pressing_right
        if can_left then
            local off_x = m.pressing_left and -1 or 0
            rectfill(m.x+16+off_x, m.y+4, m.x+18+off_x, m.y+7, C.dark_gray)
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
        if m.sel_twr <= 3 then pal(1, 0) end
        spr(m.sel_twr, m.x+26, m.y+2)
        pal()
        print('20', m.x+26, m.y+11+8*0, C.indigo)
    end

    buy_menu.open = function(m)
        Menu.open(m)
        m.sel_twr = 1
    end

    upg_menu = Menu.new({x=35, dst_y=89, w=59, h=36})
    add(upg_menu.items, {text='upgrade', y=12+8*0, cb=do_upgrade})
    add(upg_menu.items, {text='sell',    y=12+8*1, cb=do_sell})
    add(upg_menu.items, {text='cancel',  y=12+8*2, cb=upg_menu.close})

    upg_menu.draw = function(m)
        if m.y == OFFSCREEN then return end
        Menu.draw(m)
        print('20', m.x+44, m.y+12+8*0, C.indigo)
        print('20', m.x+44, m.y+12+8*1, C.indigo)
        if m.twr <= 3 then pal(1, 0) end
        spr(m.twr, m.x+26, m.y+2)
        pal()
    end

    upg_menu.open = function(m)
        Menu.open(m)
        local twr = tbl_find(towers, twr_is_selected)
        m.twr = twr.type
    end
end
