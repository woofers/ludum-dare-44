import Sprite from require "sprite"
require "pico"

class Human extends Sprite
  new: (@x, @y) =>
    radius = pico.random(0, 1)
    super(x, y, radius, radius)
    @\set_location(@x, @y)
    @head_colors = {4, 9, 15}
    @shirt_colors = {2, 3, 5, 6, 8, 10, 11, 14, 15}
    @pants_colors = {7, 12, 13}
    @head = @head_colors[pico.random(1, #@head_colors)]
    @shirt = @shirt_colors[pico.random(1, #@shirt_colors)]
    @pants = @pants_colors[pico.random(1, #@pants_colors)]
    @direction = {x: 0, y: 0}
    @buffer = 10

  update: (dt) =>
    @x += @direction.x * pico.random(0, 15)
    @y += @direction.y * pico.random(0, 15)
    if @x > pico.screen_size - 1
      @x = pico.random(0, pico.screen_size - @buffer)
    if @y > pico.screen_size - 1
      @y = pico.random(0, pico.screen_size - @buffer)
    if @x < 0
      @x = pico.random(@buffer, pico.screen_size - 1)
    if @y < 0
      @y = pico.random(@buffer, pico.screen_size - 1)

  render: (dt) =>
    pico.draw_rectangle(@x, @y, 0, 0, @head)
    pico.draw_rectangle(@x, @y + 1, 0, 0, @shirt)
    pico.draw_rectangle(@x, @y + 2, 0, 0, @pants)

{:Human}
