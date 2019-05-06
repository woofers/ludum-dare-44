
export __setmetatable = setmetatable
export __metatables = {}

export tostring = (any) ->
  if type(any)=="function" then return "function"
  if any==nil then return "nil"
  if type(any)=="string" then return any
  if type(any)=="boolean"
    if any then return "true"
    return "false"
  if type(any)=="table" then
      str = "{ "
      for k,v in pairs(any)
        str=str..tostring(k).."->"..tostring(v).." "
      return str.."}"
  if type(any)=="number" then return ""..any
  return "unkown"

export setmetatable = (object, mt) ->
  __metatables[object] = mt
  __setmetatable(object, mt)

export getmetatable = (object) ->
  __metatables[object]

export rawget = (tbl, index) ->
  assert(type(tbl) == 'table', "bad argument #1 to 'rawget' ".."(table expected, got "..type(tbl)..")")
  ti = tbl.__index
  mt = getmetatable(tbl)
  value = nil
  tbl.__index = tbl
  __setmetatable(tbl, nil)
  value = tbl[index]
  tbl.__index = ti
  __setmetatable(tbl, mt)
  value

import Stack from require "stack"
import Menu from require "menu"
export pico = require "pico"
require "export"

export _update60 = () ->
  game_states\update(pico.step)

export _draw = () ->
  game_states\render(pico.step)

pico.reset_pallet!

export game_states = Stack!
game_states\push(Menu(game_states))

to_html!
