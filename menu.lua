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

function Menu:draw()
    if self.y == OFFSCREEN then
        return
    end
    do
        local x1, y1, x2, y2 = self.x, self.y, self.x+self.w-1, self.y+self.h-1
        rect(x1-2, y1-2, x2+2, y2+2, C.black)
        rect(x1-1, y1-1, x2+1, y2+1, C.light_gray)
        rectfill(x1, y1, x2, y2, C.dark_blue)
    end

    for i, item in ipairs(self.items) do
        local color = (i == self.cur_idx) and C.white or C.light_gray
        print(item.text, self.x+9, self.y+item.y, color)
    end

    print('>', self.x+3, self.y+self.items[self.cur_idx].y, C.white)
end

function Menu:update()
    if self.is_open and self.y ~= self.dst_y then
        self.y = lerp(self.sy, self.dst_y, easeout(min(1, (time()-self.st)*6)))
    elseif not self.is_open and self.y ~= OFFSCREEN then
        self.y = lerp(self.sy, OFFSCREEN, easeout(min(1, (time()-self.st)*6)))
    end
end

function Menu:handle_btn()
    if btnp(B.up) then
        self.cur_idx = wrap(1, self.cur_idx-1, #self.items)
    end
    if btnp(B.down) then
        self.cur_idx = wrap(1, self.cur_idx+1, #self.items)
    end
    if btnp(B.z) then
        self.items[self.cur_idx].cb(self)
        self:close()
    end
    if btnp(B.x) then
        self:close()
    end
end

function Menu:close()
    self.is_open = false
    self.st = time()
    self.sy = self.y
end

function Menu:open()
    self.cur_idx = 1
    self.is_open = true
    self.st = time()
    self.sy = self.y
end
--------------------------------------------------------------------------------

function init_menus()
    buy_menu = Menu.new({x=35, dst_y=97, w=59, h=27})
    add(buy_menu.items, {text='buy',    y=11+8*0, cb=do_buy})
    add(buy_menu.items, {text='cancel', y=11+8*1, cb=buy_menu.close})

    buy_menu.sel_twr = 1

    buy_menu.handle_btn = function(self)
        Menu.handle_btn(self)
        -- Don't nudge if btn pressed down while disabled
        if self.pressing_right or (not self.pressing_right and self.sel_twr ~= 3) then
            self.pressing_right = btn(B.right)
        end
        if self.pressing_left or (not self.pressing_left and self.sel_twr ~= 1) then
            self.pressing_left = btn(B.left)
        end
        if btnp(B.left)  then self.sel_twr = mid(1, self.sel_twr-1, 3) end
        if btnp(B.right) then self.sel_twr = mid(1, self.sel_twr+1, 3) end
    end

    buy_menu.draw = function(self)
        if self.y == OFFSCREEN then
            return
        end
        Menu.draw(self)
        local can_left  = self.sel_twr ~= 1 or self.pressing_left
        local can_right = self.sel_twr ~= 3 or self.pressing_right
        if can_left then
            local off_x = self.pressing_left and -1 or 0
            rectfill(self.x+16+off_x, self.y+4,
                     self.x+18+off_x, self.y+7, C.dark_gray)
            print('⬅️', self.x+14+off_x, self.y+3, C.light_gray)
        else
            print('⬅️', self.x+14, self.y+3, C.dark_gray)
        end
        if can_right then
            local off_x = self.pressing_right and 1 or 0
            rectfill(self.x+40+off_x, self.y+4,
                        self.x+42+off_x, self.y+7, C.dark_gray)
            print('➡️', self.x+38+off_x, self.y+3, C.light_gray)
        else
            print('➡️', self.x+38, self.y+3, C.dark_gray)
        end
        spr(self.sel_twr, self.x+26, self.y+2)
        print('20', self.x+26, self.y+11+8*0, C.indigo)
    end

    buy_menu.open = function(self)
        Menu.open(self)
        self.sel_twr = 1
    end

    upg_menu = Menu.new({x=35, dst_y=89, w=59, h=36})
    add(upg_menu.items, {text='upgrade', y=12+8*0, cb=do_upgrade})
    add(upg_menu.items, {text='sell',    y=12+8*1, cb=do_sell})
    add(upg_menu.items, {text='cancel',  y=12+8*2, cb=upg_menu.close})

    upg_menu.draw = function(self)
        if self.y == OFFSCREEN then
            return
        end
        Menu.draw(self)
        print('20', self.x+44, self.y+12+8*0, C.indigo)
        print('20', self.x+44, self.y+12+8*1, C.indigo)
        spr(self.twr, self.x+26, self.y+2)
    end

    upg_menu.open = function(self)
        Menu.open(self)
        local twr = tbl_find(towers, twr_is_selected)
        self.twr = twr.type
    end
end
