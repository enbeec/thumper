-- module for lil_thumper player

local player = {}
local DEFAULT_WORLD_SCALE = 8

player.x, player.y = 0,0
player.dir = 1
player.dirs = {
  {x=1,y=1,name="southeast"},  -- SE
  {x=-1,y=1,name="southwest"}, -- SW
  {x=-1,y=-1,name="northwest"}, -- NW
  {x=1,y=-1,name="northeast"}, -- NE
}
player.scale = DEFAULT_WORLD_SCALE
player.ani = {}
player.ani.counter = -1


function player:d_standing()
  local bx = self.x * self.scale + 3 -- base is one square of the center four pixels
  local by = self.y * self.scale + 3 -- ...corresponding to player.dir
  local dx = self.dirs[self.dir].x
  local dy = self.dirs[self.dir].y
  
  screen.level(12)
  -- draw head (one away from base in dir)
  screen.pixel(bx+dx,by+dy)
  
  -- draw body (two away from base in opposite dir and it's neighbors)
  screen.pixel(bx-(2*dx),by-(2*dy))
  
  screen.pixel(bx-dx,by-(2*dy))
  screen.pixel(bx-(2*dx),by-dy)
  
  screen.pixel(bx,by-(2*dy))
  screen.pixel(bx-(2*dx),by)
end
  
function player:d_jumping(frame) -- TODO fix the offsets and everything; code is W R O N G
  local bx = self.x * self.scale
  local by = self.y * self.scale
  local dx = bx + self.dirs[self.dir].x 
  local dy = by + self.dirs[self.dir].y
  if frame < 1 or frame > 9 then
    print("i dont have animations for frame -> " .. frame)
  elseif frame == 9 then
    self:d_standing()
  elseif frame <= 2 and frame < 6 then
    
  -- START STEP
    screen.level(6)
    for i = 0,4 do
      for k = 0,4 do
        screen.pixel(bx+(dx*i),by+(dy*k))
      end
    end
    
  elseif frame >= 6 and frame < 9 then
    
  -- MIDDLE STEP
    screen.level(3)
    for i = 0,7 do
      for k = 0,7 do
        screen.pixel(dx+i-2,dy+k-2)
      end
    end
    
  elseif frame == 9 then
    
  -- END STEP
  
  end
end

-- this mostly handles animation
-- it triggers functions prefixed by "d_"
-- that do the actual rendering
function player:draw()
  if self.busy == "jump" then
    if player.ani.counter == -1 then
      player.ani.counter = 1
      -- print("jump ani start")
      self:d_jumping(player.ani.counter)
    elseif player.ani.counter == 8 then
      -- print("jump final frame")
      self:d_jumping(player.ani.counter)
      player.ani.counter = -1
      player.busy = nil
    else
      player.ani.counter = player.ani.counter + 1
      -- print("jump frame " .. player.ani.counter)
      self:d_jumping(player.ani.counter)
    end
    --   also screen_dirty gets forced true
    screen_dirty = "force"
  elseif self.busy == "turned" then
    if player.ani.counter == -1 then
      player.ani.counter = 1
      -- print("rotate start")
    elseif player.ani.counter == 4 then
      -- print("rotate end")
      player.ani.counter = -1
      player.busy = nil
    else
      player.ani.counter = player.ani.counter + 1
      -- print("rotate frame " .. player.ani.counter)
    end
    screen_dirty = "force"
  elseif self.busy == "flip" then
    -- do flip animation
    self.busy = nil
    self:d_standing()
    screen_dirty = true
  else -- you are just standing still 
    self:d_standing()
  end
  
  -- fill
  screen.fill()
end

function player:jump(w_max,h_max)
  -- check bottom right collision
  if self.dir == 1 and ( self.x == w_max or self.y == h_max ) then
    print('blocked to the southeast')
    self:rotate(3)
    -- check bottom left
  elseif self.dir == 2 and ( self.x == 0 or self.y == h_max ) then
    print('blocked to the southwest')
    self:rotate(-1)
  elseif self.dir == 3 and ( self.x == 0 or self.y == 0 ) then
    print('blocked to the northwest')
    self:rotate(-1)
  elseif self.dir == 4 and (self.x == w_max or self.y == 0 ) then
    print('blocked to the northeast')
    self:rotate(3)
  else
    local z = self.dirs[self.dir]
    -- print("jumping to the " .. z.name) 
    self.x = self.x + z.x
    self.y = self.y + z.y
    self.busy = "jump"
  end
  screen_dirty = true
end

function player:flip(w_max,h_max)
  -- check br col
  if self.dir == 1 and ( self.x == w_max or self.y == h_max ) then
    print('blocked to the southeast')
    -- check bottom left
  elseif self.dir == 2 and ( self.x == 0 or self.y == h_max ) then
    print('blocked to the southwest')
  elseif self.dir == 3 and ( self.x == 0 or self.y == 0 ) then
    print('blocked to the northwest')
  elseif self.dir == 4 and (self.x == w_max or self.y == 0 ) then
    print('blocked to the northeast')
  else
    local z = self.dirs[self.dir]
    self.x = self.x + z.x
    self.y = self.y + z.y
    self.busy = "flip"
  end
end

function player:rotate(d)
  -- rotate only gets handled while you're standing still
  if self.busy == nil then
    if d > 0 and self.dir == 4 then self.dir = 1
    elseif d < 0 and self.dir == 1 then self.dir = 4
    else
      self.dir = util.clamp(self.dir + d,1,4)
    end
    print("facing " .. self.dirs[self.dir].name)
  end
  screen_dirty = true
  self.busy = "turned"
end

return player
