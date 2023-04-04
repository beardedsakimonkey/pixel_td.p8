sel = {
    dst_x=58, dst_y=46,
    x=58,     y=46,
    src_x=58, src_y=46,
    tx=0, ty=0, -- animation start time
}
-- Helps impl of selection movement
grid_bitmap = {}

-- Todo: this doesn't actually do the moving
local function move_selection(dir)
    -- Find destination cell
    local g = p2g(sel.dst_x, sel.dst_y)
    local dst_x = g.x
    local dst_y = g.y
    local cell_dx = dir == B.right and 1 or dir == B.left and -1 or 0
    local cell_dy = dir == B.down and  1 or dir == B.up   and -1 or 0
    while true do
        -- move 0 or 1 cells in both directions
        dst_x += cell_dx
        dst_y += cell_dy
        -- bail if we reached a boundary
        if dst_x <= 0 or dst_y <= 0 or
            dst_x >= 10 or dst_y >= 10 then
            return
        end
        -- break if it's a valid cell
        if grid_bitmap[dst_y+1][dst_x+1] == 0 then
            break
        end
    end

    if cell_dx ~= 0 then
        if sel.x ~= sel.dst_x then
            sel.src_x = sel.x
            sel.tx = time()
        end
        if sel.tx == 0 then
            sel.tx = time()
        end
    end
    if cell_dy ~= 0 then
        if sel.y ~= sel.dst_y then
            sel.src_y = sel.y
            sel.ty = time()
        end
        if sel.ty == 0 then
            sel.ty = time()
        end
    end

    -- Update destination
    local p = g2p({x=dst_x, y=dst_y})
    sel.dst_x = p.left
    sel.dst_y = p.top
end

function init_selection()
    for _=0, 10 do
        add(grid_bitmap, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end
    for i=2, #map do
        local ca, cb = map[i-1], map[i]
        if ca.x == cb.x then
            local step = ca.y < cb.y and 1 or -1
            for j = ca.y, cb.y, step do
                grid_bitmap[j+1][ca.x+1] = 1
            end
        elseif ca.y == cb.y then
            local step = ca.x < cb.x and 1 or -1
            for j = ca.x, cb.x, step do
                grid_bitmap[ca.y+1][j+1] = 1
            end
        end
    end
end

function update_selection()
    if not buy_menu.is_open and not upg_menu.is_open then
        if btnp(B.left)  then move_selection(B.left) end
        if btnp(B.right) then move_selection(B.right) end
        if btnp(B.up)    then move_selection(B.up) end
        if btnp(B.down)  then move_selection(B.down) end
    end
    if sel.tx ~= 0 then -- is animating
        local dt = min(1, (time() - sel.tx)*6)
        if dt == 1 then -- done animating
            sel.x = sel.dst_x
            sel.src_x = sel.dst_x
            sel.tx = 0
        else
            sel.x = lerp(sel.src_x, sel.dst_x, easeout(dt))
        end
    end
    if sel.ty ~= 0 then -- is animating
        local dt = min(1, (time() - sel.ty)*6)
        if dt == 1 then -- done animating
            sel.y = sel.dst_y
            sel.src_y = sel.dst_y
            sel.ty = 0
        else
            sel.y = lerp(sel.src_y, sel.dst_y, easeout(dt))
        end
    end
end

function draw_selection()
    local top   = sel.y + 1
    local left  = sel.x + 1
    local bot   = top + 10
    local right = left + 10
    local color = C.light_gray
    -- top left corner
    line(left, top, left+2, top, color)
    line(left, top, left, top+2, color)
    -- top right corner
    line(right, top, right-2, top, color)
    line(right, top, right, top+2, color)
    -- bottom left corner
    line(left, bot, left+2, bot, color)
    line(left, bot, left, bot-2, color)
    -- bottom right corner
    line(right, bot, right-2, bot, color)
    line(right, bot, right, bot-2, color)
end
