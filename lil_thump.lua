-- lil thumper
-- moves about the room
--
-- E2 to rotate
-- K2 to jum
--     with a temp
--     glitchy animation
-- K1 hold to toggle grid
--
-- beware the strange bounces
--
-- TODO: better 
--        animation 
--    and K3 to flip
-- TODO: add rebound on collision
--    ... that doesnt suck..

local WORLD_SCALE = 8
local WORLD_WIDTH = ( 128 / WORLD_SCALE ) - 1
local WORLD_HEIGHT = ( 64 / WORLD_SCALE ) - 1 

player = include('lib/player')
world = include('lib/world')

function init()
  
  re=metro.init()
	re.time = 1.0/20
	re.event = function()
	  redraw()
	end
	
	screen_init()
	re:start()
	
	screen_dirty = true
  world.show_pix_grid = true
	
end


function screen_init()
  screen.aa(1)
end

function redraw()
  if screen_dirty == true then
    screen.clear()
    if world.show_pix_grid == true then
      world.pix_grid(WORLD_SCALE)
    end
    player:draw()
    screen.update()
    if screen_dirty == "force" then
      screen_dirty = true
    else
      screen_dirty = false
    end
  end
end

function enc(n,d)
  if n == 2 and player.busy == nil then
    player:rotate(d)
  end
end

function key(n,z)
  if n == 2 and z == 1 and player.busy == nil then
    player:jump(WORLD_WIDTH,WORLD_HEIGHT)
  elseif n == 1 and z == 1 then
    if world.show_pix_grid then
      world.show_pix_grid = nil
    else
      world.show_pix_grid = true
    end
    screen_dirty = true
  end
end