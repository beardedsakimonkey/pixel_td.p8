-- Public
buy_menu = nil
upgrade_menu = nil

--------------------------------------------------------------------------------
local Menu = {}

function Menu.new(x, y, w, h)
    local m = {
        x=x, y=y,
        w=w, h=h,
        open=false,
        items={},
        sel_item=1,
    }
    setmetatable(m, {__index = Menu})
    return m
end

function Menu:draw()
    if not self.open then return end
    -- Draw menu
    do
        local x1, y1, x2, y2 = self.x, self.y, self.x+self.w, self.y+self.h
        rect(x1-2, y1-2, x2+2, y2+2, C.black)
        rect(x1-1, y1-1, x2+1, y2+1, C.light_gray)
        rectfill(x1, y1, x2, y2, C.black)
    end

    -- Draw menu items
    for i, item in ipairs(self.items) do
        local color = (i == self.sel_item) and C.white or C.light_gray
        print(item.text, self.x+9, self.y+item.y, color)
    end

    -- Draw menu item arrow
    print('>', self.x+3, self.y+self.items[self.sel_item].y, C.white)

    if self.draw_extra then
        self:draw_extra()
    end
end

function Menu:update()
    if not self.open then return end
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

    if self.update_extra then
        self:update_extra()
    end
end

function Menu:close()
    self.open = false
    self.sel_item = 1
end
--------------------------------------------------------------------------------

function init_menus(do_buy)
    buy_menu = Menu.new(35, 97, 58, 27)
    add(buy_menu.items, {text='buy', y=11, cb=do_buy})
    add(buy_menu.items, {text='cancel', y=11+8, cb=buy_menu.close})

    buy_menu.open = true
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

        -- Draw left button
        if can_left then
            local off_x = self.pressing_left and -1 or 0
            rectfill(self.x+16+off_x, self.y+4,
                     self.x+18+off_x, self.y+7, C.dark_gray)
            print('⬅️', self.x+14+off_x, self.y+3, C.light_gray)
        else
            print('⬅️', self.x+14, self.y+3, C.dark_gray)
        end

        -- Draw right button
        if can_right then
            local off_x = self.pressing_right and 1 or 0
            rectfill(self.x+40+off_x, self.y+4,
                        self.x+42+off_x, self.y+7, C.dark_gray)
            print('➡️', self.x+38+off_x, self.y+3, C.light_gray)
        else
            print('➡️', self.x+38, self.y+3, C.dark_gray)
        end

        -- Draw tower
        spr(self.sel_twr, self.x+26, self.y+2)
    end

    upgrade_menu = Menu.new(1, 2, 1, 2)
end
