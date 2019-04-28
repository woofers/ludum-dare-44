import Sprite from require "sprite"
import Human from require "human"
require "pico"

class Humans extends Human
  new: () =>
    super(0, 0, pico.screen_size, pico.screen_size)
    amount = 50
    max_height = 0
    min_height = @height - 1
    min_width = 0
    max_width = @width - 1

    @humans = {}
    for i = 1, amount
      @humans[i] = Human(pico.random(min_width, max_width), pico.random(max_height, min_height))

  update: (dt) =>
    for i = 1, #@humans
      @humans[i]\update(dt)

  render: (dt) =>
    for i = 1, #@humans
      @humans[i]\render(dt)

  set_direction: (x, y) =>
    for i = 1, #@humans
      @humans[i].direction = {x: x, y: y}

{:Humans}
