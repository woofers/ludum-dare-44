import Sprite from require "sprite"
require "pico"

class Star extends Sprite
  new: (@x, @y) =>
    radius = pico.random(0, 1)
    super(x, y, radius, radius)
    @\set_location(@x, @y)
    @color = 7

  update: (dt) =>
   super\update(dt)
   speed = 15
   multiplier = pico.random(1, 5)
   @y += speed * multiplier * dt
   unless @y < pico.screen_size - 1
      respawn_zone = pico.random(0, 40)
      @y = respawn_zone

  render: (dt) =>
    super\render(dt)
    pico.draw_rectangle(@x, @y, @width, @height, @color)

{:Star}
