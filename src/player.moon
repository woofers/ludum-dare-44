import Ship from require "ship"
import Holo from require "holo"
export engine = require "engine"
require "pico"

class Player extends Ship
  new: () =>
    @holo = Holo!
    super(13)
    @model.y = 5
    @model.ax = -.07
    @model.ay = .2498
    @children = {@model, @holo.model}

  update: (dt) =>
    @holo\update(dt)
    speed = .004
    if (btn(pico.left)) then
      @inc_children("ay", -speed)
      bound = .1703
      if (@model.ay < bound) then
        @set_children("ay", bound)
    if (btn(pico.right)) then
      @model.ay += speed
      @inc_children("ay", speed)
      bound = .3296
      if (@model.ay > bound) then
        @set_children("ay", bound)

    scale = 1.2
    if (btn(pico.down)) then
      @inc_children("ax", -speed * scale)
      bound = -.0979
      if (@model.ax < bound) then
        @set_children("ax", bound)
    if (btn(pico.up)) then
      @inc_children("ax", speed * scale)
      bound = .0907
      if (@model.ax > bound) then
        @set_children("ax", bound)

    if (pico.is_held(pico.x_key)) then
      @holo.model.x = 0
    else
      @holo.model.x = 100


  inc_children: (key, increment) =>
    for _, child in pairs(@children)
      child[key] += increment

  set_children: (key, increment) =>
    for _, child in pairs(@children)
      child[key] = increment

  render: (dt) =>
    print("X: #{@model.ax}", 17, 105, 9)
    print("Y: #{@model.ay}", 17, 110, 9)
    print("Z: #{@model.az}", 17, 115, 9)

{:Player}
