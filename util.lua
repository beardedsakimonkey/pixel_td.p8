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

function distance(e1, e2)
    return sqrt((e1.x-e2.x)^2 + (e1.y-e2.y)^2)
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
    return 64 - (print(str, 0, -20) - 1)\2
end

function print_outlined(str, x, y, color, outline_color)
    for x_off in all(split'-1,0,1') do
        for y_off in all(split'-1,0,1') do
            print(str, x+x_off, y+y_off, outline_color or Black)
        end
    end
    return print(str, x, y, color)
end

function parse_tbl(str)
    local ret = {}
    for item in all(split(str, "\n")) do
        if item ~= '' then
            local t = {}
            for pair in all(split(item)) do
                local k, v = unpack(split(pair, '='))
                t[k] = v
            end
            add(ret, t)
        end
    end
    return ret
end

function parse_arr(str)
    local ret = {}
    for a in all(split(str, '|')) do
        add(ret, split(a))
    end
    return ret
end
