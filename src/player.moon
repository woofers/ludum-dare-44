import Ship from require "ship"
export engine = require "engine"
require "pico"

class Player extends Ship
  new: (game) =>
    super!
    @game = game
    @front = .2498
    @mid = -.07
    @model.y = 5
    @model.z = -5
    @model.ax = @mid
    @model.ay = @front
    @projection = {x: 0, y: 0}
    @blink_time = 0
    @blink_count = 0
    @x, @y = 0,0

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

    @update_shoot(dt)
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
    print("X: #{@model.x}", 17, 105, 9)
    print("Y: #{@model.y}", 17, 110, 9)
    print("Z: #{@model.z}", 17, 116, 9)

    @render_shoot(dt)
    if (pico.is_held(pico.x_key)) then
      @shoot!

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
        if (@game.score >= 3) then @game.score -= 3
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

  update_shoot: (dt) =>
    if (@is_shooting) then
      @shoot_radius -= dt
      if (@shoot_radius < 0) then
        @is_shooting = false

  render_shoot: (dt) =>
    if (@is_shooting) then
      circ(@shoot_location.x, @shoot_location.y, @shoot_radius, 8)

  shoot: () =>
    if (@is_shooting) return
    x, y = @x * -100, @y * -80
    if (y < 7.21) then
      y *= 0.1
    @shoot_radius = 5
    @shoot_time = 0
    @shoot_location = {x: @projection.x + x, y: @projection.y + y}
    @is_shooting = true

{:Player}
