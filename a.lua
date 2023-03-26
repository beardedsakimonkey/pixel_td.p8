local function asserteq(a, b)
    assert(a == b, ('Expected %s to equal %s'):format(a, b))
end

-- Convert grid coordinates (0-indexed) to pixel coordinates
local function g2p(x, y)
    local top  = (y * 12) - 2
    local left = (x * 12) - 2
    return {top=top, left=left, bot=top+12, right=left+12}
end

asserteq(g2p(0, 0).top, -2)
asserteq(g2p(0, 0).bot, 10)

asserteq(g2p(1, 1).top, 10)
asserteq(g2p(1, 1).bot, 22)

asserteq(g2p(2, 2).top, 22)
asserteq(g2p(2, 2).bot, 34)

asserteq(g2p(2, 2).left, 22)
asserteq(g2p(2, 2).right, 34)

asserteq(g2p(10, 10).top, 118)
asserteq(g2p(10, 10).bot, 130)

-- Convert pixel coordinates to grid coordinates (0-indexed)
local function p2g(x, y)
    return {
        x=math.floor((x+2)/12),
        y=math.floor((y+2)/12),
    }
end

asserteq(p2g(23, 23).x, 2)
asserteq(p2g(23, 23).y, 2)
