-- lil thumper
-- moves about the room
--
-- E1 to rotate
-- K2 to move forward
-- beware the strange bounces
--
-- TODO: animation 
--    and K3 to flip
-- TODO: add rebound on collision
--    ... that doesnt suck..

local WORLD_SCALE = 8
local WORLD_WIDTH = ( 128 / WORLD_SCALE ) - 1
local WORLD_HEIGHT = ( 64 / WORLD_SCALE ) - 1 

player = include('lib/player')
local world = {}
local grid = { lvl = 3 }
local show_pix_grid,show_debug_draw = false,false

function init()
  
  re=metro.init()
	re.time = 1.0/15
	re.event = function()
	  redraw()
	end
	
	screen_init()
	re:start()
	
	screen_dirty = true
	
end


function screen_init()
  screen.aa(0)
end

function redraw()
  if screen_dirty == true then
    screen.clear()
    if show_pix_grid == true then
      pix_grid(WORLD_SCALE)
    end
    if show_debug_draw == true then
      debug_draw()
    end
    player:draw()
    screen.update()
    screen_dirty = false
  end
end

function pix_grid(num)
  if grid == {} then
    grid.state = true
    screen.line_width(1)
  end
  local xx,yy = 0,0
  screen.level(grid.lvl)
  for i = 0,WORLD_HEIGHT do
    local k = num*i
    screen.move(xx,yy+k)
    screen.line(xx+128,yy+k) 
    screen.stroke()
    if k >= 64 then break end
  end
  for i = 0,WORLD_WIDTH do
    local k = num*i
    screen.move(xx+k,yy)
    screen.line(xx+k,yy+64) 
    screen.stroke()
    if k >= 128 then break end
  end
end

function debug_draw()
  screen.level(15)
  for i = 0,2 do
    local ii = i * WORLD_SCALE
    screen.pixel(1*ii,1*ii)
    screen.fill()
  end
end

function enc(n,d)
  if n == 2 then
    -- player.x = util.clamp(player.x + d,0,15)
  elseif n == 3 then
    -- player.y = util.clamp(player.y + d,0,7)
  elseif n == 1 then
    player:rotate(d)
  end
  screen_dirty = true
end

function key(n,z)
  if n == 2 and z == 1 then
    player:move(WORLD_WIDTH,WORLD_HEIGHT)
  end
end