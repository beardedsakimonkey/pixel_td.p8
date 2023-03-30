buy_menu = nil
upg_menu = nil

--------------------------------------------------------------------------------
local Menu = {}

function Menu.new(cfg)
    local m = {
        x=cfg.x, y=cfg.y,
        w=cfg.w, h=cfg.h,
        is_open=false,
        items={},
        sel_item=1,
        items_y=cfg.items_y,
    }
    setmetatable(m, {__index = Menu})
    return m
end

function Menu:draw()
    if not self.is_open then return end
    do
        local x1, y1, x2, y2 = self.x, self.y, self.x+self.w-1, self.y+self.h-1
        rect(x1-2, y1-2, x2+2, y2+2, C.black)
        rect(x1-1, y1-1, x2+1, y2+1, C.light_gray)
        rectfill(x1, y1, x2, y2, C.black)
    end

    for i, item in ipairs(self.items) do
        local color = (i == self.sel_item) and C.white or C.light_gray
        print(item.text, self.x+9, self.y+self.items_y+8*(i-1), color)
    end

    print('>', self.x+3, self.y+self.items_y+8*(self.sel_item-1), C.white)

    if self.draw_extra then self:draw_extra() end
end

function Menu:update()
    if not self.is_open then return end
    if btnp(B.up) then
        self.sel_item = wrap(1, self.sel_item-1, #self.items)
    end
    if btnp(B.down) then
        self.sel_item = wrap(1, self.sel_item+1, #self.items)
    end
    if btnp(B.x) then
        self:close()
    end
    if btnp(B.z) then
        self.items[self.sel_item].cb(self)
        self:close()
    end

    if self.update_extra then self:update_extra() end
end

function Menu:close()
    self.is_open = false
end

function Menu:open()
    self.sel_item = 1
    self.is_open = true
    if self.open_extra then self:open_extra() end
end
--------------------------------------------------------------------------------

function init_menus()
    buy_menu = Menu.new({x=35, y=97, w=59, h=27, items_y=11})
    add(buy_menu.items, {text='buy',    cb=do_buy})
    add(buy_menu.items, {text='cancel', cb=buy_menu.close})

    buy_menu.sel_twr = 1

    function buy_menu:update_extra()
        self.pressing_right = btn(B.right)
        self.pressing_left  = btn(B.left)
        if btnp(B.left)  then self.sel_twr = mid(1, self.sel_twr-1, 3) end
        if btnp(B.right) then self.sel_twr = mid(1, self.sel_twr+1, 3) end
    end

    function buy_menu:draw_extra()
        local can_left = self.sel_twr > 1
        local can_right = self.sel_twr < 3
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
    end

    upg_menu = Menu.new({x=35, y=89, w=59, h=36, items_y=12})
    add(upg_menu.items, {text='upgrade', cb=do_upgrade})
    add(upg_menu.items, {text='sell',    cb=do_sell})
    add(upg_menu.items, {text='cancel',  cb=upg_menu.close})

    function upg_menu:draw_extra()
        spr(self.twr, self.x+26, self.y+2)
    end

    function upg_menu:open_extra()
        local twr = tbl_find(towers, twr_is_selected)
        self.twr = twr.type
    end
end
