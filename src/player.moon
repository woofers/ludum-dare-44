import Ship from require "ship"
export engine = require "engine"
require "pico"

class Player extends Ship
  new: (ships) =>
    super(13)
    @ships = ships
    @front = .2498
    @mid = -.07
    @model.y = 5
    @model.ax = @mid
    @model.ay = @front
    @children = {self}
    for _, ship in pairs(@ships)
      add(@children, ship)
    @set_defaults!
    @projection = {x: 0, y: 0}

  calc_direction: () =>
    @x = -(@front - @model.ay)
    @y = @mid - @model.ax
    if (@y > 0) then @y *= 3

  update: (dt) =>
    @projection = {}
    @projection.x, @projection.y = engine.project_point(@model.tx, @model.ty, @model.tz)
    @calc_direction!
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

    @inc_children("x", @x)
    @inc_children("y", @y)
    upper_bound = 13.5237
    lower_bound = -1.7895
    if (@model.y > upper_bound) then @set_children("y", upper_bound)
    if (@model.y < lower_bound) then @set_children("y", lower_bound)
    upper_bound = 4
    lower_bound = -4.3033
    if (@model.x > upper_bound) then @set_children("x", upper_bound)
    if (@model.x < lower_bound) then @set_children("x", lower_bound)

  inc_children: (key, increment) =>
    for _, child in pairs(@children)
      child\inc(key, increment * (if not child == self then -1 else 1))

  set_children: (key, value) =>
    for _, child in pairs(@children)
      offset = 0
      scale = 1
      if (@defaults[key]) then
        offset = -@defaults[key]
      if not child == self then
        scale = -1
      child\set(key, scale * value + offset)

  render: (dt) =>
    if (pico.is_held(pico.x_key)) then
      @draw_holo()
    print("X: #{@model.x}", 17, 105, 9)
    print("Y: #{@model.y}", 17, 110, 9)
    print("Z: #{@model.z}", 17, 115, 9)
    print("PX: #{@projection.x}", 75, 105, 9)
    print("PY: #{@projection.y}", 75, 110, 9)

  draw_holo: (x=-5) =>
    pico.draw_sprite(40, @projection.x + x, @projection.y, 1, 1)
    pico.draw_sprite(40, @projection.x + x, @projection.y + 8, 1, 1)
    pico.draw_sprite(40, @projection.x + x, @projection.y + 16, 1, 1)

  direction_x: () => @x
  direction_y: () => @y

{:Player}
