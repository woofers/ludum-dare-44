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
    speed = .0025
    if (btn(pico.left)) then engine.camera!.ay -= speed
    if (btn(pico.right)) then engine.camera!.ay += speed
    if (btn(pico.down)) then engine.camera!.ax -= speed
    if (btn(pico.up)) then engine.camera!.ax += speed

{:Player}
