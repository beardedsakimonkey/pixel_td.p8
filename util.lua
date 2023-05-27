-- buttons: ⬆️⬇️➡️⬅️❎🅾️

C = {black=0,     dark_blue=1,  dark_purple=2, dark_green=3, brown=4,
     dark_gray=5, light_gray=6, white=7,       red=8,        orange=9,
     yellow=10,   green=11,     blue=12,       indigo=13,    pink=14,
     peach=15}

-- corners
CNR = {tl=1, tr=2, bl=3, br=4, top=5, left=6, right=7, bot=8}

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
function spring(cur_pos, dst_pos, cur_vel, cfg)
    local s = cfg.stiffness or 180 -- more stiffness = more bounce
    local d = cfg.damping or 12
    local m = cfg.mass or 1        -- more mass = more inertia
    local p = cfg.precision or 0.01

    local Fspring = -s * (cur_pos - dst_pos)
    local Fdamper = -d * cur_vel
    local acc = (Fspring + Fdamper) / m
    local new_vel = cur_vel + acc/60
    local new_pos = cur_pos + new_vel/60

    if abs(cur_vel) < p and abs(new_pos - cur_pos) < p then
        return dst_pos, 0
    end
    return new_pos, new_vel
end

function hcenter(str)
    local mid = 64
    local width = print(str, 0, -20) - 1
    local left = mid - width\2
    return left
end

function print_outlined(str, x, y, color, outline_color)
    local w = print(str, 0, -20)
    rectfill(x-1, y-1, x-1+w, y+5, outline_color or C.black)
    print(str, x, y, color)
    return x, w
end
