ST = {buy = 1, upgrade = 2}

-- Public
open_menu = ST.buy

-- Private
menu_sel_opt = 1
menu_sel_twr = 1
menu_pressing_right = false
menu_pressing_left = false

function update_menu()
    menu_pressing_right = btn(B.right)
    menu_pressing_left = btn(B.left)
    if btnp(B.down) and menu_sel_opt == 1 then
        menu_sel_opt = 2
    end
    if btnp(B.up) and menu_sel_opt == 2 then
        menu_sel_opt = 1
    end
    if btnp(B.left) then
        menu_sel_twr = max(1, menu_sel_twr-1)
    end
    if btnp(B.right) then
        menu_sel_twr = min(3, menu_sel_twr+1)
    end
    if btnp(B.x) then
        open_menu = nil
    end
    if btnp(B.z) then
        open_menu = nil
    end
end

function draw_menu()
    local menu_x = 35; local menu_y = 94
    rect(menu_x-2, menu_y-2, menu_x+60, menu_y+29, C.black)
    rect(menu_x-1, menu_y-1, menu_x+59, menu_y+28, C.light_gray)
    rectfill(menu_x, menu_y, menu_x+58, menu_y+27, C.dark_blue)
    local show_left = open_menu == ST.buy
        and menu_sel_twr ~= 1
        or menu_sel_twr + 3 < 6
    local show_right = open_menu == ST.buy
        and menu_sel_twr ~= 3
        -- or
    -- draw left button
    if show_left then
        local off_x = menu_pressing_left and -1 or 0
        rectfill(menu_x+16+off_x, menu_y+4,
                    menu_x+18+off_x, menu_y+7, C.dark_gray)
        print('⬅️', menu_x+14+off_x, menu_y+3, C.light_gray)
    else
        print('⬅️', menu_x+14, menu_y+3, C.dark_gray)
    end
    -- draw right button
    if show_right then
        local off_x = menu_pressing_right and 1 or 0
        rectfill(menu_x+40+off_x, menu_y+4,
                    menu_x+42+off_x, menu_y+7, C.dark_gray)
        print('➡️', menu_x+38+off_x, menu_y+3, C.light_gray)
    else
        print('➡️', menu_x+38, menu_y+3, C.dark_gray)
    end
    -- draw tower
    pal(C.dark_blue, C.black)
        spr(menu_sel_twr, menu_x+26, menu_y+2)
    pal()
    -- draw menu items
    if open_menu == ST.buy then
        print('buy', menu_x+9, menu_y+12, C.white)
        print('20', menu_x+25, menu_y+12, C.indigo)
    elseif open_menu == ST.upgrade then
        print('upgrade', menu_x+9, menu_y+12, C.white)
    end
    print('cancel', menu_x+9, menu_y+20, C.white)
    -- draw menu item arrow
    spr(14, menu_x+3, menu_y+(menu_sel_opt==1 and 12 or 20))
end
