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
    speed = .004
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

    scale = 1.2
    if (btn(pico.down)) then
      @model.ax -= speed * scale
      bound = -.0979
      if (@model.ax < bound) then
        @model.ax = bound
    if (btn(pico.up)) then
      @model.ax += speed * scale
      bound = .0907
      if (@model.ax > bound) then
        @model.ax = bound

  render: (dt) =>
    print("X: #{@model.ax}", 17, 105, 9)
    print("Y: #{@model.ay}", 17, 110, 9)
    print("Z: #{@model.az}", 17, 115, 9)

{:Player}
