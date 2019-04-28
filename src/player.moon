import Ship from require "ship"
export engine = require "engine"
require "pico"

class Player extends Ship
  new: () =>
    super!
    @front = .2498
    @mid = -.07
    @model.y = 5
    @model.z = -5
    @model.ax = @mid
    @model.ay = @front
    @projection = {x: 0, y: 0}
    @blink_time = 0
    @blink_count = 0

  calc_direction: () =>
    @x = -(@front - @model.ay)
    @y = @mid - @model.ax
    if (@y > 0) then @y *= 4

  update: (dt) =>
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

    @update_blink(dt)
    @inc_children("x", @x)
    @inc_children("y", @y)
    upper_bound = 16.5237
    lower_bound = -4.7895
    if (@model.y > upper_bound) then @set_children("y", upper_bound)
    if (@model.y < lower_bound) then @set_children("y", lower_bound)
    upper_bound = 7
    lower_bound = -7.3033
    if (@model.x > upper_bound) then @set_children("x", upper_bound)
    if (@model.x < lower_bound) then @set_children("x", lower_bound)

  inc_children: (key, increment) =>
    @inc(key, increment)

  set_children: (key, value) =>
    @set(key, value)

  render: (dt) =>
    if (pico.is_held(pico.x_key)) then
      @draw_holo()

  draw_holo: (x=-5) =>
    if (@hidden) return
    pico.draw_sprite(40, @projection.x + x, @projection.y, 1, 1)
    pico.draw_sprite(40, @projection.x + x, @projection.y + 8, 1, 1)
    pico.draw_sprite(40, @projection.x + x, @projection.y + 16, 1, 1)

  direction_x: () => @x
  direction_y: () => @y

  start_blink: () =>
    @blink = true

  update_blink: (dt) =>
    if (@blink) then
      if (@blink_count >= 2) then
        @show!
        @blink = false
        @blink_time = 0
        @blink_count = 0
        return
      @blink_time += dt
      if (@blink_time > 0.2) then
        @toggle!
        @blink_time = 0
        @blink_count += 1

{:Player}
