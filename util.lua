B = {left=0, right=1, up=2, down=3, z=4, x=5}

C = {black=0,     dark_blue=1,  dark_purple=2, dark_green=3, brown=4,
     dark_gray=5, light_gray=6, white=7,       red=8,        orange=9,
     yellow=10,   green=11,     blue=12,       indigo=13,    pink=14,
     peach=15}

TWR = {green=1, red=2, blue=3}
corner = {TL=1, TR=2, BL=3, BR=4, TOP=5, LEFT=6, RIGHT=7, BOT=8}

function tbl_filter(t, fn)
    local res = {}
    foreach(t, function(v)
        if fn(v) then
            add(res, v)
        end
    end)
    return res
end

function tbl_find(t, fn)
    for v in all(t) do
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

-- Convert grid coordinates to pixel coordinates
function g2p(cell)
    local top  = (cell.y * 12) - 2
    local left = (cell.x * 12) - 2
    return {top=top, left=left, bot=top+12, right=left+12}
end

-- Convert pixel coordinates to grid coordinates
function p2g(x, y)
    return {
        x=flr((x+2)/12),
        y=flr((y+2)/12),
    }
end
