local _init_pos = {x=5, y=4}
local _p = g2p(_init_pos)
sel = {
    dst_x=_p.left,      dst_y=_p.top,
    dst_gx=_init_pos.x, dst_gy=_init_pos.y,
    x=_p.left,          y=_p.top,
    vx=0, vy=0,
}
-- Helps impl of selection movement
local grid_bitmap = {}

function init_selection_aux()
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

-- Todo: this doesn't actually do the moving
local function move_selection(dir)
    -- Find destination cell
    local dst_x, dst_y = sel.dst_gx, sel.dst_gy
    local cell_dx = dir == B.right and 1 or dir == B.left and -1 or 0
    local cell_dy = dir == B.down and  1 or dir == B.up   and -1 or 0
    while true do
        -- move 0 or 1 cells in both directions
        dst_x += cell_dx
        dst_y += cell_dy
        -- bail if we reached a boundary
        local VEL = 670 -- rubber banding velocity
        if dst_x <= 0 then sel.vx = -VEL; return end
        if dst_x >= 10 then sel.vx = VEL; return end
        if dst_y >= 10 then sel.vy = VEL; return end
        if dst_y <= 0 then sel.vy = -VEL; return end

        -- break if it's a valid cell
        if grid_bitmap[dst_y+1][dst_x+1] == 0 then
            break
        end
    end

    -- Update destination
    local p = g2p({x=dst_x, y=dst_y})
    sel.dst_x = p.left
    sel.dst_y = p.top
    sel.dst_gx = dst_x
    sel.dst_gy = dst_y
end

function update_selection()
    if not buy_menu.is_open and not upg_menu.is_open then
        if btnp(B.left)  then move_selection(B.left) end
        if btnp(B.right) then move_selection(B.right) end
        if btnp(B.up)    then move_selection(B.up) end
        if btnp(B.down)  then move_selection(B.down) end
    end

    local cfg = {
        stiffness = 200,
        damping = 12,
        mass = 0.2,
        precision = 0.9,
    }
    sel.x, sel.vx = spring(sel.x, sel.dst_x, sel.vx, cfg)
    sel.y, sel.vy = spring(sel.y, sel.dst_y, sel.vy, cfg)
end

function draw_selection()
    local top   = sel.y + 1
    local left  = sel.x + 1
    -- snap to upper pixel when moving right/down
    if sel.vy > 0 then top = ceil(top) end
    if sel.vx > 0 then left = ceil(left) end
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
