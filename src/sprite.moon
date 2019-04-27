
require "pico"

class Sprite
  new: (@x, @y, @width, @height) =>
    @x = @x or 0
    @y = @y or 0
    @\set_location(@x, @y)
    @\set_scale(1, 1)

  set_location: (@x, @y) =>

  set_scale: (x, y) =>
    @scale_x = x
    @scale_y = y

  translate: (x, y) =>
    @\set_location(@x + x, @y + y)

  facing_right: () =>
    @scale_x > 0

  facing_left: () =>
    @scale_x < 0

  left_x: () =>
    flr(@\local_x! / pico.tile_size)

  right_x: () =>
    flr((@\local_x! + pico.tile_size - 1) / pico.tile_size)

  top_y: () =>
    flr(@\local_y! / pico.tile_size)

  bottom_y: () =>
    flr((@\local_y! + pico.tile_size - 1) / pico.tile_size)

  grid_x: () =>
    flr(@x / pico.tile_size)

  grid_y: () =>
    flr(@y / pico.tile_size)

  local_x: () =>
    pico.mod(@x, pico.screen_size)

  local_y: () =>
    pico.mod(@y, pico.screen_size)

  local_grid_x: () =>
    flr(@\local_x! / pico.tile_size)

  local_grid_y: () =>
    flr(@\local_y! / pico.tile_size)

{:Sprite}
