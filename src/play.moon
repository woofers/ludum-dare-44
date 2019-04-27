
import GameObject from require "gameobject"
require "pico"
export engine = require "engine"
import Player from require "player"
import Ship from require "ship"
import Stars from require "stars"

class Play extends GameObject
  new: (@game_states) =>
    super!

  create: () =>
    engine.init_3d!
    @ship = Player!
    @other = Ship(2)
    @other.model.z = -25
    @stars = Stars!

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
    engine.draw_3d!
    @ship\render(dt)

    print("life", 10, 3, 7)
    sspr(8, 0, 8 * 4, 8, 8, 10)

{:Play}
