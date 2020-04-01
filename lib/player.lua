-- module for lil_thumper player

local player = {}
local DEFAULT_WORLD_SCALE = 8

player.x, player.y = 0,0
player.dir = 1
player.dirs = {
  {x=1,y=1},  -- SE
  {x=-1,y=1}, -- SW
  {x=-1,y=-1}, -- NW
  {x=1,y=-1}, -- NE
}
player.scale = DEFAULT_WORLD_SCALE

function player.draw(self)
  
  -- base is one square of the center four pixels
  -- ...corresponding to player.dir
  local bx = self.x * self.scale + 3
  local by = self.y * self.scale + 3
  local dx = self.dirs[self.dir].x
  local dy = self.dirs[self.dir].y
  
  -- draw head (one away from base in dir)
  screen.pixel(bx+dx,by+dy)
  
  -- draw body (two away from base in opposite dir and it's neighbors)
  screen.pixel(bx-(2*dx),by-(2*dy))
  
  screen.pixel(bx-dx,by-(2*dy))
  screen.pixel(bx-(2*dx),by-dy)
  
  screen.pixel(bx,by-(2*dy))
  screen.pixel(bx-(2*dx),by)
  
  -- fill
  screen.fill()
end

function player.move(self,width_max,height_max)
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
    self.x = self.x + self.dirs[self.dir].x
    self.y = self.y + self.dirs[self.dir].y
  end
  screen_dirty = true
end

function player.rotate(self,d)
    if d > 0 and self.dir == 4 then self.dir = 1
    elseif d < 0 and self.dir == 1 then self.dir = 4
    else
      self.dir = util.clamp(self.dir + d,1,4)
    end
end
  
return player