
import GameObject from require "gameobject"
require "pico"

class Menu extends GameObject
  new: (@game_states) =>
    super!

  create: () =>

  destroy: () =>

  update: (dt) =>
    if (btn(pico.x_key)) then @game_states\pop()

  render: (dt) =>
    pico.bg(1)
    print("alien expansion", 17, 105, 9)

{:Menu}
