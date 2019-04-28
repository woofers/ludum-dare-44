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
      mod = mod
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
          if not (self:is_empty()) then
            self.stack[#self.stack]:destroy()
          end
          self.stack[#self.stack + 1] = item
          return self:create()
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
    local Sprite
    do
      local _class_0
      local _base_0 = { }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, x, y, width, height)
          if x == nil then
            x = 0
          end
          if y == nil then
            y = 0
          end
          self.x, self.y, self.width, self.height = x, y, width, height
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
          _class_0.__parent.__init(self, self.x, self.y, radius, radius)
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
        destroy = function(self)
          return engine.delete_object(self.model)
        end,
        set = function(self, key, value)
          self.model[key] = value
        end,
        inc = function(self, key, value)
          self.model[key] = self.model[key] + value
        end,
        hide = function(self)
          if (not self.hidden) then
            self.model.z = self.model.z - 1000
          end
          self.hidden = true
        end,
        show = function(self)
          if (self.hidden) then
            self.model.z = self.model.z + 1000
          end
          self.hidden = false
        end,
        toggle = function(self)
          if (self.hidden) then
            return self:show()
          else
            return self:hide()
          end
        end,
        update = function(self, dt)
          self.projection.x, self.projection.y = engine.project_point(self.model.tx, self.model.ty, self.model.tz)
        end
      }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, v, f, color)
          self.color = color
          self.v = engine.read_vector_string(v)
          self.f = engine.read_face_string(f)
          self.model = engine.load_object(self.v, self.f, 0, 0, 0, 0, -.35, 0, false, k_colorize_dynamic, self.color)
          self.projection = {
            x = 0,
            y = 0
          }
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
    local Play
    Play = require("play").Play
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
          if (self.ship) then
            return self.ship:destroy()
          end
        end,
        update = function(self, dt)
          if (btn(pico.x_key)) then
            self.game_over = true
            self.game_states:push(Play(self.game_states))
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
          self.stars:render(dt)
          engine.draw_3d()
          local text
          if self.game_over then
            text = "you, D I E D ."
          else
            text = "alien, E X P A N S I O N ."
          end
          self:font(text, 17, 105)
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
          self.game_over = false
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
          self.health = 1
          self.ship = Player(self)
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
          self.score = 0
          self.ships = { }
          for i = 1, 2 do
            self:new_ship(i)
          end
          self.stars = Stars()
        end,
        new_ship = function(self, i, score)
          if score == nil then
            score = 10
          end
          if (self.ships[i]) then
            self.score = self.score + score
            self.ships[i]:destroy()
            self.ships[i] = nil
          end
          self.ships[i] = Ship(self.ship_colors[pico.random(1, #self.ship_colors)])
          self.ships[i].model.x = pico.random(-10, 10)
          self.ships[i].model.y = pico.random(-10, 10)
          self.ships[i].model.z = pico.random(-35, -30)
        end,
        destroy = function(self)
          self.ship:destroy()
          for i = 1, 2 do
            self.ships[i]:destroy()
          end
        end,
        update = function(self, dt)
          for key, ship in pairs(self.ships) do
            ship:update(dt)
            ship.model.z = ship.model.z + 0.1
            if (engine.intersect_bounding_box(self.ship.model, ship.model)) then
              self.health = self.health - 0.0035
              self.ship:start_blink()
            end
            if (ship.model.z > 10) then
              self:new_ship(key)
            end
            if (self.ship.is_shooting) then
              if (self.ship.shoot_location.x - self.ship.shoot_radius < ship.projection.x) then
                if (ship.projection.x < self.ship.shoot_radius + self.ship.shoot_location.x) then
                  self:new_ship(key, 40)
                  self.health = self.health + 0.05
                  sfx(4)
                  if (self.health > 1) then
                    self.health = 1
                  end
                end
              end
              if (self.ship.shoot_location.y - self.ship.shoot_radius < ship.projection.y) then
                if (ship.projection.y < self.ship.shoot_radius + self.ship.shoot_location.y) then
                  self:new_ship(key, 40)
                  self.health = self.health + 0.05
                  sfx(4)
                  if (self.health > 1) then
                    self.health = 1
                  end
                end
              end
            end
          end
          self.stars:update(dt)
          self.ship:update(dt)
          self.stars:set_direction(self.ship:direction_x(), self.ship:direction_y())
          self:check_dead()
          engine.update_camera()
          return engine.update_3d()
        end,
        render = function(self, dt)
          self.stars:render(dt)
          self.ship:render(dt)
          engine.draw_3d()
          self:draw_life()
          return self:draw_abduct()
        end,
        check_dead = function(self)
          if (self.health <= 0) then
            return self.game_states:pop()
          end
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
          return print(tostring(self.score), x + 2, y, 7)
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
    hex_string_data="0123456789abcdef"char_to_hex={}for a=1,#hex_string_data do char_to_hex[sub(hex_string_data,a,a)]=a-1 end;function read_byte(b)return char_to_hex[sub(b,1,1)]*16+char_to_hex[sub(b,2,2)]end;function read_2byte_fixed(b)local c=read_byte(sub(b,1,2))local d=read_byte(sub(b,3,4))local e=c*256+d;return e/256 end;cur_string=""cur_string_index=1;function load_string(b)cur_string=b;cur_string_index=1 end;function read_vector()v={}for a=1,3 do text=sub(cur_string,cur_string_index,cur_string_index+4)value=read_2byte_fixed(text)v[a]=value;cur_string_index=cur_string_index+4 end;return v end;function read_face()f={}for a=1,3 do text=sub(cur_string,cur_string_index,cur_string_index+2)value=read_byte(text)f[a]=value;cur_string_index=cur_string_index+2 end;return f end;function read_vector_string(b)vector_list={}load_string(b)while cur_string_index<#b do vector=read_vector()add(vector_list,vector)end;return vector_list end;function read_face_string(b)face_list={}load_string(b)while cur_string_index<#b do face=read_face()add(face_list,face)end;return face_list end;k_color1=4;k_color2=5;k_screen_scale=80;k_x_center=64;k_y_center=64;z_clip=-3;z_max=-50;k_min_x=0;k_max_x=128;k_min_y=0;k_max_y=128;double_color_list={{0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0},{0,0,1,1,1,1,13,13,12,12},{0,0,0,1,1,1,1,13,13,12},{2,2,2,2,8,8,14,14,14,15},{0,1,1,2,2,8,8,8,14,14},{1,1,1,1,3,3,11,11,10,10},{0,1,1,1,1,3,3,11,11,10},{1,1,2,2,4,4,9,9,10,10},{0,1,1,2,2,4,4,9,9,10},{0,0,1,1,5,5,13,13,6,6},{0,0,0,1,1,5,5,13,13,6},{1,1,5,5,6,6,6,6,7,7},{0,1,1,5,5,6,6,6,6,7},{5,5,6,6,7,7,7,7,7,7},{0,5,5,6,6,7,7,7,7,7},{2,2,2,2,8,8,14,14,15,15},{0,2,2,2,2,8,8,14,14,15},{2,2,4,4,9,9,15,15,7,7},{0,2,2,4,4,9,9,15,15,7},{4,4,9,9,10,10,7,7,7,7},{0,4,4,9,9,10,10,7,7,7},{1,1,3,3,11,11,10,10,7,7},{0,1,1,3,3,11,11,10,10,7},{13,13,13,12,12,12,6,6,7,7},{0,5,13,13,12,12,12,6,6,7},{1,1,5,5,13,13,6,6,7,7},{0,1,1,5,5,13,13,6,6,7},{2,2,2,2,14,14,15,15,7,7},{0,2,2,2,2,14,14,15,15,7},{4,4,9,9,15,15,7,7,7,7},{0,4,4,9,9,15,15,7,7,7}}k_ambient=.3;function color_faces(object,g)for a=1,#object.faces do local face=object.faces[a]local h=object.t_vertices[face[1]][1]local i=object.t_vertices[face[1]][2]local j=object.t_vertices[face[1]][3]local k=object.t_vertices[face[2]][1]local l=object.t_vertices[face[2]][2]local m=object.t_vertices[face[2]][3]local n=object.t_vertices[face[3]][1]local o=object.t_vertices[face[3]][2]local p=object.t_vertices[face[3]][3]local nx,ny,nz=vector_cross_3d(h,i,j,k,l,m,n,o,p)nx,ny,nz=normalize(nx,ny,nz)local d=vector_dot_3d(nx,ny,nz,light1_x,light1_y,light1_z)if object.color_mode==k_multi_color_dynamic then face[4],face[5]=color_shade(object.base_faces[a][4],mid(d,0,1)*(1-k_ambient)+k_ambient)else face[4],face[5]=color_shade(g,mid(d,0,1)*(1-k_ambient)+k_ambient)end end end;function color_shade(q,r)local d=band(r*10,0xffff)local s=(q+1)*2;return double_color_list[s-1][d],double_color_list[s][d]end;light1_x=.1;light1_y=.35;light1_z=.2;t_light_x=0;t_light_y=0;t_light_z=0;function init_light()light1_x,light1_y,light1_z=normalize(light1_x,light1_y,light1_z)end;function update_light()t_light_x,t_light_y,t_light_z=rotate_cam_point(light1_x,light1_y,light1_z)end;function normalize(t,y,u)local w=shl(t,2)local x=shl(y,2)local z=shl(u,2)local A=1/sqrt(w*w+x*x+z*z)return w*A,x*A,z*A end;function vector_dot_3d(B,C,D,E,F,G)return B*E+C*F+D*G end;function vector_cross_3d(H,I,J,B,C,D,E,F,G)B=B-H;C=C-I;D=D-J;E=E-H;F=F-I;G=G-J;local K=C*G-D*F;local L=D*E-B*G;local M=B*F-C*E;return K,L,M end;k_colorize_static=1;k_colorize_dynamic=2;k_multi_color_static=3;k_multi_color_dynamic=4;k_preset_color=5;function load_object(N,O,t,y,u,B,C,D,P,Q,q)object=new_object()object.vertices=N;if Q==k_preset_color then object.faces=O else object.base_faces=O;object.faces={}for a=1,#O do object.faces[a]={}for R=1,#O[a]do object.faces[a][R]=O[a][R]end end end;object.radius=0;for a=1,#N do object.t_vertices[a]={}for R=1,3 do object.t_vertices[a][R]=object.vertices[a][R]end end;object.ax=B or 0;object.ay=C or 0;object.az=D or 0;transform_object(object)set_radius(object)set_bounding_box(object)object.x=t or 0;object.y=y or 0;object.z=u or 0;object.color=q or 8;object.color_mode=Q or k_colorize_static;object.obstacle=P or false;if P then add(obstacle_list,object)end;if Q==k_colorize_static or Q==k_colorize_dynamic or Q==k_multi_color_static then color_faces(object,q)end;return object end;function set_radius(object)for S in all(object.vertices)do object.radius=max(object.radius,S[1]*S[1]+S[2]*S[2]+S[3]*S[3])end;object.radius=sqrt(object.radius)end;function set_bounding_box(object)for S in all(object.t_vertices)do object.min_x=min(S[1],object.min_x)object.min_y=min(S[2],object.min_y)object.min_z=min(S[3],object.min_z)object.max_x=max(S[1],object.max_x)object.max_y=max(S[2],object.max_y)object.max_z=max(S[3],object.max_z)end end;function intersect_bounding_box(T,U)return T.min_x+T.x<U.max_x+U.x and T.max_x+T.x>U.min_x+U.x and T.min_y+T.y<U.max_y+U.y and T.max_y+T.y>U.min_y+U.y and T.min_z+T.z<U.max_z+U.z and T.max_z+T.z>U.min_z+U.z end;function new_object()object={}object.vertices={}object.faces={}object.t_vertices={}object.x=0;object.y=0;object.z=0;object.tx=0;object.ty=0;object.tz=0;object.ax=0;object.ay=0;object.az=0;object.sx=0;object.sy=0;object.radius=10;object.sradius=10;object.visible=true;object.background=false;object.min_x=100;object.min_y=100;object.min_z=100;object.max_x=-100;object.max_y=-100;object.max_z=-100;add(object_list,object)return object end;function delete_object(object)del(object_list,object)end;function new_triangle(h,i,k,l,n,o,u,V,W)add(triangle_list,{p1x=h,p1y=i,p2x=k,p2y=l,p3x=n,p3y=o,tz=u,c1=V,c2=W})end;function draw_triangle_list()for a=1,#triangle_list do local X=triangle_list[a]shade_trifill(X.p1x,X.p1y,X.p2x,X.p2y,X.p3x,X.p3y,X.c1,X.c2)end end;function update_visible(object)object.visible=false;local H,I,J=object.x-cam_x,object.y-cam_y,object.z-cam_z;object.tx,object.ty,object.tz=rotate_cam_point(H,I,J)object.sx,object.sy=project_point(object.tx,object.ty,object.tz)object.sradius=project_radius(object.radius,object.tz)object.visible=is_visible(object)end;function cam_transform_object(object)if object.visible then for a=1,#object.vertices do local S=object.t_vertices[a]S[1]=S[1]+object.x-cam_x;S[2]=S[2]+object.y-cam_y;S[3]=S[3]+object.z-cam_z;S[1],S[2],S[3]=rotate_cam_point(S[1],S[2],S[3])end end end;function transform_object(object)if object.visible then generate_matrix_transform(object.ax,object.ay,object.az)for a=1,#object.vertices do local Y=object.t_vertices[a]local S=object.vertices[a]Y[1],Y[2],Y[3]=rotate_point(S[1],S[2],S[3])end end end;function generate_matrix_transform(Z,_,a0)local a1=sin(Z)local a2=sin(_)local a3=sin(a0)local a4=cos(Z)local a5=cos(_)local a6=cos(a0)mat00=a6*a5;mat10=-a3;mat20=a6*a2;mat01=a4*a3*a5+a1*a2;mat11=a4*a6;mat21=a4*a3*a2-a1*a5;mat02=a1*a3*a5-a4*a2;mat12=a1*a6;mat22=a1*a3*a2+a4*a5 end;function generate_cam_matrix_transform(Z,_,a0)local a1=sin(Z)local a2=sin(_)local a3=sin(a0)local a4=cos(Z)local a5=cos(_)local a6=cos(a0)cam_mat00=a6*a5;cam_mat10=-a3;cam_mat20=a6*a2;cam_mat01=a4*a3*a5+a1*a2;cam_mat11=a4*a6;cam_mat21=a4*a3*a2-a1*a5;cam_mat02=a1*a3*a5-a4*a2;cam_mat12=a1*a6;cam_mat22=a1*a3*a2+a4*a5 end;function matrix_inverse()local a7=mat00*(mat11*mat22-mat21*mat12)-mat01*(mat10*mat22-mat12*mat20)+mat02*(mat10*mat21-mat11*mat20)local a8=2/a7;mat00,mat01,mat02,mat10,mat11,mat12,mat20,mat21,mat22=(mat11*mat22-mat21*mat12)*a8,(mat02*mat21-mat01*mat22)*a8,(mat01*mat12-mat02*mat11)*a8,(mat12*mat20-mat10*mat22)*a8,(mat00*mat22-mat02*mat20)*a8,(mat10*mat02-mat00*mat12)*a8,(mat10*mat21-mat20*mat11)*a8,(mat20*mat01-mat00*mat21)*a8,(mat00*mat11-mat10*mat01)*a8 end;function rotate_point(t,y,u)return t*mat00+y*mat10+u*mat20,t*mat01+y*mat11+u*mat21,t*mat02+y*mat12+u*mat22 end;function rotate_cam_point(t,y,u)return t*cam_mat00+y*cam_mat10+u*cam_mat20,t*cam_mat01+y*cam_mat11+u*cam_mat21,t*cam_mat02+y*cam_mat12+u*cam_mat22 end;function is_visible(object)if object.tz+object.radius>z_max and object.tz-object.radius<z_clip and object.sx+object.sradius>0 and object.sx-object.sradius<128 and object.sy+object.sradius>0 and object.sy-object.sradius<128 then return true else return false end end;function cross_product_2d(a9,aa,h,i,k,l)return(a9-h)*(l-i)-(aa-i)*(k-h)>0 end;function render_object(object)for a=1,#object.t_vertices do local S=object.t_vertices[a]S[4],S[5]=S[1]*k_screen_scale/S[3]+k_x_center,S[2]*k_screen_scale/S[3]+k_x_center end;for a=1,#object.faces do local face=object.faces[a]local ab=object.t_vertices[face[1]]local ac=object.t_vertices[face[2]]local ad=object.t_vertices[face[3]]local h,i,j=ab[1],ab[2],ab[3]local k,l,m=ac[1],ac[2],ac[3]local n,o,p=ad[1],ad[2],ad[3]local a6=.01*(j+m+p)/3;local a4=.01*(h+k+n)/3;local a5=.01*(i+l+o)/3;local ae=-a4*a4-a5*a5-a6*a6;if object.background==true then ae=ae-1000 end;face[6]=ae;if j>z_max or m>z_max or p>z_max then if j<z_clip and m<z_clip and p<z_clip then local af,ag=ab[4],ab[5]local ah,ai=ac[4],ac[5]local aj,ak=ad[4],ad[5]if max(aj,max(af,ah))>0 and min(aj,min(af,ah))<128 then if(af-ah)*(ak-ai)-(ag-ai)*(aj-ah)<0 then if object.color_mode==k_colorize_dynamic then k=k-h;l=l-i;m=m-j;n=n-h;o=o-i;p=p-j;local nx=l*p-m*o;local ny=m*n-k*p;local nz=k*o-l*n;nx=shl(nx,2)ny=shl(ny,2)nz=shl(nz,2)local A=1/sqrt(nx*nx+ny*ny+nz*nz)nx=nx*A;ny=ny*A;nz=nz*A;face[4],face[5]=color_shade(object.color,mid(nx*t_light_x+ny*t_light_y+nz*t_light_z,0,1)*(1-k_ambient)+k_ambient)end;add(triangle_list,{p1x=af,p1y=ag,p2x=ah,p2y=ai,p3x=aj,p3y=ak,tz=ae,c1=face[k_color1],c2=face[k_color2]})end end elseif j<z_clip or m<z_clip or p<z_clip then h,i,j,k,l,m,n,o,p=three_point_sort(h,i,j,k,l,m,n,o,p)if j<z_clip and m<z_clip then local al,am,an=z_clip_line(k,l,m,n,o,p,z_clip)local ao,ap,aq=z_clip_line(n,o,p,h,i,j,z_clip)local af,ag=project_point(h,i,j)local ah,ai=project_point(k,l,m)local aj,ak=project_point(al,am,an)local ar,as=project_point(ao,ap,aq)if max(ar,max(af,ah))>0 and min(ar,min(af,ah))<128 then new_triangle(af,ag,ah,ai,ar,as,ae,face[k_color1],face[k_color2])end;if max(ar,max(aj,ah))>0 and min(ar,min(aj,ah))<128 then new_triangle(ah,ai,ar,as,aj,ak,ae,face[k_color1],face[k_color2])end else local at,au,av=z_clip_line(h,i,j,k,l,m,z_clip)local al,am,an=z_clip_line(h,i,j,n,o,p,z_clip)local af,ag=project_point(h,i,j)local ah,ai=project_point(at,au,av)local aj,ak=project_point(al,am,an)if max(aj,max(af,ah))>0 and min(aj,min(af,ah))<128 then new_triangle(af,ag,ah,ai,aj,ak,ae,face[k_color1],face[k_color2])end end end end end end;function three_point_sort(h,i,j,k,l,m,n,o,p)if j>m then j,m=m,j;h,k=k,h;i,l=l,i end;if j>p then j,p=p,j;h,n=n,h;i,o=o,i end;if m>p then m,p=p,m;k,n=n,k;l,o=o,l end;return h,i,j,k,l,m,n,o,p end;function quicksort(X,aw,ax)aw,ax=aw or 1,ax or#X;if ax-aw<1 then return X end;local ay=aw;for a=aw+1,ax do if X[a].tz<=X[ay].tz then if a==ay+1 then X[ay],X[ay+1]=X[ay+1],X[ay]else X[ay],X[ay+1],X[a]=X[a],X[ay],X[ay+1]end;ay=ay+1 end end;X=quicksort(X,aw,ay-1)return quicksort(X,ay+1,ax)end;function z_clip_line(h,i,j,k,l,m,az)if j>m then h,k=k,h;j,m=m,j;i,l=l,i end;if az>j and az<=m then alpha=abs((j-az)/(m-j))nx=lerp(h,k,alpha)ny=lerp(i,l,alpha)nz=lerp(j,m,alpha)return nx,ny,nz else return false end end;function project_point(t,y,u)return t*k_screen_scale/u+k_x_center,y*k_screen_scale/u+k_x_center end;function project_radius(aA,u)return aA*k_screen_scale/abs(u)end;function lerp(c,d,alpha)return c*(1.0-alpha)+d*alpha end;function init_player()player=new_object()player.min_x=-4.5;player.min_y=-4.5;player.min_z=-4.5;player.max_x=4.5;player.max_y=4.5;player.max_z=4.5;player.x=0;player.y=8;player.z=15 end;k_friction=.7;function update_camera()cam_x=player.x;cam_y=player.y;cam_z=player.z;cam_ax=player.ax;cam_ay=player.ay;cam_az=player.az;generate_cam_matrix_transform(cam_ax,cam_ay,cam_az)end;function init_3d()if is_init then return end;is_init=true;init_player()init_light()object_list={}obstacle_list={}end;function update_3d()for object in all(object_list)do update_visible(object)transform_object(object)cam_transform_object(object)update_light()end end;function draw_3d()triangle_list={}quicksort(object_list)start_timer()for object in all(object_list)do if object.visible and not object.background then render_object(object)end end;render_time=stop_timer()start_timer()quicksort(triangle_list)sort_time=stop_timer()start_timer()draw_triangle_list()triangle_time=stop_timer()end;function shade_trifill(w,x,aB,aC,aD,aE,aF,aG)local w=band(w,0xffff)local aB=band(aB,0xffff)local x=band(x,0xffff)local aC=band(aC,0xffff)local aD=band(aD,0xffff)local aE=band(aE,0xffff)local aH,aI;if x>aC then x,aC=aC,x;w,aB=aB,w end;if x>aE then x,aE=aE,x;w,aD=aD,w end;if aC>aE then aC,aE=aE,aC;aB,aD=aD,aB end;if not(x==aC)then local aJ=(aD-w)/(aE-x)local aK=(aB-w)/(aC-x)if x>0 then aH=w;aI=w;min_y=x else aH=w-aJ*x;aI=w-aK*x;min_y=0 end;max_y=min(aC,128)for y=min_y,max_y-1 do if band(y,1)==0 then rectfill(aH,y,aI,y,aF)else rectfill(aH,y,aI,y,aG)end;aH=aH+aJ;aI=aI+aK end else aH=w;aI=aB end;if not(aE==aC)then local aJ=(aD-w)/(aE-x)local aK=(aD-aB)/(aE-aC)min_y=aC;max_y=min(aE,128)if aC<0 then aI=aB-aK*aC;aH=w-aJ*x;min_y=0 end;for y=min_y,max_y do if band(y,1)==0 then rectfill(aH,y,aI,y,aF)else rectfill(aH,y,aI,y,aG)end;aI=aI+aK;aH=aH+aJ end else if band(y,1)==0 then rectfill(aH,aE,aI,aE,aF)else rectfill(aH,aE,aI,aE,aG)end end end;function start_timer()timer_value=stat(1)end;function stop_timer()return stat(1)-timer_value end;function camera()return player end;function add_value(aL,value)aL=aL+value end;return{init_player=init_player,update_player=update_player,update_camera=update_camera,handle_buttons=handle_buttons,init_3d=init_3d,update_3d=update_3d,draw_3d=draw_3d,read_vector_string=read_vector_string,read_face_string=read_face_string,load_object=load_object,matrix_inverse=matrix_inverse,camera_matrix_transform=camera_matrix_transform,rotate_point=rotate_point,camera=camera,project_point=project_point,intersect_bounding_box=intersect_bounding_box,delete_object=delete_object}
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
      local _base_0 = {
        update = function(self, dt)
          return _class_0.__parent.update(self, dt)
        end
      }
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
          _class_0.__parent.update(self, dt)
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
          self:update_shoot(dt)
          self:update_blink(dt)
          self:inc_children("x", self.x)
          self:inc_children("y", self.y)
          local upper_bound = 16.5237
          local lower_bound = -4.7895
          if (self.model.y > upper_bound) then
            self:set_children("y", upper_bound)
          end
          if (self.model.y < lower_bound) then
            self:set_children("y", lower_bound)
          end
          upper_bound = 7
          lower_bound = -7.3033
          if (self.model.x > upper_bound) then
            self:set_children("x", upper_bound)
          end
          if (self.model.x < lower_bound) then
            return self:set_children("x", lower_bound)
          end
        end,
        inc_children = function(self, key, increment)
          return self:inc(key, increment)
        end,
        set_children = function(self, key, value)
          return self:set(key, value)
        end,
        render = function(self, dt)
          self:render_shoot(dt)
          if (btnp(pico.x_key)) then
            return self:shoot()
          end
        end,
        draw_holo = function(self, x)
          if x == nil then
            x = -5
          end
          if (self.hidden) then
            return 
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
        end,
        start_blink = function(self)
          self.blink = true
        end,
        update_blink = function(self, dt)
          if (self.blink) then
            if (self.blink_count >= 2) then
              if (self.game.score >= 3) then
                self.game.score = self.game.score - 3
              end
              self:show()
              self.blink = false
              self.blink_time = 0
              self.blink_count = 0
              return 
            end
            self.blink_time = self.blink_time + dt
            if (self.blink_time > 0.2) then
              self:toggle()
              sfx(2)
              self.blink_time = 0
              self.blink_count = self.blink_count + 1
            end
          end
        end,
        update_shoot = function(self, dt)
          if (self.is_shooting) then
            self.shoot_radius = self.shoot_radius - (dt * 3)
            if (self.shoot_radius <= 1) then
              self.is_shooting = false
            end
          end
        end,
        render_shoot = function(self, dt)
          if (self.is_shooting) then
            circ(self.shoot_location.x, self.shoot_location.y, self.shoot_radius, 8)
            self.shoot_location.x = self.shoot_location.x - (0.1 * self.shoot_location.direction_x)
            self.shoot_location.y = self.shoot_location.y - (0.1 * self.shoot_location.direction_y)
          end
        end,
        shoot = function(self)
          if (self.is_shooting or self.projection.x == 0) then
            return 
          end
          sfx(5)
          local x, y = self.x * -100, self.y * -80
          if (y < 7.21) then
            y = y * 0.1
          end
          printh(y)
          if (y <= 0) then
            y = y - 20
          else
            y = y + 4
          end
          self.shoot_radius = 5
          self.shoot_time = 0
          self.shoot_location = {
            x = self.projection.x + x,
            y = self.projection.y + y,
            direction_x = self.x,
            direction_y = self.y
          }
          self.is_shooting = true
        end
      }
      _base_0.__index = _base_0
      setmetatable(_base_0, _parent_0.__base)
      _class_0 = setmetatable({
        __init = function(self, game)
          _class_0.__parent.__init(self)
          self.game = game
          self.front = .2498
          self.mid = -.07
          self.model.y = 5
          self.model.z = -5
          self.model.ax = self.mid
          self.model.ay = self.front
          self.blink_time = 0
          self.blink_count = 0
          self.x, self.y = 0, 0
          self.is_shooting = false
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
    local Menu
    Menu = require("menu").Menu
    pico = require("pico")
    _update60 = function()
      return game_states:update(pico.step)
    end
    _draw = function()
      return game_states:render(pico.step)
    end
    pico.reset_pallet()
    game_states = Stack()
    return game_states:push(Menu(game_states))
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
  local Menu
  Menu = require("menu").Menu
  pico = require("pico")
  _update60 = function()
    return game_states:update(pico.step)
  end
  _draw = function()
    return game_states:render(pico.step)
  end
  pico.reset_pallet()
  game_states = Stack()
  return game_states:push(Menu(game_states))
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
0002000011550065500a5500a550055500a550045500455005550065501a5001a50019500195001a5001a5001b5001c5001a500140000100015500185001f5000e5001a5001b5001a5001a5001a5001b50000000
000200002f0503705035050300502a0501e0500b05007050050500305003050060500105009050096500d65011650156501965022650286502c6502e650306503065004550055500655008550075500755007550
00040000000000004014050130501205011050110501005010050100501105011050120501305012050000001100000000040000000001000000000d0000b000000000b0000b000000000a0000a0000b00000000
0005000004150031501d150041502516006160201500e15002170191701d160121501f150201500e150051500e1500c1500a15009150091500b1500e15014150181500a150141500d1500d150131501315010150
00080000247500a750117500775000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000147501676018760197701b7701f7701f77004300013000730024300213001a30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
