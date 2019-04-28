pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- ludumdare-44 0.0.1
-- by jaxson
require = (function(requires)
  modules = {}
  return function(name)
    if not modules[name] then
      modules[name] = requires[name]()
    end
    return modules[name]
  end
end)({
  ['pico'] = function()
    local step = 1 / 60
    local tile_size = 8
    local sprite_wrap = 16
    local screen_size = 128
    local left = 0
    local right = 1
    local up = 2
    local down = 3
    local arrows = {
      right,
      left,
      up,
      down
    }
    local z_key = 4
    local x_key = 5
    local set_alpha_key
    set_alpha_key = function()
      return palt(0, false)
    end
    local reset_pallet
    reset_pallet = function()
      pal()
      return set_alpha_key()
    end
    local draw_sprite
    draw_sprite = function(id, x, y, tile_x, tile_y, flip_x, flip_y)
      local adjust_x, adjust_y = 0, 0
      if (flip_x) then
        adjust_x = pico.tile_size * tile_x
      end
      if (flip_y) then
        adjust_y = pico.tile_size * tile_y
      end
      return spr(id, x + adjust_x, y + adjust_y, tile_x, tile_y, flip_x, flip_y)
    end
    local draw_rectangle
    draw_rectangle = function(x, y, width, height, color, border, border_color)
      border = border or 0
      border_color = border_color or 0
      rectfill(x, y, x + width, y + height, color)
      if border > 0 then
        return draw_rectangle(x + border, y + border, width - 2 * border, height - 2 * border, border_color)
      end
    end
    local bg
    bg = function(color)
      return draw_rectangle(0, 0, screen_size - 1, screen_size - 1, color)
    end
    local random_decimal
    random_decimal = function(min, max)
      return min + rnd(max - min)
    end
    local random
    random = function(min, max)
      return min + flr(rnd(max - min))
    end
    local round
    round = function(num)
      return flr(num + 0.5)
    end
    local mod
    mod = function(a, b)
      return a - flr(a / b) * b
    end
    local keys = { }
    local is_held
    is_held = function(k)
      return band(keys[k], 1) == 1
    end
    local is_pressed
    is_pressed = function(k)
      return band(keys[k], 2) == 2
    end
    local is_released
    is_released = function(k)
      return band(keys[k], 4) == 4
    end
    local update_key
    update_key = function(k)
      if keys[k] == 0 then
        if btn(k) then
          keys[k] = 3
        end
      elseif keys[k] == 1 then
        if btn(k) == false then
          keys[k] = 4
        end
      elseif keys[k] == 3 then
        if btn(k) then
          keys[k] = 1
        else
          keys[k] = 4
        end
      elseif keys[k] == 4 then
        if btn(k) then
          keys[k] = 3
        else
          keys[k] = 0
        end
      end
    end
    local init_keys
    init_keys = function()
      for a = 0, 5 do
        keys[a] = 0
      end
    end
    local update_keys
    update_keys = function()
      for a = 0, 5 do
        update_key(a)
      end
    end
    return {
      step = step,
      tile_size = tile_size,
      sprite_wrap = sprite_wrap,
      screen_size = screen_size,
      left = left,
      right = right,
      up = up,
      down = down,
      arrows = arrows,
      z_key = z_key,
      x_key = x_key,
      set_alpha_key = set_alpha_key,
      reset_pallet = reset_pallet,
      bg = bg,
      draw_sprite = draw_sprite,
      draw_rectangle = draw_rectangle,
      random_decimal = random_decimal,
      random = random,
      flag_get = flag_get,
      round = round,
      mod = mod,
      is_held = is_held,
      is_pressed = is_pressed,
      is_released = is_released,
      init_keys = init_keys,
      update_keys = update_keys
    }
  end;
  ['stack'] = function()
    local Stack
    do
      local _class_0
      local _base_0 = {
        is_empty = function(self)
          return #self.stack <= 0
        end,
        push = function(self, item)
          self.stack[#self.stack + 1] = item
        end,
        pop = function(self)
          if not (self:is_empty()) then
            self.stack[#self.stack]:destroy()
            self.stack[#self.stack] = nil
            return self:create()
          end
        end,
        create = function(self)
          if not (self:is_empty()) then
            return self:peek():create()
          end
        end,
        peek = function(self)
          if not (self:is_empty()) then
            return self.stack[#self.stack]
          end
        end,
        update = function(self, dt)
          if not (self:is_empty()) then
            return self:peek():update(dt)
          end
        end,
        render = function(self, dt)
          if not (self:is_empty()) then
            cls()
            return self:peek():render(dt)
          end
        end
      }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self)
          self.stack = { }
        end,
        __base = _base_0,
        __name = "Stack"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      Stack = _class_0
    end
    return {
      Stack = Stack
    }
  end;
  ['sprite'] = function()
    require("pico")
    local Sprite
    do
      local _class_0
      local _base_0 = {
        set_location = function(self, x, y)
          self.x, self.y = x, y
        end,
        set_scale = function(self, x, y)
          self.scale_x = x
          self.scale_y = y
        end,
        translate = function(self, x, y)
          return self:set_location(self.x + x, self.y + y)
        end,
        facing_right = function(self)
          return self.scale_x > 0
        end,
        facing_left = function(self)
          return self.scale_x < 0
        end,
        left_x = function(self)
          return flr(self:local_x() / pico.tile_size)
        end,
        right_x = function(self)
          return flr((self:local_x() + pico.tile_size - 1) / pico.tile_size)
        end,
        top_y = function(self)
          return flr(self:local_y() / pico.tile_size)
        end,
        bottom_y = function(self)
          return flr((self:local_y() + pico.tile_size - 1) / pico.tile_size)
        end,
        grid_x = function(self)
          return flr(self.x / pico.tile_size)
        end,
        grid_y = function(self)
          return flr(self.y / pico.tile_size)
        end,
        local_x = function(self)
          return pico.mod(self.x, pico.screen_size)
        end,
        local_y = function(self)
          return pico.mod(self.y, pico.screen_size)
        end,
        local_grid_x = function(self)
          return flr(self:local_x() / pico.tile_size)
        end,
        local_grid_y = function(self)
          return flr(self:local_y() / pico.tile_size)
        end
      }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, x, y, width, height)
          self.x, self.y, self.width, self.height = x, y, width, height
          self.x = self.x or 0
          self.y = self.y or 0
          self:set_location(self.x, self.y)
          return self:set_scale(1, 1)
        end,
        __base = _base_0,
        __name = "Sprite"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      Sprite = _class_0
    end
    return {
      Sprite = Sprite
    }
  end;
  ['star'] = function()
    local Sprite
    Sprite = require("sprite").Sprite
    require("pico")
    local Star
    do
      local _class_0
      local _parent_0 = Sprite
      local _base_0 = {
        update = function(self, dt)
          self.x = self.x + (self.direction.x * pico.random(0, 15))
          self.y = self.y + (self.direction.y * pico.random(0, 15))
          self.height = pico.random(0, 3)
          if self.x > pico.screen_size - 1 then
            self.x = pico.random(0, pico.screen_size - self.buffer)
          end
          if self.y > pico.screen_size - 1 then
            self.y = pico.random(0, pico.screen_size - self.buffer)
          end
          if self.x < 0 then
            self.x = pico.random(self.buffer, pico.screen_size - 1)
          end
          if self.y < 0 then
            self.y = pico.random(self.buffer, pico.screen_size - 1)
          end
        end,
        render = function(self, dt)
          return pico.draw_rectangle(self.x, self.y, self.width, self.height, self.color)
        end
      }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      _class_0 = setmetatable({
        __init = function(self, x, y)
          self.x, self.y = x, y
          local radius = pico.random(0, 1)
          _class_0.__parent.__init(self, x, y, radius, radius)
          self:set_location(self.x, self.y)
          self.color = 7
          self.direction = {
            x = .1,
            y = .1
          }
          self.buffer = 10
        end,
        __base = _base_0,
        __name = "Star",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            local parent = rawget(cls, "__parent")
            if parent then
              return parent[name]
            end
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Star = _class_0
    end
    return {
      Star = Star
    }
  end;
  ['stars'] = function()
    local Sprite
    Sprite = require("sprite").Sprite
    local Star
    Star = require("star").Star
    require("pico")
    local Stars
    do
      local _class_0
      local _parent_0 = Sprite
      local _base_0 = {
        update = function(self, dt)
          for i = 1, #self.stars do
            self.stars[i]:update(dt)
          end
        end,
        render = function(self, dt)
          for i = 1, #self.stars do
            self.stars[i]:render(dt)
          end
        end,
        set_direction = function(self, x, y)
          for i = 1, #self.stars do
            self.stars[i].direction = { }
            self.stars[i].direction.x = x
            self.stars[i].direction.y = y
          end
        end
      }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      _class_0 = setmetatable({
        __init = function(self)
          _class_0.__parent.__init(self, 0, 0, pico.screen_size, pico.screen_size)
          local amount = 50
          local max_height = 0
          local min_height = self.height - 1
          local min_width = 0
          local max_width = self.width - 1
          self.stars = { }
          for i = 1, amount do
            self.stars[i] = Star(pico.random(min_width, max_width), pico.random(max_height, min_height))
          end
        end,
        __base = _base_0,
        __name = "Stars",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            local parent = rawget(cls, "__parent")
            if parent then
              return parent[name]
            end
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Stars = _class_0
    end
    return {
      Stars = Stars
    }
  end;
  ['model'] = function()
    engine = require("engine")
    require("pico")
    local Model
    do
      local _class_0
      local _base_0 = {
        set_defaults = function(self)
          self.defaults = { }
          self.defaults.x = self.model.x
          self.defaults.y = self.model.y
          self.defaults.z = self.model.z
        end,
        destroy = function(self)
          return engine.delete_object(self.model)
        end,
        set = function(self, key, value)
          local default = 0
          if (self.defaults[key]) then
            default = self.defaults[key]
          end
          self.model[key] = value + default
        end,
        inc = function(self, key, value)
          self.model[key] = self.model[key] + value
        end
      }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, v, f, color)
          self.color = color
          self.v = engine.read_vector_string(v)
          self.f = engine.read_face_string(f)
          self.model = engine.load_object(self.v, self.f, 0, 0, 0, 0, -.35, 0, false, k_colorize_dynamic, self.color)
          return self:set_defaults()
        end,
        __base = _base_0,
        __name = "Model"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      Model = _class_0
    end
    return {
      Model = Model
    }
  end;
  ['menu'] = function()
    require("pico")
    local Ship
    Ship = require("ship").Ship
    local Stars
    Stars = require("stars").Stars
    local Menu
    do
      local _class_0
      local _base_0 = {
        create = function(self)
          engine.init_3d()
          self.ship = Ship()
          self.ship.model.y = 7
          self.ship.model.z = -25
          self.stars = Stars()
          self.dir = 1
          self.is_turning = false
          self.turn_time = 0
        end,
        destroy = function(self)
          return self.ship:destroy()
        end,
        update = function(self, dt)
          if (btn(pico.x_key)) then
            self.game_states:pop()
          end
          self.stars:update(dt)
          engine.update_camera()
          engine.update_3d()
          if (not self.is_turning) then
            self.ship.model.z = self.ship.model.z + (0.5 * self.dir)
          else
            self.ship.model.ay = self.ship.model.ay + 0.01
            if (self.turn_time == 0) then
              sfx(0)
            end
            self.turn_time = self.turn_time + dt
            if (self.turn_time > .79) then
              self.turn_time = 0
              self.is_turning = false
            end
          end
          printh(self.time)
          if (self.ship.model.z > 2.249 and self.dir == 1) then
            self.dir = -1
            self.is_turning = true
          else
            if (self.ship.model.z < -7 and self.dir == -1) then
              self.dir = 1
              self.is_turning = true
            end
          end
        end,
        render = function(self, dt)
          pico.bg(0)
          self.stars:render(dt)
          engine.draw_3d()
          self:font("alien, E X P A N S I O N .", 17, 105)
          return self:font("press, \151", 17, 20)
        end,
        font = function(self, text, x, y)
          print(text, x, y, 13)
          return print(text, x + 1, y + 1, 7)
        end
      }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, game_states)
          self.game_states = game_states
        end,
        __base = _base_0,
        __name = "Menu"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      Menu = _class_0
    end
    return {
      Menu = Menu
    }
  end;
  ['play'] = function()
    require("pico")
    engine = require("engine")
    local Player
    Player = require("player").Player
    local Ship
    Ship = require("ship").Ship
    local Stars
    Stars = require("stars").Stars
    local Play
    do
      local _class_0
      local _base_0 = {
        create = function(self)
          self.ship = Player()
          self.ship_colors = {
            2,
            4,
            8,
            9,
            10,
            11,
            12,
            14
          }
          self.ships = { }
          for i = 1, 2 do
            self:new_ship(i)
          end
          self.stars = Stars()
          self.health = 1
        end,
        new_ship = function(self, i)
          if (self.ships[i]) then
            self.ships[i]:destroy()
            self.ships[i] = nil
          end
          self.ships[i] = Ship(self.ship_colors[pico.random(1, #self.ship_colors)])
          self.ships[i].model.x = pico.random(-10, 10)
          self.ships[i].model.y = pico.random(-10, 10)
          self.ships[i].model.z = pico.random(-30, -25)
        end,
        destroy = function(self) end,
        update = function(self, dt)
          for key, ship in pairs(self.ships) do
            ship.model.z = ship.model.z + 0.1
            if (engine.intersect_bounding_box(self.ship.model, ship.model)) then
              self.health = self.health - 0.001
            end
            if (ship.model.z > 10) then
              self:new_ship(key)
            end
          end
          self.stars:update(dt)
          self.ship:update(dt)
          self.stars:set_direction(self.ship:direction_x(), self.ship:direction_y())
          engine.update_camera()
          return engine.update_3d()
        end,
        render = function(self, dt)
          pico.bg(0)
          self.stars:render(dt)
          if (self.ship.model.ax > .0274) then
            engine.draw_3d()
            self.ship:render(dt)
          else
            self.ship:render(dt)
            engine.draw_3d()
          end
          self:draw_life()
          return self:draw_abduct()
        end,
        draw_life = function(self, x, y, width, height)
          if x == nil then
            x = 8
          end
          if y == nil then
            y = 10
          end
          if width == nil then
            width = 32
          end
          if height == nil then
            height = 8
          end
          local bar = (width - 4) * self.health
          if (bar <= -1) then
            bar = -1
          end
          print("life", x + 2, y - 7, 7)
          pico.draw_rectangle(x, y, width, height, 7)
          pico.draw_rectangle(x + 1, y + 1, width - 2, height - 2, 0)
          if (bar > 0) then
            return pico.draw_rectangle(x + 2, y + 2, bar, height - 4, 8)
          end
        end,
        draw_abduct = function(self, x, y)
          if x == nil then
            x = 50
          end
          if y == nil then
            y = 10
          end
          print("score", x + 2, y - 7, 7)
          return print("123", x + 2, y, 7)
        end
      }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, game_states)
          self.game_states = game_states
        end,
        __base = _base_0,
        __name = "Play"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      Play = _class_0
    end
    return {
      Play = Play
    }
  end;
  ['engine'] = function()
    ----Electric Gryphon's 3D Library----
    ----https://github.com/electricgryphon/Pico-8-Gryphon-3D-Engine-Library----
    ----From https://www.lexaloffle.com/bbs/?tid=28077----
    ----NOTE: Modified to reduce token usage----
    
    hex_string_data = "0123456789abcdef"
    char_to_hex = {}
    for i=1,#hex_string_data do
        char_to_hex[sub(hex_string_data,i,i)]=i-1
    end
    
    function read_byte(string)
        return char_to_hex[sub(string,1,1)]*16+char_to_hex[sub(string,2,2)]
    end
    
    function read_2byte_fixed(string)
        local a=read_byte(sub(string,1,2))
        local b=read_byte(sub(string,3,4))
        local val =a*256+b
        return val/256
    end
    
    cur_string=""
    cur_string_index=1
    function load_string(string)
        cur_string=string
        cur_string_index=1
    end
    
    function read_vector()
        v={}
        for i=1,3 do
            text=sub(cur_string,cur_string_index,cur_string_index+4)
            value=read_2byte_fixed(text)
            v[i]=value
            cur_string_index+=4
        end
        return v
    end
    
    function read_face()
        f={}
        for i=1,3 do
            text=sub(cur_string,cur_string_index,cur_string_index+2)
            value=read_byte(text)
            f[i]=value
            cur_string_index+=2
        end
        return f
    end
    
    function read_vector_string(string)
        vector_list={}
        load_string(string)
        while(cur_string_index<#string)do
            vector=read_vector()
            add(vector_list,vector)
        end
            return vector_list
    end
    
    function read_face_string(string)
        face_list={}
        load_string(string)
        while(cur_string_index<#string)do
            face=read_face()
            add(face_list,face)
        end
            return face_list
    end
    ------------------------------------------------------------end hex string data handling--------------------------------
    
    
    -------------------------------------------------------------BEGIN CUT HERE-------------------------------------------------
    ------------------------------------------------------Electric Gryphon's 3D Library-----------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------
    
    k_color1=4
    k_color2=5
    
    k_screen_scale=80
    k_x_center=64
    k_y_center=64
    
    
    
    z_clip=-3
    z_max=-50
    
    k_min_x=0
    k_max_x=128
    k_min_y=0
    k_max_y=128
    
    
    
    --These are used for the 2 scanline color shading scheme
    double_color_list=  {{0,0,0,0,0,0,0,0,0,0},
                         {0,0,0,0,0,0,0,0,0,0},
    
                        {0,0,1,1,1,1,13,13,12,12},
                        {0,0,0,1,1,1,1,13,13,12},
    
                        {2,2,2,2,8,8,14,14,14,15},
                        {0,1,1,2,2,8,8,8,14,14},
    
                        {1,1,1,1,3,3,11,11,10,10},
                        {0,1,1,1,1,3,3,11,11,10},
    
                        {1,1,2,2,4,4,9,9,10,10},
                        {0,1,1,2,2,4,4,9,9,10},
    
                        {0,0,1,1,5,5,13,13,6,6},
                        {0,0,0,1,1,5,5,13,13,6},
    
                        {1,1,5,5,6,6,6,6,7,7},
                        {0,1,1,5,5,6,6,6,6,7},
    
                        {5,5,6,6,7,7,7,7,7,7},
                        {0,5,5,6,6,7,7,7,7,7},
    
                        {2,2,2,2,8,8,14,14,15,15},
                        {0,2,2,2,2,8,8,14,14,15},
    
                        {2,2,4,4,9,9,15,15,7,7},
                        {0,2,2,4,4,9,9,15,15,7},
    
                        {4,4,9,9,10,10,7,7,7,7},
                        {0,4,4,9,9,10,10,7,7,7},
    
                        {1,1,3,3,11,11,10,10,7,7},
                        {0,1,1,3,3,11,11,10,10,7},
    
                        {13,13,13,12,12,12,6,6,7,7},
                        {0,5,13,13,12,12,12,6,6,7},
    
                        {1,1,5,5,13,13,6,6,7,7},
                        {0,1,1,5,5,13,13,6,6,7},
    
                        {2,2,2,2,14,14,15,15,7,7},
                        {0,2,2,2,2,14,14,15,15,7},
    
                        {4,4,9,9,15,15,7,7,7,7},
                        {0,4,4,9,9,15,15,7,7,7}
                        }
    
    
    k_ambient=.3
    function color_faces(object,base)
        --local p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z
    
    
            for i=1,#object.faces do
                local face=object.faces[i]
            --for face in all(object.faces)do
                local p1x=object.t_vertices[face[1]][1]
                local p1y=object.t_vertices[face[1]][2]
                local p1z=object.t_vertices[face[1]][3]
                local p2x=object.t_vertices[face[2]][1]
                local p2y=object.t_vertices[face[2]][2]
                local p2z=object.t_vertices[face[2]][3]
                local p3x=object.t_vertices[face[3]][1]
                local p3y=object.t_vertices[face[3]][2]
                local p3z=object.t_vertices[face[3]][3]
    
    
    
                local nx,ny,nz = vector_cross_3d(p1x,p1y,p1z,
                                    p2x,p2y,p2z,
                                    p3x,p3y,p3z)
    
    
            nx,ny,nz = normalize(nx,ny,nz)
            local b = vector_dot_3d(nx,ny,nz,light1_x,light1_y,light1_z)
            --see how closely the light vector and the face normal line up and shade appropriately
    
            -- print(nx.." "..ny.." "..nz,10,i*8+8,8)
            -- flip()
            if(object.color_mode==k_multi_color_dynamic)then
                face[4],face[5]=color_shade(object.base_faces[i][4], mid( b,0,1)*(1-k_ambient)+k_ambient )
            else
                face[4],face[5]=color_shade(base, mid( b,0,1)*(1-k_ambient)+k_ambient )
            end
        end
    
    end
    
    
    function color_shade(color,brightness)
        --return double_color_list[ (color+1)*2-1 ][flr(brightness*10)] , double_color_list[ (color+1)*2 ][flr(brightness*10)]
        local b= band(brightness*10,0xffff)
        local c= (color+1)*2
        return double_color_list[ c-1 ][b] , double_color_list[ c ][b]
    end
    
    
    
    light1_x=.1
    light1_y=.35
    light1_z=.2
    
    --t_light gets written to
    t_light_x=0
    t_light_y=0
    t_light_z=0
    
    function init_light()
        light1_x,light1_y,light1_z=normalize(light1_x,light1_y,light1_z)
    end
    
    function update_light()
        t_light_x,t_light_y,t_light_z = rotate_cam_point(light1_x,light1_y,light1_z)
    end
    
    function normalize(x,y,z)
        local x1=shl(x,2)
        local y1=shl(y,2)
        local z1=shl(z,2)
    
        local inv_dist=1/sqrt(x1*x1+y1*y1+z1*z1)
    
        return x1*inv_dist,y1*inv_dist,z1*inv_dist
    
    end
    
    function    vector_dot_3d(ax,ay,az,bx,by,bz)
        return ax*bx+ay*by+az*bz
    end
    
    function    vector_cross_3d(px,py,pz,ax,ay,az,bx,by,bz)
    
         ax-=px
         ay-=py
         az-=pz
         bx-=px
         by-=py
         bz-=pz
    
    
        local dx=ay*bz-az*by
        local dy=az*bx-ax*bz
        local dz=ax*by-ay*bx
        return dx,dy,dz
    end
    
    
    
    k_colorize_static = 1
    k_colorize_dynamic = 2
    k_multi_color_static = 3
    k_multi_color_dynamic = 4
    k_preset_color = 5
    
    --Function load object:
    --object_vertices: vertex list for object (see above)
    --object_faces: face list for object (see above)
    --x,y,z: translated center for the the object
    --ax,ay,az: rotation of object about these axis
    --obstacle: boolean will the player collide with this?
    --color mode:
    --k_colorize_static = 1 : shade the model at init with one shaded color
    --k_colorize_dynamic = 2 : color the model dynamically with one shade color -- slow
    --k_multi_color_static = 3 : shade the model based on colors defined in face list
    --k_multi_color_dynamic = 4 : shade the model dynamically based on colors define din face list -- slow
    --k_preset_color = 5 : use the colors defined in face list only -- no lighting effects
    
    function load_object(object_vertices,object_faces,x,y,z,ax,ay,az,obstacle,color_mode,color)
        object=new_object()
    
        object.vertices=object_vertices
    
    
        --make local deep copy of faces
        --if we don't car about on-demand shading we can share faces
        --but it means that objects will look wrong when rotated
    
        if(color_mode==k_preset_color)then
            object.faces=object_faces
        else
            object.base_faces=object_faces
            object.faces={}
            for i=1,#object_faces do
                object.faces[i]={}
                for j=1,#object_faces[i] do
                    object.faces[i][j]=object_faces[i][j]
                end
            end
        end
    
    
        object.radius=0
    
        --make local deep copy of translated vertices
        --we share the initial vertices
        for i=1,#object_vertices do
            object.t_vertices[i]={}
                for j=1,3 do
                    object.t_vertices[i][j]=object.vertices[i][j]
                end
        end
    
        object.ax=ax or 0
        object.ay=ay or 0
        object.az=az or 0
    
        transform_object(object)
    
        set_radius(object)
        set_bounding_box(object)
    
        object.x=x or 0
        object.y=y or 0
        object.z=z or 0
    
        object.color = color or 8
        object.color_mode= color_mode or k_colorize_static
    
        object.obstacle = obstacle or false
    
        if(obstacle)add(obstacle_list,object)
    
        if(color_mode==k_colorize_static or color_mode==k_colorize_dynamic or color_mode==k_multi_color_static )then
            color_faces(object,color)
        end
    
    
    
        return object
    end
    
    function set_radius(object)
        for vertex in all(object.vertices) do
            object.radius=max(object.radius,vertex[1]*vertex[1]+vertex[2]*vertex[2]+vertex[3]*vertex[3])
        end
        object.radius=sqrt(object.radius)
    end
    
    function set_bounding_box(object)
        for vertex in all(object.t_vertices) do
    
            object.min_x=min(vertex[1],object.min_x)
            object.min_y=min(vertex[2],object.min_y)
            object.min_z=min(vertex[3],object.min_z)
            object.max_x=max(vertex[1],object.max_x)
            object.max_y=max(vertex[2],object.max_y)
            object.max_z=max(vertex[3],object.max_z)
        end
    
    end
    
    function intersect_bounding_box(object_a, object_b)
        return
            ((object_a.min_x+object_a.x < object_b.max_x+object_b.x) and (object_a.max_x+object_a.x > object_b.min_x+object_b.x) and
             (object_a.min_y+object_a.y < object_b.max_y+object_b.y) and (object_a.max_y+object_a.y > object_b.min_y+object_b.y) and
             (object_a.min_z+object_a.z < object_b.max_z+object_b.z) and (object_a.max_z+object_a.z > object_b.min_z+object_b.z))
    end
    
    function new_object()
        object={}
        object.vertices={}
        object.faces={}
    
        object.t_vertices={}
    
    
        object.x=0
        object.y=0
        object.z=0
    
        object.rx=0
        object.ry=0
        object.rz=0
    
        object.tx=0
        object.ty=0
        object.tz=0
    
        object.ax=0
        object.ay=0
        object.az=0
    
        object.sx=0
        object.sy=0
        object.radius=10
        object.sradius=10
        object.visible=true
    
        object.render=true
        object.background=false
        object.ring=false
    
        object.min_x=100
        object.min_y=100
        object.min_z=100
    
        object.max_x=-100
        object.max_y=-100
        object.max_z=-100
    
        object.vx=0
        object.vy=0
        object.vz=0
    
        add(object_list,object)
        return object
    
    end
    
    function delete_object(object)
        del(object_list,object)
    end
    
    
    function new_triangle(p1x,p1y,p2x,p2y,p3x,p3y,z,c1,c2)
    
        add(triangle_list,{p1x=p1x,
                           p1y=p1y,
                           p2x=p2x,
                           p2y=p2y,
                           p3x=p3x,
                           p3y=p3y,
                           tz=z,
                           c1=c1,
                           c2=c2})
    
    
    
    
    end
    
    function draw_triangle_list()
        --for t in all(triangle_list) do
        for i=1,#triangle_list do
            local t=triangle_list[i]
            shade_trifill( t.p1x,t.p1y,t.p2x,t.p2y,t.p3x,t.p3y, t.c1,t.c2 )
        end
    end
    
    function update_visible(object)
            object.visible=false
    
            local px,py,pz = object.x-cam_x,object.y-cam_y,object.z-cam_z
            object.tx, object.ty, object.tz =rotate_cam_point(px,py,pz)
    
            object.sx,object.sy = project_point(object.tx,object.ty,object.tz)
            object.sradius=project_radius(object.radius,object.tz)
            object.visible= is_visible(object)
    end
    
    function cam_transform_object(object)
        if(object.visible)then
    
            for i=1, #object.vertices do
                local vertex=object.t_vertices[i]
    
                vertex[1]+=object.x - cam_x
                vertex[2]+=object.y - cam_y
                vertex[3]+=object.z - cam_z
    
                vertex[1],vertex[2],vertex[3]=rotate_cam_point(vertex[1],vertex[2],vertex[3])
    
            end
    
    
        end
    end
    
    function transform_object(object)
    
    
    
    
        if(object.visible)then
            generate_matrix_transform(object.ax,object.ay,object.az)
            for i=1, #object.vertices do
                local t_vertex=object.t_vertices[i]
                local vertex=object.vertices[i]
    
                t_vertex[1],t_vertex[2],t_vertex[3]=rotate_point(vertex[1],vertex[2],vertex[3])
    
            end
    
    
        end
    end
    
    function generate_matrix_transform(xa,ya,za)
    
    
        local sx=sin(xa)
        local sy=sin(ya)
        local sz=sin(za)
        local cx=cos(xa)
        local cy=cos(ya)
        local cz=cos(za)
    
        mat00=cz*cy
        mat10=-sz
        mat20=cz*sy
        mat01=cx*sz*cy+sx*sy
        mat11=cx*cz
        mat21=cx*sz*sy-sx*cy
        mat02=sx*sz*cy-cx*sy
        mat12=sx*cz
        mat22=sx*sz*sy+cx*cy
    
    end
    
    function generate_cam_matrix_transform(xa,ya,za)
    
    
        local sx=sin(xa)
        local sy=sin(ya)
        local sz=sin(za)
        local cx=cos(xa)
        local cy=cos(ya)
        local cz=cos(za)
    
        cam_mat00=cz*cy
        cam_mat10=-sz
        cam_mat20=cz*sy
        cam_mat01=cx*sz*cy+sx*sy
        cam_mat11=cx*cz
        cam_mat21=cx*sz*sy-sx*cy
        cam_mat02=sx*sz*cy-cx*sy
        cam_mat12=sx*cz
        cam_mat22=sx*sz*sy+cx*cy
    
    end
    
    function    matrix_inverse()
        local det = mat00* (mat11 * mat22- mat21 * mat12) -
                    mat01* (mat10 * mat22- mat12 * mat20) +
                    mat02* (mat10 * mat21- mat11 * mat20)
        local invdet=2/det
    
    
    
            mat00,mat01,mat02,mat10,mat11,mat12,mat20,mat21,mat22=(mat11 * mat22 - mat21 * mat12) * invdet,(mat02 * mat21 - mat01 * mat22) * invdet,(mat01 * mat12 - mat02 * mat11) * invdet,(mat12 * mat20 - mat10 * mat22) * invdet,(mat00 * mat22 - mat02 * mat20) * invdet,(mat10 * mat02 - mat00 * mat12) * invdet,(mat10 * mat21 - mat20 * mat11) * invdet,(mat20 * mat01 - mat00 * mat21) * invdet,(mat00 * mat11 - mat10 * mat01) * invdet
    
            --uh yeah I looked this one up :-)
    end
    
    function rotate_point(x,y,z)
        return (x)*mat00+(y)*mat10+(z)*mat20,(x)*mat01+(y)*mat11+(z)*mat21,(x)*mat02+(y)*mat12+(z)*mat22
    end
    
    function rotate_cam_point(x,y,z)
        return (x)*cam_mat00+(y)*cam_mat10+(z)*cam_mat20,(x)*cam_mat01+(y)*cam_mat11+(z)*cam_mat21,(x)*cam_mat02+(y)*cam_mat12+(z)*cam_mat22
    end
    
    function is_visible(object)
    
        if(object.tz+object.radius>z_max and object.tz-object.radius<z_clip and
           object.sx+object.sradius>0 and object.sx-object.sradius<128 and
           object.sy+object.sradius>0 and object.sy-object.sradius<128 )
           then return true else return false end
    end
    
    function    cross_product_2d(p0x,p0y,p1x,p1y,p2x,p2y)
        return ( ( (p0x-p1x)*(p2y-p1y)-(p0y-p1y)*(p2x-p1x)) > 0 )
    end
    
    function render_object(object)
    
        --project all points in object to screen space
        --it's faster to go through the array linearly than to use a for all()
        for i=1, #object.t_vertices do
            local vertex=object.t_vertices[i]
            vertex[4],vertex[5] = vertex[1]*k_screen_scale/vertex[3]+k_x_center,vertex[2]*k_screen_scale/vertex[3]+k_x_center
        end
    
        for i=1,#object.faces do
        --for face in all(object.faces) do
            local face=object.faces[i]
    
            local p1=object.t_vertices[face[1]]
            local p2=object.t_vertices[face[2]]
            local p3=object.t_vertices[face[3]]
    
            local p1x,p1y,p1z=p1[1],p1[2],p1[3]
            local p2x,p2y,p2z=p2[1],p2[2],p2[3]
            local p3x,p3y,p3z=p3[1],p3[2],p3[3]
    
    
            local cz=.01*(p1z+p2z+p3z)/3
            local cx=.01*(p1x+p2x+p3x)/3
            local cy=.01*(p1y+p2y+p3y)/3
            local z_paint= -cx*cx-cy*cy-cz*cz
    
    
    
    
            if(object.background==true) z_paint-=1000
            face[6]=z_paint
    
    
            if((p1z>z_max or p2z>z_max or p3z>z_max))then
                if(p1z< z_clip and p2z< z_clip and p3z< z_clip)then
                --simple option -- no clipping required
    
                        local s1x,s1y = p1[4],p1[5]
                        local s2x,s2y = p2[4],p2[5]
                        local s3x,s3y = p3[4],p3[5]
    
    
                        if( max(s3x,max(s1x,s2x))>0 and min(s3x,min(s1x,s2x))<128)  then
                            --only use backface culling on simple option without clipping
                            --check if triangles are backwards by cross of two vectors
                            if(( (s1x-s2x)*(s3y-s2y)-(s1y-s2y)*(s3x-s2x)) < 0)then
    
                                if(object.color_mode==k_colorize_dynamic)then
                                    --nx,ny,nz = vector_cross_3d(p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z)
                                    --save a bit on dynamic rendering by moving this funciton inline
                                    p2x-=p1x p2y-=p1y p2z-=p1z
                                    p3x-=p1x p3y-=p1y p3z-=p1z
                                    local nx = p2y*p3z-p2z*p3y
                                    local ny = p2z*p3x-p2x*p3z
                                    local nz = p2x*p3y-p2y*p3x
    
                                    --nx,ny,nz = normalize(nx,ny,nz)
                                    --save a bit by moving this function inline
                                    nx=shl(nx,2) ny=shl(ny,2) nz=shl(nz,2)
                                    local inv_dist=1/sqrt(nx*nx+ny*ny+nz*nz)
                                    nx*=inv_dist ny*=inv_dist nz*=inv_dist
    
    
                                    --b = vector_dot_3d(nx,ny,nz,t_light_x,t_light_y,t_light_z)
                                    --save a bit by moving this function inline
                                    face[4],face[5]=color_shade(object.color, mid( nx*t_light_x+ny*t_light_y+nz*t_light_z,0,1)*(1-k_ambient)+k_ambient )
                                end
    
    
                                --new_triangle(s1x,s1y,s2x,s2y,s3x,s3y,z_paint,face[k_color1],face[k_color2])
                                --faster to move new triangle function inline
                                add(triangle_list,{p1x=s1x,
                                                    p1y=s1y,
                                                    p2x=s2x,
                                                    p2y=s2y,
                                                    p3x=s3x,
                                                    p3y=s3y,
                                                    tz=z_paint,
                                                    c1=face[k_color1],
                                                    c2=face[k_color2]})
    
    
                            end
                        end
    
                --not optimizing clipping functions for now
                --these still have errors for large triangles
                elseif(p1z< z_clip or p2z< z_clip or p3z< z_clip)then
    
                --either going to have 3 or 4 points
                    p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z = three_point_sort(p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z)
                    if(p1z<z_clip and p2z<z_clip)then
    
    
    
                        local n2x,n2y,n2z = z_clip_line(p2x,p2y,p2z,p3x,p3y,p3z,z_clip)
                        local n3x,n3y,n3z = z_clip_line(p3x,p3y,p3z,p1x,p1y,p1z,z_clip)
    
    
    
                        local s1x,s1y = project_point(p1x,p1y,p1z)
                        local s2x,s2y = project_point(p2x,p2y,p2z)
                        local s3x,s3y = project_point(n2x,n2y,n2z)
                        local s4x,s4y = project_point(n3x,n3y,n3z)
    
    
                        if( max(s4x,max(s1x,s2x))>0 and min(s4x,min(s1x,s2x))<128)  then
                            new_triangle(s1x,s1y,s2x,s2y,s4x,s4y,z_paint,face[k_color1],face[k_color2])
                        end
                        if( max(s4x,max(s3x,s2x))>0 and min(s4x,min(s3x,s2x))<128)  then
                            new_triangle(s2x,s2y,s4x,s4y,s3x,s3y,z_paint,face[k_color1],face[k_color2])
                        end
                    else
    
    
                        local n1x,n1y,n1z = z_clip_line(p1x,p1y,p1z,p2x,p2y,p2z,z_clip)
                        local n2x,n2y,n2z = z_clip_line(p1x,p1y,p1z,p3x,p3y,p3z,z_clip)
    
    
    
                        local s1x,s1y = project_point(p1x,p1y,p1z)
                        local s2x,s2y = project_point(n1x,n1y,n1z)
                        local s3x,s3y = project_point(n2x,n2y,n2z)
    
                        --solid_trifill(s1x,s1y,s2x,s2y,s3x,s3y,face[k_color1])
                        if( max(s3x,max(s1x,s2x))>0 and min(s3x,min(s1x,s2x))<128)  then
                            new_triangle(s1x,s1y,s2x,s2y,s3x,s3y,z_paint,face[k_color1],face[k_color2])
                        end
                    end
    
                    --print("p1",p1x+64,p1z+64,14)
                    --print("p2",p2x+64,p2z+64,14)
                    --print("p3",p3x+64,p3z+64,14)
    
    
    
                end
            end
    
        end
    
    
    end
    
    function three_point_sort(p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z)
        if(p1z>p2z) p1z,p2z = p2z,p1z p1x,p2x = p2x,p1x p1y,p2y = p2y,p1y
        if(p1z>p3z) p1z,p3z = p3z,p1z p1x,p3x = p3x,p1x p1y,p3y = p3y,p1y
        if(p2z>p3z) p2z,p3z = p3z,p2z p2x,p3x = p3x,p2x p2y,p3y = p3y,p2y
    
        return p1x,p1y,p1z,p2x,p2y,p2z,p3x,p3y,p3z
    end
    
    function quicksort(t, start, endi)
       start, endi = start or 1, endi or #t
      --partition w.r.t. first element
      if(endi - start < 1) then return t end
      local pivot = start
      for i = start + 1, endi do
        if t[i].tz <= t[pivot].tz then
          if i == pivot + 1 then
            t[pivot],t[pivot+1] = t[pivot+1],t[pivot]
          else
            t[pivot],t[pivot+1],t[i] = t[i],t[pivot],t[pivot+1]
          end
          pivot = pivot + 1
        end
      end
       t = quicksort(t, start, pivot - 1)
      return quicksort(t, pivot + 1, endi)
    end
    
    
    
    function z_clip_line(p1x,p1y,p1z,p2x,p2y,p2z,clip)
        if(p1z>p2z)then
            p1x,p2x=p2x,p1x
            p1z,p2z=p2z,p1z
            p1y,p2y=p2y,p1y
        end
    
        if(clip>p1z and clip<=p2z)then
    
        --  line(p1x+64,p1z+64,p2x+64,p2z+64,14)
            alpha= abs((p1z-clip)/(p2z-p1z))
            nx=lerp(p1x,p2x,alpha)
            ny=lerp(p1y,p2y,alpha)
            nz=lerp(p1z,p2z,alpha)
    
        --  circ(nx+64,nz+64,1,12)
            return nx,ny,nz
        else
            return false
        end
    end
    
    function project_point(x,y,z)
        return x*k_screen_scale/z+k_x_center,y*k_screen_scale/z+k_x_center
    end
    
    function project_radius(r,z)
        return r*k_screen_scale/abs(z)
    end
    
    
    
    function lerp(a,b,alpha)
      return a*(1.0-alpha)+b*alpha
    end
    
    function init_player()
        player=new_object()
        player.min_x=-4.5
        player.min_y=-4.5
        player.min_z=-4.5
        player.max_x=4.5
        player.max_y=4.5
        player.max_z=4.5
    
        player.x=0
        player.y=8
        player.z=15
    
        player.vx=0
        player.vy=0
        player.vz=0
    end
    
    k_friction=.7
    function update_camera()
        cam_x=player.x
        cam_y=player.y
        cam_z=player.z
    
        cam_ax=player.ax
        cam_ay=player.ay
        cam_az=player.az
    
        generate_cam_matrix_transform(cam_ax,cam_ay,cam_az)
    end
    
    function init_3d()
        init_player()
        init_light()
        object_list={}
        obstacle_list={}
    end
    
    function update_3d()
        for object in all(object_list) do
                update_visible(object)
                transform_object(object)
                cam_transform_object(object)
                update_light()
        end
    end
    
    function draw_3d()
        triangle_list={}
        quicksort(object_list)
    
        start_timer()
        for object in all(object_list) do
    
            if(object.visible and not object.background) then
                render_object(object) --sort_faces(object)
                --if(object.color_mode==k_colorize_dynamic or object.color_mode==k_multi_color_dynamic) color_faces(object,object.color)
            end
        end
        render_time=stop_timer()
    
        start_timer()
            quicksort(triangle_list)
        sort_time=stop_timer()
    
        start_timer()
            draw_triangle_list()
        triangle_time=stop_timer()
    end
    
    
    function shade_trifill( x1,y1,x2,y2,x3,y3, color1, color2)
    
              local x1=band(x1,0xffff)
              local x2=band(x2,0xffff)
              local y1=band(y1,0xffff)
              local y2=band(y2,0xffff)
              local x3=band(x3,0xffff)
              local y3=band(y3,0xffff)
    
              local nsx,nex
              --sort y1,y2,y3
              if(y1>y2)then
                y1,y2=y2,y1
                x1,x2=x2,x1
              end
    
              if(y1>y3)then
                y1,y3=y3,y1
                x1,x3=x3,x1
              end
    
              if(y2>y3)then
                y2,y3=y3,y2
                x2,x3=x3,x2
              end
    
             if(y1!=y2)then
                local delta_sx=(x3-x1)/(y3-y1)
                local delta_ex=(x2-x1)/(y2-y1)
    
                if(y1>0)then
                    nsx=x1
                    nex=x1
                    min_y=y1
                else --top edge clip
                    nsx=x1-delta_sx*y1
                    nex=x1-delta_ex*y1
                    min_y=0
                end
    
                max_y=min(y2,128)
    
                for y=min_y,max_y-1 do
    
                --rectfill(nsx,y,nex,y,color1)
                if(band(y,1)==0)then rectfill(nsx,y,nex,y,color1) else rectfill(nsx,y,nex,y,color2) end
                nsx+=delta_sx
                nex+=delta_ex
                end
    
            else --where top edge is horizontal
                nsx=x1
                nex=x2
            end
    
    
            if(y3!=y2)then
                local delta_sx=(x3-x1)/(y3-y1)
                local delta_ex=(x3-x2)/(y3-y2)
    
                min_y=y2
                max_y=min(y3,128)
                if(y2<0)then
                    nex=x2-delta_ex*y2
                    nsx=x1-delta_sx*y1
                    min_y=0
                end
    
                 for y=min_y,max_y do
    
                    --rectfill(nsx,y,nex,y,color1)
                    if(band(y,1)==0)then rectfill(nsx,y,nex,y,color1) else rectfill(nsx,y,nex,y,color2) end
                    nex+=delta_ex
                    nsx+=delta_sx
                 end
    
            else --where bottom edge is horizontal
                --rectfill(nsx,y3,nex,y3,color1)
                if(band(y,1)==0)then rectfill(nsx,y3,nex,y3,color1) else rectfill(nsx,y3,nex,y3,color2) end
            end
    
    end
    
    function start_timer()
        timer_value=stat(1)
    end
    
    function stop_timer()
        return stat(1)-timer_value
    end
    
    function camera()
        return player
    end
    
    return {
       init_player = init_player,
       update_player = update_player,
       update_camera = update_camera,
       handle_buttons = handle_buttons,
       init_3d = init_3d,
       update_3d = update_3d,
       draw_3d = draw_3d,
       read_vector_string = read_vector_string,
       read_face_string = read_face_string,
       load_object = load_object,
       matrix_inverse = matrix_inverse,
       camera_matrix_transform = camera_matrix_transform,
       rotate_point = rotate_point,
       camera = camera,
       project_point = project_point,
       intersect_bounding_box = intersect_bounding_box,
       delete_object = delete_object
    }
  end;
  ['ship'] = function()
    local Model
    Model = require("model").Model
    engine = require("engine")
    require("pico")
    local Ship
    do
      local _class_0
      local _parent_0 = Model
      local _base_0 = { }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      _class_0 = setmetatable({
        __init = function(self, color)
          if color == nil then
            color = 13
          end
          self.color = color
          _class_0.__parent.__init(self, "019a00eeffd2017e00ae004d019f0197fff201b80178009dffa9007e005affac0076009dffb8017f00c2007e04aa0201ff6200a8fed6ff71012fff33ff930023007cffa200c600bc015b0140fed601470185feae019000a10033027bfef40650ff59009ffee3ff7f0134ff00ffd30006fde0fff600a1fd9400f3013e003001060193000601be007efe7f03bcfe26f8e0ff5a0105fec8ff9b0126ff41ff4d0195fe6fff6301f3ff02016600defef201720112ff43015801ddfe95009b050dfd8e010e019efe9c01520117fec3ffcb01b9fe9dffb90113fe99012101b50056018000c400d0ffbf01180095f95cfffaff6d", "010304040307070506050102070301040806090b0c0b0f100f0d0e0d090a0f0b090c100e1113141317181715161511121713111418161a191b1c1b1f1f1d1e1d191a1b191d1c201e212324242327272526252122232125242826010402040708070608050206070105040602090c0a0b100c0f0e100d0a0e0f090d0c0e0a1114121318141716181512161711151416121a1b1c1c1f201f1e201d1a1e1b1d1f1c1e1a212422242728272628252226232527242622", self.color)
          self.model.ay = 1.75
        end,
        __base = _base_0,
        __name = "Ship",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            local parent = rawget(cls, "__parent")
            if parent then
              return parent[name]
            end
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Ship = _class_0
    end
    return {
      Ship = Ship
    }
  end;
  ['player'] = function()
    local Ship
    Ship = require("ship").Ship
    engine = require("engine")
    require("pico")
    local Player
    do
      local _class_0
      local _parent_0 = Ship
      local _base_0 = {
        calc_direction = function(self)
          self.x = -(self.front - self.model.ay)
          self.y = self.mid - self.model.ax
          if (self.y > 0) then
            self.y = self.y * 4
          end
        end,
        update = function(self, dt)
          self.projection = { }
          self.projection.x, self.projection.y = engine.project_point(self.model.tx, self.model.ty, self.model.tz)
          self:calc_direction()
          local speed = .004
          if (btn(pico.left)) then
            self:inc_children("ay", -speed)
            local bound = .1703
            if (self.model.ay < bound) then
              self:set_children("ay", bound)
            end
          end
          if (btn(pico.right)) then
            self.model.ay = self.model.ay + speed
            self:inc_children("ay", speed)
            local bound = .3296
            if (self.model.ay > bound) then
              self:set_children("ay", bound)
            end
          end
          local scale = 1.2
          if (btn(pico.down)) then
            self:inc_children("ax", -speed * scale)
            local bound = -.0979
            if (self.model.ax < bound) then
              self:set_children("ax", bound)
            end
          end
          if (btn(pico.up)) then
            self:inc_children("ax", speed * scale)
            local bound = .0907
            if (self.model.ax > bound) then
              self:set_children("ax", bound)
            end
          end
          self:inc_children("x", self.x)
          self:inc_children("y", self.y)
          local upper_bound = 13.5237
          local lower_bound = -1.7895
          if (self.model.y > upper_bound) then
            self:set_children("y", upper_bound)
          end
          if (self.model.y < lower_bound) then
            self:set_children("y", lower_bound)
          end
          upper_bound = 4
          lower_bound = -4.3033
          if (self.model.x > upper_bound) then
            self:set_children("x", upper_bound)
          end
          if (self.model.x < lower_bound) then
            return self:set_children("x", lower_bound)
          end
        end,
        inc_children = function(self, key, increment)
          for _, child in pairs(self.children) do
            child:inc(key, increment)
          end
        end,
        set_children = function(self, key, value)
          for _, child in pairs(self.children) do
            local offset = 0
            if (self.defaults[key]) then
              offset = -self.defaults[key]
            end
            child:set(key, value + offset)
          end
        end,
        render = function(self, dt)
          if (pico.is_held(pico.x_key)) then
            return self:draw_holo()
          end
        end,
        draw_holo = function(self, x)
          if x == nil then
            x = -5
          end
          pico.draw_sprite(40, self.projection.x + x, self.projection.y, 1, 1)
          pico.draw_sprite(40, self.projection.x + x, self.projection.y + 8, 1, 1)
          return pico.draw_sprite(40, self.projection.x + x, self.projection.y + 16, 1, 1)
        end,
        direction_x = function(self)
          return self.x
        end,
        direction_y = function(self)
          return self.y
        end
      }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      _class_0 = setmetatable({
        __init = function(self)
          _class_0.__parent.__init(self)
          self.front = .2498
          self.mid = -.07
          self.model.y = 5
          self.model.ax = self.mid
          self.model.ay = self.front
          self.children = {
            self
          }
          self:set_defaults()
          self.projection = {
            x = 0,
            y = 0
          }
        end,
        __base = _base_0,
        __name = "Player",
        __parent = _parent_0
      }, {
        __index = function(cls, name)
          local val = rawget(_base_0, name)
          if val == nil then
            local parent = rawget(cls, "__parent")
            if parent then
              return parent[name]
            end
          else
            return val
          end
        end,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      if _parent_0.__inherited then
        _parent_0.__inherited(_parent_0, _class_0)
      end
      Player = _class_0
    end
    return {
      Player = Player
    }
  end;
  ['main'] = function()
    __setmetatable = setmetatable
    __metatables = { }
    tostring = function(any)
      if type(any) == "function" then
        return "function"
      end
      if any == nil then
        return "nil"
      end
      if type(any) == "string" then
        return any
      end
      if type(any) == "boolean" then
        if any then
          return "true"
        end
        return "false"
      end
      if type(any) == "table" then
        local str = "{ "
        for k, v in pairs(any) do
          str = str .. tostring(k) .. "->" .. tostring(v) .. " "
        end
        return str .. "}"
      end
      if type(any) == "number" then
        return "" .. any
      end
      return "unkown"
    end
    setmetatable = function(object, mt)
      __metatables[object] = mt
      return __setmetatable(object, mt)
    end
    getmetatable = function(object)
      return __metatables[object]
    end
    rawget = function(tbl, index)
      assert(type(tbl) == 'table', "bad argument #1 to 'rawget' " .. "(table expected, got " .. type(tbl) .. ")")
      local ti = tbl.__index
      local mt = getmetatable(tbl)
      local value = nil
      tbl.__index = tbl
      __setmetatable(tbl, nil)
      value = tbl[index]
      tbl.__index = ti
      __setmetatable(tbl, mt)
      return value
    end
    local Stack
    Stack = require("stack").Stack
    local Play
    Play = require("play").Play
    local Menu
    Menu = require("menu").Menu
    pico = require("pico")
    _update60 = function()
      pico.update_keys()
      return game_states:update(pico.step)
    end
    _draw = function()
      return game_states:render(pico.step)
    end
    pico.reset_pallet()
    pico.init_keys()
    game_states = Stack()
    game_states:push(Play(game_states))
    game_states:push(Menu(game_states))
    return game_states:create()
  end;
})
_init = function()
  __setmetatable = setmetatable
  __metatables = { }
  tostring = function(any)
    if type(any) == "function" then
      return "function"
    end
    if any == nil then
      return "nil"
    end
    if type(any) == "string" then
      return any
    end
    if type(any) == "boolean" then
      if any then
        return "true"
      end
      return "false"
    end
    if type(any) == "table" then
      local str = "{ "
      for k, v in pairs(any) do
        str = str .. tostring(k) .. "->" .. tostring(v) .. " "
      end
      return str .. "}"
    end
    if type(any) == "number" then
      return "" .. any
    end
    return "unkown"
  end
  setmetatable = function(object, mt)
    __metatables[object] = mt
    return __setmetatable(object, mt)
  end
  getmetatable = function(object)
    return __metatables[object]
  end
  rawget = function(tbl, index)
    assert(type(tbl) == 'table', "bad argument #1 to 'rawget' " .. "(table expected, got " .. type(tbl) .. ")")
    local ti = tbl.__index
    local mt = getmetatable(tbl)
    local value = nil
    tbl.__index = tbl
    __setmetatable(tbl, nil)
    value = tbl[index]
    tbl.__index = ti
    __setmetatable(tbl, mt)
    return value
  end
  local Stack
  Stack = require("stack").Stack
  local Play
  Play = require("play").Play
  local Menu
  Menu = require("menu").Menu
  pico = require("pico")
  _update60 = function()
    pico.update_keys()
    return game_states:update(pico.step)
  end
  _draw = function()
    return game_states:render(pico.step)
  end
  pico.reset_pallet()
  pico.init_keys()
  game_states = Stack()
  game_states:push(Play(game_states))
  game_states:push(Menu(game_states))
  return game_states:create()
end
__gfx__
0000000077777777777777777777777777777777f0f00f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007000000000000000000000000000000780900d0e00000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070070888888888888888888888888888807c010050400000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000708888888888888888888888888888070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000708888888888888888888888888888070050040000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700708888888888888888888888888888070020070000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007000000000000000000000000000000700c0010000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003333331100000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000bbbb333100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003333331100000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000bbbb333100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003333331100000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000bbbb333100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003333331100000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000bbbb333100000000000000000000000000000000000000000000000000000000
__map__
0005050505050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005050505050505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005050505050506060500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005050506060606060505050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005050006060605060505050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000050506060506050505050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000050505050606050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200000c550065500a5500a550055500a550045500455005550065501a5001a50019500195001a5001a5001b5001c5001a500140000100015500185001f5000e5001a5001b5001a5001a5001a5001b50000000
0002000005550075500755000000075501b5501c5501b550175501655015550155501655017550096500d65011650156501965022650286502c6502e650306503065004550055500655008550075500755007550
