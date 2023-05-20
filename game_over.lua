function update_game_over()
    if btnp(B.z) then
        reinit()
    end
end

function draw_game_over()
    print('game over', 50, 50, C.light_gray)
end
