import Ship from require "ship"
import Holo from require "holo"
export engine = require "engine"
require "pico"

class Player extends Ship
  new: () =>
    super(13)
    @model.y = 5
    @model.ax = -.07
    @model.ay = .2797
    @holo = Holo!

  update: (dt) =>
    @holo\update(dt)
    if (btn(pico.up)) then @model.ax -= .01
    if (btn(pico.down)) then @model.ax += .01
    if (btn(pico.left)) then @model.ay += .01
    if (btn(pico.right)) then @model.ay -= .01
    if (btn(pico.z_key)) then @model.az += .01

{:Player}
