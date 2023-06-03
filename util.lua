-- buttons: ⬆️⬇️➡️⬅️❎🅾️

Black      = 0
DarkBlue   = 1
DarkPurple = 2
DarkGreen  = 3
Brown      = 4
DarkGray   = 5
LightGray  = 6
White      = 7
Red        = 8
Orange     = 9
Yellow     = 10
Green      = 11
Blue       = 12
Indigo     = 13
Pink       = 14
Peach      = 15

function tbl_find(tbl, fn)
    for v in all(tbl) do
        if fn(v) then
            return v
        end
    end
end

function lerp(a, b, t)
    return a + (b-a)*t
end

function easeout(t)
    return 1 - (1-t)^2
end

function wrap(min, v, max)
    if v > max then return min end
    if v < min then return max end
    return v
end

function round(v)
    return flr(v+0.5)
end

-- Random integer in a range (inclusive)
function rand(low, hi)
    return flr(rnd(hi+1-low)) + low
end

-- Convert grid coordinates to pixel coordinates
function g2p(cell)
    local top  = (cell.y * 12) - 2
    local left = (cell.x * 12) - 2
    return {top=top, left=left, bot=top+12, right=left+12}
end

-- Based on https://github.com/chenglou/react-motion/blob/master/src/stepper.js
-- Note: more stiffness = snappier & bouncier, more mass = more inertia
function spring(cur_pos, dst_pos, cur_vel, cfg)
    local Fspring = -(cfg.stiffness or 180) * (cur_pos - dst_pos)
    local Fdamper = -(cfg.damping or 12) * cur_vel
    local acc = (Fspring + Fdamper) / (cfg.mass or 1)
    local new_vel = cur_vel + acc/60
    local new_pos = cur_pos + new_vel/60

    local p = cfg.precision or 0.01
    if abs(cur_vel) < p and abs(new_pos - cur_pos) < p then
        return dst_pos, 0
    end
    return new_pos, new_vel
end

function hcenter(str)
    local width = print(str, 0, -20) - 1
    return 64 - width\2
end

function print_outlined(str, x, y, color, outline_color)
    local w = print(str, 0, -20)
    for x_off in all(split'-1,0,1') do
        for y_off in all(split'-1,0,1') do
            print(str, x+x_off, y+y_off, outline_color or Black)
        end
    end
    print(str, x, y, color)
    return x, w
end
