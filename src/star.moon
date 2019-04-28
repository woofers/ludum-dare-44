import Sprite from require "sprite"
require "pico"

class Star extends Sprite
  new: (@x, @y) =>
    radius = pico.random(0, 1)
    super(@x, @y, radius, radius)
    @color = 7
    @direction = {x: .1, y: .1}
    @buffer = 10

  update: (dt) =>
    @x += @direction.x * pico.random(0, 15)
    @y += @direction.y * pico.random(0, 15)
    @height = pico.random(0, 3)
    if @x > pico.screen_size - 1
      @x = pico.random(0, pico.screen_size - @buffer)
    if @y > pico.screen_size - 1
      @y = pico.random(0, pico.screen_size - @buffer)
    if @x < 0
      @x = pico.random(@buffer, pico.screen_size - 1)
    if @y < 0
      @y = pico.random(@buffer, pico.screen_size - 1)

  render: (dt) =>
    pico.draw_rectangle(@x, @y, @width, @height, @color)

{:Star}
