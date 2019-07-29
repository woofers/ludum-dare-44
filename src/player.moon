import Ship from require "ship"
export engine = require "engine"
require "pico"

class Player extends Ship
  new: (game, invert) =>
    super!
    @controls = { left: pico.left, right: pico.right }
    if (not invert) then
      @controls["left"] = pico.right
      @controls["right"] = pico.left
    @game = game
    @front = .2498
    @mid = -.07
    @model.y = 5
    @model.z = -5
    @model.ax = @mid
    @model.ay = @front
    @blink_time = 0
    @blink_count = 0
    @x, @y = 0,0
    @is_shooting = false

  calc_direction: () =>
    @x = -(@front - @model.ay)
    @y = @mid - @model.ax
    if (@y > 0) then @y *= 4

  update: (dt) =>
    super\update(dt)
    @calc_direction!
    speed = .004
    if (btn(@controls["left"])) then
      @inc_children("ay", -speed)
      bound = .1703
      if (@model.ay < bound) then
        @set_children("ay", bound)
    if (btn(@controls["right"])) then
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
    @render_shoot(dt)
    if (btnp(pico.x_key)) then
      @shoot!

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
        sfx(2)
        @blink_time = 0
        @blink_count += 1

  update_shoot: (dt) =>
    if (@is_shooting) then
      @shoot_radius -= dt * 3
      if (@shoot_radius <= 1) then
        @is_shooting = false

  render_shoot: (dt) =>
    if (@is_shooting) then
      circ(@shoot_location.x, @shoot_location.y, @shoot_radius, 8)
      @shoot_location.x -= 0.1 * @shoot_location.direction_x
      @shoot_location.y -= 0.1 * @shoot_location.direction_y

  shoot: () =>
    if (@is_shooting or @projection.x == 0) return
    sfx(5)
    x, y = @x * -100, @y * -80
    if (y < 7.21) then
      y *= 0.1
    printh(y)
    if (y <= 0) then
      y -= 20
    else
      y += 4
    @shoot_radius = 5
    @shoot_time = 0
    @shoot_location = {x: @projection.x + x, y: @projection.y + y, direction_x: @x, direction_y: @y}
    @is_shooting = true

{:Player}
