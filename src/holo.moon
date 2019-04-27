import Model from require "model"
require "pico"

class Holo extends Model
  new: () =>
    super("0003004afef80003063cfef8002b004afefc002b063cfefc0051004aff0a0051063cff0a0074004aff200074063cff200093004aff3e0093063cff3e00ac004aff6200ac063cff6200bf004aff8c00bf063cff8c00ca004affb900ca063cffb900ce004affe700ce063cffe700ca004a001600ca063c001600bf004a004300bf063c004300ac004a006d00ac063c006d0093004a00910093063c00910074004a00af0074063c00af0051004a00c50051063c00c5002b004a00d3002b063c00d30003004a00d70003063c00d7ffdc004a00d3ffdc063c00d3ffb6004a00c5ffb6063c00c5ff92004a00afff92063c00afff74004a0091ff74063c0091ff5a004a006dff5a063c006dff48004a0043ff48063c0043ff3c004a0016ff3c063c0016ff38004affe7ff38063cffe7ff3c004affb9ff3c063cffb9ff48004aff8cff48063cff8cff5a004aff62ff5a063cff62ff74004aff3eff74063cff3eff92004aff20ff92063cff20ffb6004aff0affb6063cff0affdc004afefcffdc063cfefc","0203010405030607050809070a0b090c0d0b0e0f0d10110f1213111415131617151819171a1b191c1d1b1e1f1d20211f2223212425232627252829272a2b292c2d2b2e2f2d30312f3233313435333637353839373a3b393c3d3b3626163e3f3d40013f0f1f2f020403040605060807080a090a0c0b0c0e0d0e100f101211121413141615161817181a191a1c1b1c1e1d1e201f202221222423242625262827282a292a2c2b2c2e2d2e302f303231323433343635363837383a393a3c3b3c3e3d060402024006403e063e3c3a3a3836363432323036302e362e2c262c2a262a282626242222201e1e1c1a1a1816161412121016100e160e0c0a0a08063e3a063a3606262216221e161e1a160e0a160a0616362e260636163e403f4002013f010303050707090b0b0d070d0f070f111313150f15170f17191f191b1f1b1d1f1f212323252727292b2b2d2f2f313333353737393f393b3f3b3d3f3f03071f232f23272f272b2f2f333f33373f3f070f0f171f3f0f2f", 4)
    @model.y = -1
    @model.z = -3.5
    @set_defaults!

  update: (dt) =>
    @model.ay += 0.0025

  hide: () =>
    if (not @hidden) then @model.z -= 1000
    @hidden = true

  show: () =>
    if (@hidden) then @model.z += 1000
    @hidden = false

{:Holo}
