
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
    pico.bg(8)
    print("this is the menu", 17, 105, 7)

{:Menu}
