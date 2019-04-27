
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
    @other.z = 5
    @stars = Stars!

  destroy: () =>

  update: (dt) =>
    @stars\update(dt)
    @ship\update(dt)
    engine.update_camera!
    engine.update_3d!

  render: (dt) =>
    pico.bg(0)
    @stars\render(dt)
    engine.draw_3d!
    @ship\render(dt)

  render_debug: (dt) =>
    cpu = stat(1)
    mem = stat(0)
    cpu_color = 6
    mem_color = 6
    unless min_mem
      export min_mem = 9999
      export max_mem = 0

    if (mem < min_mem) then min_mem = mem
    if (mem > max_mem) then max_mem = mem

    if (cpu > 0.8) then cpu_color = 12
    if (mem > 250) then mem_color = 12

    print("cpu "..cpu, @level.current_room.x * pico.screen_size + 32, @level.current_room.y * pico.screen_size + 8, cpu_color)
    print("mem "..mem, @level.current_room.x * pico.screen_size + 32, @level.current_room.y * pico.screen_size + 16, mem_color)
    print("mem min "..min_mem, @level.current_room.x * pico.screen_size + 32, @level.current_room.y * pico.screen_size + 24, 6)
    print("mem max "..max_mem, @level.current_room.x * pico.screen_size + 32, @level.current_room.y * pico.screen_size + 32, 6)

{:Play}
