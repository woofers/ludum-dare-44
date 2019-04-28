
require "pico"
export engine = require "engine"
import Player from require "player"
import Ship from require "ship"
import Stars from require "stars"

class Play
  new: (@game_states) =>

  create: () =>
    engine.init_3d!
    @ship = Player!
    @other = Ship(2)
    @other.model.z = -25
    @stars = Stars!
    @health = 1

  destroy: () =>

  update: (dt) =>
    @other.model.z += 0.1
    @other.model.x += 0.1
    @stars\update(dt)
    @ship\update(dt)
    @stars\set_direction(@ship\direction_x!, @ship\direction_y!)
    engine.update_camera!
    engine.update_3d!

  render: (dt) =>
    pico.bg(0)
    @stars\render(dt)
    @ship\render(dt)
    engine.draw_3d!
    @health -= 0.01
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
    print("123", x + 2, y, 7)

{:Play}
