import GameObject from require "gameobject"
export engine = require "engine"
require "pico"

class Model extends GameObject
  new: (v, f, @color) =>
    @v = engine.read_vector_string(v)
    @f = engine.read_face_string(f)
    @model = engine.load_object(@v, @f, 0, 0, 0, 0, -.35, 0, false, k_colorize_dynamic, @color)

{:Model}
