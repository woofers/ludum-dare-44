import Ship from require "ship"
import Holo from require "holo"
export engine = require "engine"
require "pico"

class Player extends Ship
  new: () =>
    super(13)
    @model.y = 5
    @model.ax = -.07
    @model.ay = .2498
    @holo = Holo!

  update: (dt) =>
    @holo\update(dt)
    speed = .0035
    if (btn(pico.left)) then
      @model.ay -= speed
      bound = .1703
      if (@model.ay < bound) then
        @model.ay = bound
    if (btn(pico.right)) then
      @model.ay += speed
      bound = .3296
      if (@model.ay > bound) then
        @model.ay = bound

    if (btn(pico.down)) then @model.ax -= speed
    if (btn(pico.up)) then @model.ax += speed

{:Player}
