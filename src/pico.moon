
step = 1 / 60
tile_size = 8
sprite_wrap = 16
screen_size = 128
left = 0
right = 1
up = 2
down = 3
arrows = { right, left, up, down }
z_key = 4
x_key = 5

set_alpha_key = () ->
  palt(0, false)

reset_pallet = () ->
  pal!
  set_alpha_key!

draw_sprite = (id, x, y, tile_x, tile_y, flip_x, flip_y) ->
  adjust_x, adjust_y = 0, 0
  if (flip_x) then adjust_x = pico.tile_size * tile_x
  if (flip_y) then adjust_y = pico.tile_size * tile_y
  spr(id, x + adjust_x, y + adjust_y, tile_x, tile_y, flip_x, flip_y)

draw_rectangle = (x, y, width, height, color, border, border_color) ->
  border = border or 0
  border_color = border_color or 0
  rectfill(x, y, x + width, y + height, color)
  if border > 0 then
    draw_rectangle(x + border, y + border, width - 2 * border, height - 2 * border, border_color)

bg = (color) ->
  draw_rectangle(0, 0, screen_size - 1, screen_size - 1, color)

random_decimal = (min, max) ->
  min + rnd(max - min)

random = (min, max) ->
  min + flr(rnd(max - min))

round = (num) ->
  flr(num + 0.5)

mod = (a, b) ->
  a - flr(a / b) * b

-- Adapted from https://www.lexaloffle.com/bbs/?tid=3367
keys={}

is_held = (k) ->
  band(keys[k], 1) == 1

update_key = (k) ->
  if keys[k] == 0 then
    if btn(k) then keys[k] = 3
  elseif keys[k] == 1 then
    if btn(k) == false then keys[k] = 4
  elseif keys[k] == 3 then
    if btn(k) then keys[k] = 1
    else keys[k] = 4
  elseif keys[k] == 4 then
    if btn(k) then keys[k] = 3
    else keys[k] = 0

init_keys = () ->
  for a = 0, 5 do keys[a] = 0

update_keys = () ->
  for a = 0, 5 do update_key(a)

{:step,
 :tile_size,
 :sprite_wrap,
 :screen_size,
 :left,
 :right,
 :up,
 :down,
 :arrows,
 :z_key,
 :x_key,
 :set_alpha_key,
 :reset_pallet
 :bg,
 :draw_sprite,
 :draw_rectangle,
 :random_decimal,
 :random,
 :flag_get,
 :round,
 :mod,
 :is_held,
 :init_keys,
 :update_keys
}
