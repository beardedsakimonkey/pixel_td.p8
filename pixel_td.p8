pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
do
#include util.lua
end

do
#include menu.lua
end

do
#include selection.lua
end

do
#include tower.lua
end

do
#include enemy.lua
end

do
#include bullet.lua
end

do
#include hint.lua
end

do
#include title.lua
end

do
#include core.lua
end
__gfx__
00000000000000000000000000000000000000000000000000000000555555505555555055555550bbbbbbb0eeeeeee0ccccccc0000000000000000000000000
000000000555550005555500055555000bbbbb000eeeee000ccccc005bbbbb105eeeee105ccccc10b5555530e5555580c55555f0000000000000000000000000
0000000005bbb10005eee10005ccc1000b5553000e5558000c555f005b5553105e5558105c555f10b5bbb130e5eee280c5ccc1f0000000000000000000000000
0000000005b0310005e0810005c0f1000b5013000e5028000c501f005b5013105e5028105c501f10b5b03130e5e08280c5c0f1f0000000000000000000000000
00000000053331000588810005fff1000b1113000e2228000c111f005b1113105e2228105c111f10b5333130e5888280c5fff1f0000000000000000000000000
0000000001111100011111000111110003333300088888000fffff0053333310588888105fffff10b1111130e2222280c11111f0000000000000000000000000
000000000000000000000000000000000000000000000000000000001111111011111110111111103333333088888880fffffff0000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaa0000088088007000000000bbb0000000000000000000000000000000000000000000111111111111111011010000000000000000000000000000
00000000a999a00082282280770000000bbdb0000bbbbbbb00000000000000000000000000000000101010101010101010100100000000000000000000000000
00000000a999a0008222228077700000bbddb0000bdddddb00000000000000000000000000000000010001000100010011010000000000000000000000000000
00000000a999a0000822280077000000bdddb0000b1ddd1b00000000000000000000000000000000101010101010101010000000000000000000000000000000
000000000aaa00000082800070000000b1ddb0000bb1d1bb00000000000000000000000000000000000000000000000011010000000000000000000000000000
00000000000000000008000000000000bb1db00000bb1bb000000000000000000000000000000000010001000100010010100100000000000000000000000000
000000000000000000000000000000000bb1b000000bbb0000000000000000000000000000000000000000000000000011010000000000000000000000000000
0000000000000000000000000000000000bbb0000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000
ddddddd0ddddddd0ddddddd011111000111110001111100000000000000000000000000000000000000000000000000011010000000000000000000000000000
d00000d0d00000d0d00000d011dd10001d1d100011d1100000000000000000000000000000000000000000000000000010100100000000000000000000000000
d00dd0d0d0d0d0d0d00d00d01d1d100011d110001d1d100000000000000000000000000000000000000000000000000011010000000000000000000000000000
d0d0d0d0d00d00d0d0d0d0d01dd110001d1d100011d1100000000000000000000000000000000000000000000000000010000000000000000000000000000000
d0dd00d0d0d0d0d0d00d00d011111000111110001111100000000000000000000000000000000000000000000000000011010000000000000000000000000000
d00000d0d00000d0d00000d000000000000000000000000000000000000000000000000000000000000000000000000010100100000000000000000000000000
ddddddd0ddddddd0ddddddd000000000000000000000000000000000000000000000000000000000000000000000000011010000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb000000000000000000000
bb66666bbbb76666bbbb77666bbbb77766bbbb67776bbbb66777bbbb66677bbbb66667bbbb66666bbbb66666bbbb66666bbbb66666bb00000000000000000000
b6666666bb7666666bb7766666bb7766666bb6777666bb6677776bb6667777bb6666777bb6666677bb6666667bb6666666bb6666666b00000000000000000000
b6666666bb6666666bb7666666bb7666666bb7776666bb6777766bb6677776bb6667777bb6666777bb6666677bb6666667bb6666666b00000000000000000000
b6666666bb6666666bb6666666bb7666666bb7766666bb7777666bb6777766bb6677776bb6667777bb6666777bb6666677bb6666667b00000000000000000000
bd66666dbbd66666dbbd66666dbbd66666dbbd66666dbbd77666dbbd77766dbbd77776dbbd67777dbbd66777dbbd66677dbbd66667db00000000000000000000
bbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbb00000000000000000000
0bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb000000000000000000000
eeeeeeeeeeeee0eeeeee0eeeee0000000eeeee00eeeeeeeeeeeeeeeee0000000eeeeeeeeeeeeeeeeeeeeeeee000000000bbbbbbb000000000000000000000000
e99999999999e0e9999e0e999e0000000e999e00e999999999ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbe00000000bb66666bb00000000bbbbbbb00000000
e99999999999e0e9999e0e999e0000000e999eeee999999999ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbeeee00000b6611666b0000000bb66666bb0000000
e99994444499e0e9999e0e999eeee0eeee999ee99994444444ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbbbbe00000b6611166b0000000b6611666b0000000
e9999eeeee99e0e9999e0e444999e0e999444ee9999eeeeeeeee9999e0000000e3333bbbb3333eebbbb3333bbbe00000b6611666b0000000b6611166b0000000
e9999e000e99e0e9999e0eeee999e0e999eeeee9999e0000000e9999e0000000eeeeebbbbeeeeeebbbbeeeebbbe00000bd66666db0000000b6611666b0000000
e9999e000e99e0e9999e0000e999eee999e000e9999e0000000e9999e00000000000ebbbbe0000ebbbbe00ebbbe00000bbdddddbb0000000bb66666bb0000000
e9999eeeee99e0e9999e0000e444999444e000e9999eeeee000e9999e00000000000ebbbbe0000ebbbbe00ebbbe000000bbbbbbb000000000bbbbbbb00000000
e99999999944e0e9999e0000eeee999eeee000e99999999e000e9999e00000000000ebbbbe0000ebbbbe00ebbbe000000bbbbbbb000000000000000000000000
e999999999eee0e9999e0000eeee999eeee000e99999999e000e9999e00000000000ebbbbe0000ebbbbe00ebbbe00000bb66666bb00000000bbbbbbb00000000
e999944444e000e9999e0000e999444999e000e99994444e000e9999e00000000000ebbbbe0000ebbbbe00ebbbe00000b6611166b0000000bb66666bb0000000
e9999eeeeee000e9999e0000e999eee999e000e9999eeeee000e9999e00000000000ebbbbe0000ebbbbe00ebbbe00000b6616166b0000000b6611166b0000000
e9999e00000000e9999e0eeee999e0e999eeeee9999e0000000e9999e00000000000ebbbbe0000ebbbbeeeebbbe00000b6611166b0000000b6616166b0000000
e9999e00000000e9999e0e999444e0e444999ee9999eeeeeeeee9999eeeeeeee0000ebbbbe0000ebbbbbbbbbbbe00000bd66666db0000000b6611166b0000000
e9999e00000000e9999e0e999eeee0eeee999ee99999999999ee44999999999e0000ebbbbe0000ebbbbbbbb333e00000bbdddddbb0000000bb66666bb0000000
e9999e00000000e9999e0e999e0000000e999ee99999999999eeee999999999e0000ebbbbe0000ebbbbbbbbeeee000000bbbbbbb000000000bbbbbbb00000000
e4444e00000000e4444e0e444e0000000e444ee44444444444e00e444444444e0000e3333e0000e33333333e0000000000000000000000000bbbbbbb00000000
e4444e00000000e4444e0e444e0000000e444ee44444444444e00e444444444e0000e3333e0000e33333333e000000000000000000000000bb55555bb0000000
eeeeee00000000eeeeee0eeeee0000000eeeeeeeeeeeeeeeeee00eeeeeeeeeee0000eeeeee0000eeeeeeeeee000000000000000000000000b5500555b0000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b5500055b0000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b5500555b0000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bb55555bb0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060000000ee00000008000000ccc00000aaa00000900000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb00000000
6b600000ebbe000008280000cbbbc000abbba0000490000094b4900000000000000000000000000000000000000000000000000000000000bb55555bb0000000
06000000ebbe000082b280000ccc0000abbba0000b4900000949000000000000000000000000000000000000000000000000000000000000b5500055b0000000
000000000ee000000828000000000000abbba000049000000090000000000000000000000000000000000000000000000000000000000000b5505055b0000000
000000000000000000800000000000000aaa0000090000000000000000000000000000000000000000000000000000000000000000000000b5500055b0000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bb55555bb0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb00000000
__label__
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000000
000000000000000100009999999999900099990009990001000009990000999999999009999000010000bbbbbbbbbbbb00bbbbbbbb0000010000000000000000
000000000000000100009999999999900099990009990001000009990000999999999009999000010000bbbbbbbbbbbb00bbbbbbbb0000010000000000000000
000000000000000100009999444449900099990009990000000009990099994444444009999000010000bbbbbbbbbbbb00bbbbbbbbbbb0010000000000000000
0000000000000001000099990000099000999900044499900099944400999900000000099990000100003333bbbb333300bbbb3333bbb0010000000000000000
0000000000000001000099990000099000999900000099900099900000999901000000099990000100000000bbbb000000bbbb0000bbb0010000000000000000
1111111111111111111099990111099010999901111099900099901110999901111111099990111111111110bbbb011110bbbb0110bbb0111111111111111111
0000000000000001000099990000099000999900000044499944400000999900000000099990000100000000bbbb000100bbbb0000bbb0010000000000000000
0000000000000001000099999999944000999900000000099900000000999999990000099990000100000000bbbb000100bbbb0000bbb0010000000000000000
0000000000000001000099999999900000999900000000099900000000999999990000099990000100000000bbbb000100bbbb0000bbb0010000000000000000
0000000000000001000099994444400100999900000099944499900000999944440000099990000100000000bbbb000100bbbb0000bbb0010000000000000000
0000000000000001000099990000000100999900000099900099900000999900000000099990000100000000bbbb000100bbbb0000bbb0010000000000000000
0000000000000001000099990000000100999900000099900099900000999901000000099990000100000000bbbb000100bbbb0000bbb0010000000000000000
0000000000000001000099990000000100999900099944400044499900999900000000099990000000000000bbbb000100bbbbbbbbbbb0010000000000000000
0000000000000001000099990000000100999900099900000000099900999999999990044999999999000000bbbb000100bbbbbbbb3330010000000000000000
0000000000000001000099990000000100999900099900010000099900999999999990000999999999000000bbbb000100bbbbbbbb0000010000000000000000
00000000000000010000444400000001004444000444000100000444004444444444400004444444440000003333000100333333330000010000000000000000
00000000000000010000444400000001004444000444000100000444004444444444400004444444440000003333000100333333330000010000000000000000
00000000000000010000000000000001000000000000000100000000000000000000000000000000000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000
00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000000

__sfx__
c00000011d75000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
012400003060330601306050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605
79100008129001a900000001590000000199002090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
781000000a055050050c0050000515005000051100533005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
930000013f60000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
930000013f65000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
910000013f61000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
011000080c0530c000000000000030f3530e0000000000000c00000000000000c0001860018600130030c003000030c0030e0030c0030c0030c003130030c0030000300003000030c0030000300003000030c003
011000080300003000000000000030e2030e2500000000000c00000000000000c0001860018600130030c003000030c0030e0030c0030c0030c003130030c0030000300003000030c0030000300003000030c003
011000080c003021050210502105006000060502105021050c00000000000000c0001860018600130030c003000030c0030e0030c0030c0030c003130030c0030000300003000030c0030000300003000030c003
211000201873015730157351873015730157351573515735197301673016735197301673016735157351573518730157301573518730157301573515735157351973016730167351973016730167351573515735
211000201870015700157051870015700157051570515705197001670016705197001670016705157051570518700157001570518700157001570515705157051970016700167051970016700167051570515705
911000201a7001a70516700167051a7001a70516700167051c7001c7051d7001d7051c7001c7051a7001a7051a7001a70516700167051a7001a70516700167051c7001c7011d7001d7011c7001c7051a7001a705
011000200900309003010000100010905010030900302a0509003010000900309003109050900009003010000900309000090030100010905010030900302a050900301000090030100010905010000100009003
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003000000000000003000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003000030000300003000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90070000030440a555053051630500305003052930529305293050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305
940604000043000425004300042500405004052940529405294050040500405004050040500405004050040500405004050040500405004050040500405004050040500405004050040500405004050040500405
00080000030551c005070051d0051d0051d00514005110050f005170050c005130050b0050a0050b005000050b0050a0050000500005000050000500005000050000500005000050000500005000050000500005
900700000f54516555055051650500505005052950529505295050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
900e00000d323163031d3031b303223030f303183031d3031b3030c3030a3031b303293031f303003030030300303003030030300303003030030300303003030030300303003030030300303003030030300303
00080000228551b8551d8551f855228251b8251d8251f825228151b8151d8151f815228051f805228052480500805008050080500805008050080500805008050080500805008050080500805008050080500805
482800000362500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
00060000180251f02527035220351b03527025220251b02527015220151b015000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
000300003a51500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
002a00001371313703117032570324703027030070307703057030270300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703
900c00000a0240f035053051630500305003052930529305293050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305
900c00000f0240a035053051630500305003052930529305293050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305
__music__
03 08094344
03 090b4344
03 0a0b4344
03 0a0c4344
00 484b4a4c
00 484d4a4c
00 484a4a4c
00 484c6364
02 484c6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
03 08096364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364
00 625e6364

