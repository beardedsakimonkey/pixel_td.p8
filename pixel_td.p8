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
e4444e00000000e4444e0e444e0000000e444ee44444444444e00e444444444e0000e3333e0000e33333333e0000000000000000000000000000000000000000
e4444e00000000e4444e0e444e0000000e444ee44444444444e00e444444444e0000e3333e0000e33333333e0000000000000000000000000000000000000000
eeeeee00000000eeeeee0eeeee0000000eeeeeeeeeeeeeeeeee00eeeeeeeeeee0000eeeeee0000eeeeeeeeee0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060000000ee00000008000000ccc00000aaa00000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6b600000ebbe000008280000cbbbc000abbba0000490000094b49000000000000000000000000000000000000000000000000000000000000000000000000000
06000000ebbe000082b280000ccc0000abbba0000b49000009490000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ee000000828000000000000abbba0000490000000900000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000800000000000000aaa00000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00080000110200c0101d0001d0001d0001d00014000110000f000170000c000130000b0000a0000b000000000b0000a0000000000000000000000000000000000000000000000000000000000000000000000000
