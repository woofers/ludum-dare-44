
require "pico"
export engine = require "engine"
import Player from require "player"
import Ship from require "ship"
import Stars from require "stars"

class Play
  new: (@game_states) =>

  create: () =>
    @ship = Player(self)
    @ship_colors = {2, 4, 8, 9, 10, 11, 12, 14}
    @score = 0
    @ships = {}
    for i = 1, 2
      @new_ship(i)
    @stars = Stars!
    @health = 1

  new_ship: (i) =>
    if (@ships[i]) then
      @score += 10
      @ships[i]\destroy!
      @ships[i] = nil
    @ships[i] = Ship(@ship_colors[pico.random(1, #@ship_colors)])
    @ships[i].model.x = pico.random(-10, 10)
    @ships[i].model.y = pico.random(-10, 10)
    @ships[i].model.z = pico.random(-30, -25)

  destroy: () =>

  update: (dt) =>
    for key, ship in pairs(@ships)
      ship.model.z += 0.1
      if (engine.intersect_bounding_box(@ship.model, ship.model)) then
        @health -= 0.001
        @ship\start_blink!
      if (ship.model.z > 10) then
        @new_ship(key)

    @stars\update(dt)
    @ship\update(dt)
    @stars\set_direction(@ship\direction_x!, @ship\direction_y!)
    engine.update_camera!
    engine.update_3d!

  render: (dt) =>
    @stars\render(dt)
    if (@ship.model.ax > .0274) then
      engine.draw_3d!
      @ship\render(dt)
    else
      @ship\render(dt)
      engine.draw_3d!
    @draw_life!
    @draw_abduct!

  draw_life: (x=8, y=10, width=32, height=8) =>
    bar = (width - 4) * @health
    if (bar <= -1) then bar = -1
    print("life", x + 2, y - 7, 7)
    pico.draw_rectangle(x, y, width, height, 7)
    pico.draw_rectangle(x + 1, y + 1, width - 2, height - 2, 0)
    if (bar > 0) then pico.draw_rectangle(x + 2, y + 2, bar, height - 4, 8)

  draw_abduct: (x=50, y=10) =>
    print("score", x + 2, y - 7, 7)
    print("#{@score}", x + 2, y, 7)

{:Play}
