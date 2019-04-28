
require "pico"
import Ship from require "ship"
import Stars from require "stars"

class Menu
  new: (@game_states) =>

  create: () =>
    engine.init_3d!
    @ship = Ship!
    @ship.model.y = 7
    @stars = Stars!

  destroy: () =>
    @ship\destroy!

  update: (dt) =>
    if (btn(pico.x_key)) then @game_states\pop()
    @stars\update(dt)
    engine.update_camera!
    engine.update_3d!
    @ship.model.ay += 0.01

  render: (dt) =>
    pico.bg(0)
    @stars\render(dt)
    engine.draw_3d!

    print("alien expansion", 17, 105, 9)

{:Menu}
