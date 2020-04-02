local world = {}

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