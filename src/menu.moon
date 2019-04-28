
require "pico"
import Ship from require "ship"
import Stars from require "stars"
import Play from require "play"

class Menu
  new: (@game_states) =>

  create: () =>
    engine.init_3d!
    @ship = Ship!
    @ship.model.y = 7
    @ship.model.z = -25
    @stars = Stars!
    @dir = 1
    @is_turning = false
    @turn_time = 0

  destroy: () =>
    if (@ship) then @ship\destroy!

  update: (dt) =>
    if (btn(pico.x_key)) then @game_states\push(Play(@game_states))
    @stars\update(dt)
    engine.update_camera!
    engine.update_3d!
    if (not @is_turning) then
      @ship.model.z += 0.5 * @dir
    else
      @ship.model.ay += 0.01
      if (@turn_time == 0) then sfx(0)
      @turn_time += dt
      if (@turn_time > .79) then
        @turn_time = 0
        @is_turning = false

    if (@ship.model.z > 2.249 and @dir == 1) then
      @dir = -1
      @is_turning = true
    else if (@ship.model.z < -7 and @dir == -1) then
      @dir = 1
      @is_turning = true


  render: (dt) =>
    @stars\render(dt)
    engine.draw_3d!

    @font("alien, E X P A N S I O N .", 17, 105)
    @font("press, \151", 17, 20)

  font: (text, x, y) =>
    print(text, x, y, 13)
    print(text, x + 1, y + 1, 7)

{:Menu}
