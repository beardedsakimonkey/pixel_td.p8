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
#include game_over.lua
end

do
#include core.lua
end
__gfx__
00000000000000000000000000000000000000000000000000000000555555505555555055555550bbbbbbb0eeeeeee0fffffff0000000000000000000000000
000000000555550005555500055555000bbbbb000eeeee000fffff005bbbbb105eeeee105fffff10b5555530e5555580f4444490000000000000000000000000
0000000005bbb10005eee10005fff1000b5553000e5558000f4449005b5553105e5558105f444910b5bbb130e5eee280f4fff290000000000000000000000000
0000000005b0310005e0810005f091000b5013000e5028000f4029005b5013105e5028105f402910b5b03130e5e08280f4f09290000000000000000000000000
000000000533310005888100059991000b1113000e2228000f2229005b1113105e2228105f222910b5333130e5888280f4999290000000000000000000000000
00000000011111000111110001111100033333000888880009999900533333105888881059999910b1111130e2222280f2222290000000000000000000000000
00000000000000000000000000000000000000000000000000000000111111101111111011111110333333308888888099999990000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaa0000088088007000000000bbb0000000000000000000000000000000000000000000011111111111000000000000000000000000000000000000
00000000a999a00082282280770000000bbdb0000000000000000000000000000000000000000000010101010101000001101000000000000000000000000000
00000000a999a0008222228077700000bbddb0000000000000000000000000000000000000000000001000100010000001010010000000000000000000000000
00000000a999a0000822280077000000bdddb0000000000000000000000000000000000000000000010101010101000001101000000000000000000000000000
000000000aaa00000082800070000000b1ddb0000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000
00000000000000000008000000000000bb1db0000000000000000000000000000000000000000000001000100010000001101000000000000000000000000000
000000000000000000000000000000000bb1b0000000000000000000000000000000000000000000000000000000000001010010000000000000000000000000
0000000000000000000000000000000000bbb0000000000000000000000000000000000000000000000000000000000001101000000000000000000000000000
ddddddd0ddddddd0ddddddd011111000111110001111100000000000000000000000000000000000000000000000000001000000000000000000000000000000
d00000d0d00000d0d00000d011dd10001d1d100011d1100000000000000000000000000000000000000000000000000001101000000000000000000000000000
d00dd0d0d0d0d0d0d00d00d01d1d100011d110001d1d100000000000000000000000000000000000000000000000000001010010000000000000000000000000
d0d0d0d0d00d00d0d0d0d0d01dd110001d1d100011d1100000000000000000000000000000000000000000000000000001101000000000000000000000000000
d0dd00d0d0d0d0d0d00d00d011111000111110001111100000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00000d0d00000d0d00000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddd0ddddddd0ddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb000000000000000000000
bb66666bbbb76666bbbb77666bbbb77766bbbb67776bbbb66777bbbb66677bbbb66667bbbb66666bbbb66666bbbb66666bbbb66666bb00000000000000000000
b6666666bb7666666bb7766666bb7766666bb6777666bb6677776bb6667777bb6666777bb6666677bb6666667bb6666666bb6666666b00000000000000000000
b6666666bb6666666bb7666666bb7766666bb7776666bb6777766bb6677776bb6667777bb6666777bb6666677bb6666667bb6666666b00000000000000000000
b6666666bb6666666bb6666666bb7666666bb7766666bb7777666bb6777766bb6677776bb6667777bb6666777bb6666677bb6666667b00000000000000000000
bd66666dbbd66666dbbd66666dbbd66666dbbd66666dbbd77666dbbd77766dbbd77776dbbd67777dbbd66777dbbd66677dbbd66667db00000000000000000000
bbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbb00000000000000000000
0bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb000000000000000000000
eeeeeeeeeeeee0eeeeee0eeeee0000000eeeee00eeeeeeeeeeeeeeeee0000000eeeeeeeeeeeeeeeeeeeeeeee000000000bbbbbbb000000000000000000000000
e99999999999e0e9999e0e999e0000000e999e00e999999999ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbe00000000bb66666bb00000000000000000000000
e99999999999e0e9999e0e999e0000000e999eeee999999999ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbeeee00000b6611666b00000000000000000000000
e99994444499e0e9999e0e999eeee0eeee999ee99994444444ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbbbbe00000b6611166b00000000000000000000000
e9999eeeee99e0e9999e0e444999e0e999444ee9999eeeeeeeee9999e0000000e3333bbbb3333eebbbb3333bbbe00000b6611666b00000000000000000000000
e9999e000e99e0e9999e0eeee999e0e999eeeee9999e0000000e9999e0000000eeeeebbbbeeeeeebbbbeeeebbbe00000bd66666db00000000000000000000000
e9999e000e99e0e9999e0000e999eee999e000e9999e0000000e9999e00000000000ebbbbe0000ebbbbe00ebbbe00000bbdddddbb00000000000000000000000
e9999eeeee99e0e9999e0000e444999444e000e9999eeeee000e9999e00000000000ebbbbe0000ebbbbe00ebbbe000000bbbbbbb000000000000000000000000
e99999999944e0e9999e0000eeee999eeee000e99999999e000e9999e00000000000ebbbbe0000ebbbbe00ebbbe0000000000000000000000000000000000000
e999999999eee0e9999e0000eeee999eeee000e99999999e000e9999e00000000000ebbbbe0000ebbbbe00ebbbe0000000000000000000000000000000000000
e999944444e000e9999e0000e999444999e000e99994444e000e9999e00000000000ebbbbe0000ebbbbe00ebbbe0000000000000000000000000000000000000
e9999eeeeee000e9999e0000e999eee999e000e9999eeeee000e9999e00000000000ebbbbe0000ebbbbe00ebbbe0000000000000000000000000000000000000
e9999e00000000e9999e0eeee999e0e999eeeee9999e0000000e9999e00000000000ebbbbe0000ebbbbeeeebbbe0000000000000000000000000000000000000
e9999e00000000e9999e0e999444e0e444999ee9999eeeeeeeee9999eeeeeeee0000ebbbbe0000ebbbbbbbbbbbe0000000000000000000000000000000000000
e9999e00000000e9999e0e999eeee0eeee999ee99999999999ee44999999999e0000ebbbbe0000ebbbbbbbb333e0000000000000000000000000000000000000
e9999e00000000e9999e0e999e0000000e999ee99999999999eeee999999999e0000ebbbbe0000ebbbbbbbbeeee0000000000000000000000000000000000000
e4444e00000000e4444e0e444e0000000e444ee44444444444e00e444444444e0000e3333e0000e33333333e0000000000000000000000000000000000000000
e4444e00000000e4444e0e444e0000000e444ee44444444444e00e444444444e0000e3333e0000e33333333e0000000000000000000000000000000000000000
eeeeee00000000eeeeee0eeeee0000000eeeeeeeeeeeeeeeeee00eeeeeeeeeee0000eeeeee0000eeeeeeeeee0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060000006666000000600000666660000aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6b6000006bb6000006b600006bbb6000abbba0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060000006bb600006bbb600066666000abbba0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006666000006b6000000000000abbba0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000600000000000000aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
