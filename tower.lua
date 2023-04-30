towers = {}

function init_towers()
    -- make_tower(TWR.red, 2, 4)
    -- make_tower(TWR.green, 3, 4)
    -- make_tower(TWR.green, 4, 4)
    make_tower(TWR.yellow, 4, 2)
    foreach(towers, function(twr) twr.age = nil end) -- don't animate
end

function make_tower(type, x, y)
    add(towers, {
        type=type,
        x=x, y=y, -- in grid coordinates
        range=30,
        bullets={},
        cd=0, -- in frames
        dmg=type == TWR.green and 0.2 or 2,
        age=0,
    })
end

function update_towers()
    -- update age
    for tower in all(towers) do
        if tower.age then
            if tower.age < 24 then
                tower.age += 1
            else
                tower.age = nil
            end
        end
    end
end

function draw_towers()
    foreach(towers, function(twr)
        local p = g2p(twr)
        -- draw flicker
        if twr.age and (twr.age\2)%2 == 0 then
            pal({
                [0]=C.dark_gray,
                [1]=C.light_gray,
                [2]=C.light_gray,
                [3]=C.light_gray,
                [4]=C.light_gray,
                [5]=C.light_gray,
                [6]=C.white,
                [7]=C.white,
                [8]=C.light_gray,
                [9]=C.light_gray,
                [10]=C.light_gray,
                [11]=C.white,
                [12]=C.white,
                [13]=C.light_gray,
                [14]=C.white,
                [15]=C.white
            }, 0)
        end
        -- draw tower
        spr(twr.type, p.left+3, p.top+3)
        pal(0)
    end)

    -- draw tower range
    if upg_menu.is_open then
        foreach(towers, function(twr)
            local p = g2p(twr)
            if twr_is_selected(twr) then
                circ(p.left+4, p.top+4, twr.range, C.light_gray)
            end
        end)
    end

end
