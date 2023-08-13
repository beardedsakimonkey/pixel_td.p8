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
00000000000000000000000000000000000000000000000000000000555555505555555055555550eeeeeee0bbbbbbb0ccccccc0000000000000000000000000
000000000555550005555500055555000eeeee000bbbbb000ccccc005eeeee105bbbbb105ccccc10e5555580b5555530c55555f0000000000000000000000000
0000000005eee10005bbb10005ccc1000e5558000b5553000c555f005e5558105b5553105c555f10e5eee280b5bbb130c5ccc1f0000000000000000000000000
0000000005e0810005b0310005c0f1000e5028000b5013000c501f005e5028105b5013105c501f10e5e08280b5b03130c5c0f1f0000000000000000000000000
00000000058881000533310005fff1000e2228000b1113000c111f005e2228105b1113105c111f10e5888280b5333130c5fff1f0000000000000000000000000
0000000001111100011111000111110008888800033333000fffff0058888810533333105fffff10e2222280b1111130c11111f0000000000000000000000000
000000000000000000000000000000000000000000000000000000001111111011111110111111108888888033333330fffffff0000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaa0000088088007000000000bbb0000000000000000000000000000000000000000000111111111111111011010000000000000000000000000000
00000000a999a00082282280770000000bbdb0000bbbbbbb00000000000000000000000000000000101010101010101010100100000000000000000000000000
00000000a999a0008222228077700000bbddb0000bdddddb00000000000000000000000000000000010001000100010011010000000000000000000000000000
00000000a999a0000822280077000000bdddb0000b1ddd1b00000000000000000000000000000000101010101010101010000000000000000000000000000000
000000000aaa00000082800070000000b1ddb0000bb1d1bb00000000000000000000000000000000000000000000000011010000000000000000000000000000
00000000000000000008000000000000bb1db00000bb1bb000000000000000000000000000000000010001000100010010100100000000000000000000000000
000000000000000000000000000000000bb1b000000bbb0000000000000000000000000000000000000000000000000011010000000000000000000000000000
0000000000000000000000000000000000bbb0000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000
8888888099999990bbbbbbb0aaaaaaa0000000000000000000000000000000000000000000000000000000000000000011010000000000000000000000000000
8000008090000090b00000b0a00000a0000000000000000000000000000000000000000000000000000000000000000010100100000000000000000000000000
8080808090009090b00bb0b0a00a00a00080800000009000000bb000000a00000000000000000000000000000000000011010000000000000000000000000000
8008008090090090b0b0b0b0a0aaa0a0000800000009000000b0b00000aaa0000000000000000000000000000000000010000000000000000000000000000000
8080808090900090b00b00b0a00a00a00080800000900000000b0000000a00000000000000000000000000000000000011010000000000000000000000000000
8000008090000090b00000b0a00000a0000000000000000000000000000000000000000000000000000000000000000010100100000000000000000000000000
8888888099999990bbbbbbb0aaaaaaa0000000000000000000000000000000000000000000000000000000000000000011010000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb000000000000000000000
bb66666bbbb76666bbbb77666bbbb77766bbbb67776bbbb66777bbbb66677bbbb66667bbbb66666bbbb66666bbbb66666bbbb66666bb00000000000000000000
b6666666bb7666666bb7766666bb7766666bb6777666bb6677776bb6667777bb6666777bb6666677bb6666667bb6666666bb6666666b00000000000000000000
b6666666bb6666666bb7666666bb7666666bb7776666bb6777766bb6677776bb6667777bb6666777bb6666677bb6666667bb6666666b00000000000000000000
b6666666bb6666666bb6666666bb7666666bb7766666bb7777666bb6777766bb6677776bb6667777bb6666777bb6666677bb6666667b00000000000000000000
bd66666dbbd66666dbbd66666dbbd66666dbbd66666dbbd77666dbbd77766dbbd77776dbbd67777dbbd66777dbbd66677dbbd66667db00000000000000000000
bbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbbbbdddddbb00000000000000000000
0bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb00bbbbbbb000000000000000000000
eeeeeeeeeeeee0eeeeee0eeeee0000000eeeee00eeeeeeeeeeeeeeeee0000000eeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000
e99999999999e0e9999e0e999e0000000e999e00e999999999ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbe0000000000000000000000000000000000000000
e99999999999e0e9999e0e999e0000000e999eeee999999999ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbeeee0000000000000000000000000000000000000
e99994444499e0e9999e0e999eeee0eeee999ee99994444444ee9999e0000000ebbbbbbbbbbbbeebbbbbbbbbbbe0000000000000000000000000000000000000
e9999eeeee99e0e9999e0e444999e0e999444ee9999eeeeeeeee9999e0000000e3333bbbb3333eebbbb3333bbbe0000000000000000000000000000000000000
e9999e000e99e0e9999e0eeee999e0e999eeeee9999e0000000e9999e0000000eeeeebbbbeeeeeebbbbeeeebbbe0000000000000000000000000000000000000
e9999e000e99e0e9999e0000e999eee999e000e9999e0000000e9999e00000000000ebbbbe0000ebbbbe00ebbbe0000000000000000000000000000000000000
e9999eeeee99e0e9999e0000e444999444e000e9999eeeee000e9999e00000000000ebbbbe0000ebbbbe00ebbbe0000000000000000000000000000000000000
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
06000000070000000ee00000077000000080000000e000000ccc0000077700000aaa00000eee0000090000000000000000000000000000000000000000000000
6b6000007b700000ebbe00007bb70000082800000e2e0000cbbbc0007bbb7000abbba000ebbbe0000490000094b4900000000000000000000000000000000000
0600000007000000ebbe00007bb7000082b28000e2b2e0000ccc000007770000abbba000ebbbe0000b4900000949000000000000000000000000000000000000
00000000000000000ee0000007700000082800000e2e00000000000000000000abbba000ebbbe000049000000090000000000000000000000000000000000000
000000000000000000000000000000000080000000e0000000000000000000000aaa00000eee0000090000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbbbbbbbbbbbbbbbbb00bbbbbbbbbbbbbbbbbb000000000000000000000000000000000bbbbbbb000000000bbbbbbb000000000bbbbbbb00000000
000000000bb2222222222222222b0bb2222222222222222b00000000000000000000000000000000bb66666bb0000000bb66666bb0000000bb66666bb0000000
bbbbbbbbbb22882888288828882b0b22882828288828882bbbbbbbbb000000000000000000000000b6611666b0000000b6611166b0000000b6616166b0000000
b2222222bb28222828288828222b0b28282828282228282b2222222b000000000000000000000000b6611166b0000000b6616166b0000000b6661666b0000000
b2888882bb2822288828282882b00b28282828288228822b2888882b000000000000000000000000b6611666b0000000b6611166b0000000b6616166b0000000
b2222222bb28282828282828222b0b28282828282228282b2222222b000000000000000000000000bd66666db0000000bd66666db0000000bd66666db0000000
bbbbbbbbbb28882828282828882b0b28822282288828282bbbbbbbbb000000000000000000000000bbdddddbb0000000bbdddddbb0000000bbdddddbb0000000
000000000b22222222222222222b0b2222b222222222222b000000000000000000000000000000000bbbbbbb000000000bbbbbbb000000000bbbbbbb00000000
000000000bbbbbbbbbbbbbbbbbbb0bbbbb0bbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb000000000bbbbbbb000000000bbbbbbb00000000
000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000bb66666bb0000000bb66666bb0000000bb66666bb0000000
000000000e33333333333333333333333333333e0000000000000000000000000000000000000000b6611666b0000000b6611166b0000000b6616166b0000000
eeeeeeeeee3b3b3bbb33bb3bbb33bb3bbb3b3b3eeeeeeeeee0000000000000000000000000000000b6611166b0000000b6616166b0000000b6661666b0000000
e3333333ee3b3b33b33b3333b33b3b3b3b3b3b3ee3333333e0000000000000000000000000000000b6611666b0000000b6611166b0000000b6616166b0000000
e3bbbbb3ee3b3b33b33b3ee3b33b3b3bb33bbb3ee3bbbbb3e0000000000000000000000000000000bb66666bb0000000bb66666bb0000000bb66666bb0000000
e3333333ee3b3b33b33b3333b33b3b3b3b333b3ee3333333e00000000000000000000000000000000bbbbbbb000000000bbbbbbb000000000bbbbbbb00000000
eeeeeeeeee33b33bbb33bb33b33bb33b3b3bbb3eeeeeeeeee00000000000000000000000000000000bbbbbbb000000000bbbbbbb000000000bbbbbbb00000000
000000000ee3333333333333333333333333333e0000000000000000000000000000000000000000bb55555bb0000000bb55555bb0000000bb55555bb0000000
0000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000b5500555b0000000b5500055b0000000b5505055b0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000b5500055b0000000b5505055b0000000b5550555b0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000b5500555b0000000b5500055b0000000b5505055b0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000bb55555bb0000000bb55555bb0000000bb55555bb0000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb000000000bbbbbbb000000000bbbbbbb00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd0ddd0dd00d0d00dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1d0d1d0d1d0d0d0d110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd10d0d0d0d0d0d0ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1d0d0d0d0d0d0d011d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd0ddd0d0d0ddd0dd10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11101110101011101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
c02400001855318503305030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503005030050300503
011400001825500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6d0100011835200200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
110100010c15200500003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010000011f64500603006030060300603006030060300603006030060300603006030060300603006030060300603006030060300603006030060300603006030060300603006030060300603006030060300603
010000011f63500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605
150f00100c0430c70018000180002461518500185001850011133000000000000000246151370000000000000c0000c60000000137002460000000000000c0001110013700000001170024600000000000018700
150f00100c0430c70018000180002461518515185251853511133000000000000000246151370000000000000c0000c60000000137002460000000000000c0001110013700000001170024600000000000018700
a10f00201822118221182111821118221182211821118211182211822118211182111822118221182111821117221172211721117211172211722117211172111722117221172111721117221172211721117211
a10f00201522115221152111521115221152211521115211152211522115211152111522115221152111521117221172211721117211172211722117211172111722117221172111721117221172211721117211
a11000201120019200192001920019200192001920019200192001920019200192001920019200192001920019200192001920019200192001920019200192001920019200192001920019200192001920019200
d11e00201823518225182351822518235182251823518225172351722517235172251723517225172351722515235152251523515225152351522515235152251723517225172351722517235172251723517225
111e00200c053040552461504055119500405524615000340c053030552461503055119500305524615010340c053000552461500055119500005524615000340c053030552461503055119500305524e1524615
a50f00201622116221162111621116221162211621116211162211622116211162111622116221162111621119221192211921119211192211922119211192111922119221192111921119221192211921119211
a50f00201822118221182111821118221182211821118211182211822118211182111822118221182111821114221142211421114211142211422114211142111422114221142111421114221142211421114211
a50f00201622116221162111621116221162211621116211162211622116211162111622116221162111621118221182211821118211182211822118211182111822118221182111821118221182211821118211
a50f00201422114221142111421114221142211421114211142211422114211142111422114221142111421119221192211921119211192211922119211192111822118221182111821118221182211821118211
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a50f00200a13322225222253a22522f2522225222252e2250a13322225222253a22522f2522225222252e2250d13325225252253d22525f252522525225312250d13325225252253d22525f25252252522531225
a50f00200c13324225242253c22524f252422524225302250c13324225242253c22524f252422524225302250813320225202253822520f2520225202252c2250813320225202253822520f2520225202252c225
a50f00200a13322225222253a22522f2522225222252e2250a13322225222253a22522f2522225222252e2250c13324225242253c22524f252422524225302250c13324225242253c22524f25242252422530225
a50f00200813320225202253822520f2520225202252c2250813320225202253822520f2520225202252c2250d13325225252253d22525f252522525225312250c13324225242253c22524f25242252422530225
a50f00201623516225162351622516235162251623516225162351622516235162251623516225162351622519235192251923519225192351922519235192251923519225192351922519235192251923519225
a50f00201823518225182351822518235182251823518225182351822518235182251823518225182351822514235142251423514225142351422514235142251423514225142351422514235142251423514225
a50f00201623516225162351622516235162251623516225162351622516235162251623516225162351622518235182251823518225182351822518235182251823518225182351822518235182251823518225
a50f00201423514225142351422514235142251423514225142351422514235142251423514225142351422519235192251923519225192351922519235192251823518225182351822518235182251823518225
a50f00200a13322200222003a20022f0022200222002e2000a13322200222003a20024f2524f0024f2524f000d13325200252003d20025f002520025200312000d13325200252003d20024f25252002520031200
011000080c07300035000000c0040c0730003500000000000c00000000000000c0000c0000000000000000000c00000000000000c0000c0000000000000000000c00000000000000c0000c000000000000000000
011000200c073000353c6153c6000c07300035000003c6000c073000353c6153c6000c07300035000003c6000c073000253c6153c6000c073000353c6153c6150c073000353c6153c6000c07300035000003c600
011000200c07300035306250ca320c073000350c4120c5350c07300035306250ca320c073000350c4120c5350f07303035336250fa320f073030350f4120f5350e07302035326250ea320e073020350e4120e535
011000200c07300035306000c2220c2220c2250c2250c5000c07300035306000c2220c2220c2250c2250c5000f07303035306000f2220f2220f2250f2250c5000e07302035306000e2220e2220e2250e2250c500
0110002018c5418c5218c550dc0018c5418c5218c550cc0018c5418c5218c550dc0018c5418c5218c5500c001bc541bc521bc5500c001bc541bc521bc5500c001ac541ac521ac5500c001ac541ac521ac5500c00
0110002018c4418c4218c4218c4218c4218c4218c4218c4218c4218c4218c4218c4218c4218c4218c4218c421bc421bc421bc421bc421bc421bc421bc421bc421ac401ac421ac421ac421ac421ac421ac421ac42
0110002018b5518c3518b5518c3518b5518c3518b5518c3518b5518c3518b5518c3518b5518c3518b5518c351bb551bc351bb551bc351bb551bc351bb551bc351ab551ac351ab551ac351ab551ac351ab551ac35
0110002018b550c30018b550c30018b550c30018b550c30018b5518c0518b5518c0518b5518c0518b5518c051bb551bc051bb551bc051bb551bc051bb551bc051ab551ac051ab551ac051ab551ac051ab551ac05
552000200c0350c0350c0310c0350000000000000000e0000e0350e0350e0310e0350f0350f0350f0310f0350d0350d0350d0310d0350100001000010000f0000f0350f0350f0310f03510035100351003110035
91200020051350f1350c1350a1350f1350c1350f1350c135051350f1350c1350a1350f1350c1350f1350c13508135121350f1350d135121350f135121350f13508135121350f1350d135121350f135121350f135
552000200c0350c1350c4151f6150c0130c4150c1350c0350e0350e0350e0311f6150f0350f0350f0310f0350d0350d1350d4151f6150d0130d4150d1350d0350f0350f0350f0311f61510035100351003110035
90070000030440a555053051630500305003052930529305293050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305
950604000042000415004300042500405004052940529405294050040500405004050040500405004050040500405004050040500405004050040500405004050040500405004050040500405004050040500405
01080000030551c005070051d0051d0051d00514005110050f005170050c005130050b0050a0050b005000050b0050a0050000500005000050000500005000050000500005000050000500005000050000500005
900700000f54516555055051650500505005052950529505295050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
900e00000d323163031d3031b303223030f303183031d3031b3030c3030a3031b303293031f303003030030300303003030030300303003030030300303003030030300303003030030300303003030030300303
900704000f5451b5551b5351b51500505005052950529505295050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
00040000180251f02527035220351b03527025220251b02527725227251b72527715227151b715000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
912800000fe5500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
9128000016e5500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
912800001be5500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
900c00000a0240f035053051630500305003052930529305293050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305
900c00000f0240a035053051630500305003052930529305293050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305003050030500305
001000001b7771f7672475727747277351a7001d7001f70021700247001d7001f707227071f707227072470700707007070070700707007070070700707007070070700707007070070700707007070070700700
48080500185351f5201f5101f515225051b5051d5051f505225051b5051d5051f505225051f505225052450500505005050050500505005050050500505005050050500505005050050500505005050050500505
000c0000205551f5551b55517555135550f5550855500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
000c0000075550a5550c55511555165551b5551f55500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
010400001a0252102529035240351d03529025240251d02529725247251d72529715247151d715000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
010400001c025230252b035260351f0352b025260251f0252b725267251f7252b715267151f715000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
010400001e025250252d03528035210352d02528025210252d72528725217252d7152871521715000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
__music__
00 0a424243
00 0b424243
00 080a4243
00 080b4243
00 090a4243
00 090b4243
00 090d4243
01 0e0d4243
00 0e0d4243
02 0d094d4e
00 41424243
00 41424243
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 0f424243
00 10424243
00 11424243
00 12424243
01 140f4243
00 15104243
00 16114243
00 17124243
01 14184243
00 15194243
00 161a4243
00 171b4243
00 1c184243
00 1c194243
00 1c1a4243
02 1c1b4243
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 48224e4e
00 48224e4e
00 1d224e4e
00 1e214e4e
00 1e214e4e
00 1e234e4e
01 1f234e4e
00 1f234e4e
00 1f244e4e
02 20244e4e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 49264243
00 25264243
03 27264243
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e
00 6c686d6e

