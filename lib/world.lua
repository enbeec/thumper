local world = {}

-- TILES
tile = {}
t_mt = { __index = tile }

-- WARNING: for now, just give it a scale
--            and use this to create stone blocks
function tile:create(s,m,drawFunc)
  
  local t = {
    scale = s
  }
  
  setmetatable(t,t_mt)
  
  if m ~= nil then
    t.material = m
  else
    t.material = {
      name = "stone",
      blocked = "blocked",
      level = 7,
      -- could also be "visible" or "walkable" or nil
    }
  end
  
  if drawFunc ~= nil then
    t.draw = drawFunc
  else
    -- look to player.lua 'player:draw()' for animation
    function t:draw(x,y)
      -- these base coords are the top left hand of the tile
      local bx = self.x * self.scale
      local by = self.y * self.scale
      -- draw something using the base coords
      for i = 0,self.scale-1 do
        for k = 0,self.scale-1 do
          screen.level(self.level)
          screen.pixel(bx+i,by+k)
        end
      end
      screen.fill()
    end
  end
  
  return t

end

-- TILETABLE
tiletable = {}
tt_mt = { __index = tiletable }

function tiletable:create(mx,my) -- holds tiles for a 'map' or 'screen'
  local t = {
    bx = 0, x = mx, -- top two corners
    by = 0, y = my, -- bottom two corners
    tiles = {}, -- TODO: fill starting table with floor tiles
  }
  setmetatable(t,tt_mt)
  return t
end

function tiletable:renderAll()
  for _,tile in ipairs(self.tiles) do
    tile.draw() 
  end
end

-- WARNING: for now please manage not duplicating entries yourself
--          if you have two tiles at (1,1) yr on yr own....
--        in the future you can force replace by passing 'true'
function tiletable:addTile(tile,replace)
  -- TODO: check if another tile exists at x,y
  --        if so, is arg 'replace' true?
  --        if so, then add tile to self.tiles
  table.insert(self.tiles,tile)
end

-- TODO: replace the word 'grid' with 'ruler'
--        to avoid ambiguity with monome ecosystem
-- TODO: clean up the grid code.
--        a grid is helpful
--        but I'd like to use the world
--        a little more like... everything above
world.grid = { lvl = 3 }
world.show_pix_grid = false

function world.pix_grid(num)
  if world.grid == {} then
    world.grid.state = true
    screen.line_width(1)
  end
  local xx,yy = 0,0
  screen.level(world.grid.lvl)
  for i = 0,num do
    local k = num*i
    screen.move(xx,yy+k)
    screen.line(xx+128,yy+k) 
    screen.stroke()
    if k >= 64 then break end
  end
  for i = 0,num*2 do
    local k = num*i
    screen.move(xx+k,yy)
    screen.line(xx+k,yy+64) 
    screen.stroke()
    if k >= 128 then break end
  end
end

return world