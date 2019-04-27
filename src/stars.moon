import Sprite from require "sprite"
import Star from require "star"
require "pico"

class Stars extends Sprite
  new: () =>
    super(0, 0, pico.screen_size, pico.screen_size)
    amount = 80
    max_height = 0
    min_height = @height - 1
    min_width = 0
    max_width = @width - 1

    @stars = {}
    for i = 1, amount
      @stars[i] = Star(pico.random(min_width, max_width), pico.random(max_height, min_height))

  update: (dt) =>
    for i = 1, #@stars
      @stars[i]\update(dt)

  render: (dt) =>
    for i = 1, #@stars
      @stars[i]\render(dt)

{:Stars}
