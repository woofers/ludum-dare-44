export engine = require "engine"
require "pico"

class Model
  new: (v, f, @color) =>
    @v = engine.read_vector_string(v)
    @f = engine.read_face_string(f)
    @model = engine.load_object(@v, @f, 0, 0, 0, 0, -.35, 0, false, k_colorize_dynamic, @color)
    @projection = {x: 0, y: 0}

  destroy: () =>
    engine.delete_object(@model)

  set: (key, value) =>
    @model[key] = value

  inc: (key, value) =>
    @model[key] += value

  hide: () =>
    if (not @hidden) then @model.z -= 1000
    @hidden = true

  show: () =>
    if (@hidden) then @model.z += 1000
    @hidden = false

  toggle: () =>
    if (@hidden) then @show!
    else @hide!

  update: (dt) =>
    @projection.x, @projection.y = engine.project_point(@model.tx, @model.ty, @model.tz)

{:Model}
