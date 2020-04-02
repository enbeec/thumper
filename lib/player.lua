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
  
function player:d_jumping(frame)
  local bx = self.x * self.scale-- base is one square of the center four pixels
  local by = self.y * self.scale-- ...corresponding to player.dir
  local dx = bx + self.dirs[self.dir].x - 4
  local dy = by + self.dirs[self.dir].y - 4
  if frame < 1 or frame > 9 then
    print("i dont have animations for frame -> " .. frame)
  elseif frame == 9 then
    self:d_standing()
  else
    -- lookup here
    -- for now just display a big square in between moving squres
    screen.level(3)
    for i = 0,7 do
      for k = 0,7 do
        screen.pixel(dx+i,dy+k)
      end
    end
  end
end

function player:draw()
  if self.busy == "jump" then
    -- 8 frame animation counter
    if player.ani.counter == -1 then
    -- initialized to -1
    -- then set to 1 and incremented every redraw
      player.ani.counter = 1
      print("jump ani start")
      -- TODO display first frame
      self:d_jumping(player.ani.counter)
    elseif player.ani.counter == 8 then
    -- when it hits 8, it gets stopped,
    --  player gets marked busy == nil
    --  and counter goes back to -1
      print("jump final frame")
      -- TODO display frame 9 (standing + landing particles)
      self:d_jumping(player.ani.counter)
      player.ani.counter = -1
      player.busy = nil
    else
      player.ani.counter = player.ani.counter + 1
      print("jump frame " .. player.ani.counter)
      -- TODO display frames 2-8
      self:d_jumping(player.ani.counter)
    end
    --   also screen_dirty gets forced true
    screen_dirty = "force"
  else -- you are just standing still 
    self:d_standing()
  end
  
  -- fill
  screen.fill()
end

function player:jump(width_max,height_max)
  -- check bottom right collision
  if self.dir == 1 and ( self.x == width_max or self.y == height_max ) then
    print('blocked to the southeast')
    self:rotate(3)
    -- check bottom left
  elseif self.dir == 2 and ( self.x == 0 or self.y == height_max ) then
    print('blocked to the southwest')
    self:rotate(-1)
  elseif self.dir == 3 and ( self.x == 0 or self.y == 0 ) then
    print('blocked to the northwest')
    self:rotate(-1)
  elseif self.dir == 4 and (self.x == width_max or self.y == 0 ) then
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

function player:rotate(d)
  -- rotate only gets handled while you're standing still
  if self.busy == nil then
    if d > 0 and self.dir == 4 then self.dir = 1
    elseif d < 0 and self.dir == 1 then self.dir = 4
    else
      self.dir = util.clamp(self.dir + d,1,4)
    end
    print("facing " .. self.dirs[self.dir].name)
    screen_dirty = true
  end
end
  
return player