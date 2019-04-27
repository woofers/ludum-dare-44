import GameObject from require "gameobject"
export engine = require "engine"
require "pico"

class Model extends GameObject
  new: (v, f, @color) =>
    @v = engine.read_vector_string(v)
    @f = engine.read_face_string(f)
    @model = engine.load_object(@v, @f, 0, 0, 0, 0, -.35, 0, false, k_colorize_dynamic, @color)
    @set_defaults!

  set_defaults: () =>
    @defaults = {}
    @defaults.x = @model.x
    @defaults.y = @model.y
    @defaults.z = @model.z

  set: (key, value) =>
    default = 0
    if (@defaults[key]) then default = @defaults[key]
    @model[key] = value + default

  inc: (key, value) =>
    @model[key] += value

{:Model}
