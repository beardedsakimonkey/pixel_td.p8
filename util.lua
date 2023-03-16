B = {left=0, right=1, up=2, down=3, z=4, x=5}

C = {black=0,     dark_blue=1,  dark_purple=2, dark_green=3, brown=4,
     dark_gray=5, light_gray=6, white=7,       red=8,        orange=9,
     yellow=10,   green=11,     blue=12,       indigo=13,    pink=14,
     peach=15}

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
    return 1 - (1-t)*(1-t)
end
