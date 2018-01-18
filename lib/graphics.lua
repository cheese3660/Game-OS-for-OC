local graphics = {}
graphics.gpu = component.proxy(component.list("gpu")())
function graphics:point(buffer,x,y,c)
  buffer.changed = true
  buffer[x][y] = {" ",0,c}
end
function graphics:line(buffer,x0,x1,y0,y1,c)
  buffer.changed = true
  if x0 == x1 then
    step = y0>y1 and -1 or 1
    for y = y0,y1,step do
      buffer[x0][y] = {" ",0,c}
    end
  elseif y0 == y1 then
    step = x0>x1 and -1 or 1
    for x = x0,x1,step do
      buffer[x][y0] = {" ",0,c}
    end
  else
    --bresenham's line algorithm
    local abs = math.abs
    local floor = math.floor
    if x0 > x1 then
      swap = x0
      x0 = x1
      x1 = swap
    end
    if y0 > y1 then
      swap = y0
      y0 = y1
      y1 = swap
    end
    dx = x1 - x0
    dy = y1 - y0
    D = 2*dy - dx
    y = y0
    for x = x0,x1 do
      buffer[x][y] = {" ",0,c}
      if D>0 then
        y = y + 1
        D = D - 2*dx
      end
      D = D + 2*dy
    end
  end
end
function graphics:trig(buffer,x0,x1,x2,y0,y1,y2,c) --faster than using poly
  self:line(buffer,x0,x1,y0,y1,c)
  self:line(buffer,x1,x2,y1,y2,c)
  self:line(buffer,x2,x0,y2,y0,c)
end
function graphics:quad(buffer,x0,x1,x2,x3,y0,y1,y2,y3,c) --faster than using poly
  self:line(buffer,x0,x1,y0,y1,c)
  self:line(buffer,x1,x2,y1,y2,c)
  self:line(buffer,x2,x3,y2,y3,c)
  self:line(buffer,x3,x0,y3,y0,c)
end
function graphics:poly(buffer,points,c)
  prevPoint = points[1]
  for p = 2,#points do
    cPoint = points[p]
    self:line(buffer,prevPoint[1],cPoint[1],prevPoint[2],cPoint[2],c)
    prevPoint = cPoint
  end
  self:line(buffer,prevPoint[1],points[1][1],prevPoint[2],points[1][2],c)
end
function graphics:ellipse(buffer,x,y,w,h,c)
  buffer.changed = true
  local PI2 = math.pi*2
  local floor = math.floor
  local cos = math.cos
  local sin = math.sin
  for t=0,PI2,0.1 do
    local px = floor(x+(w*cos(t)))
    local py = floor(y+(h*sin(t)))
    buffer[px][py] = {" ",0,c}
  end
end
function graphics:circle(buffer,x,y,r,c)
  buffer.changed = true
  local PI2 = math.pi*2
  local floor = math.floor
  local cos = math.cos
  local sin = math.sin
  for t=0,PI2,0.1 do
    local px = floor(x+(r*cos(t)))
    local py = floor(y+(r*sin(t)))
  end
end
function graphics:ellipseFill(buffer,x,y,w,h,c)
  wbig = false
  if w > h then wbig = true end
  for off = 0,wbig and h-1 or w-1,-1 do
    self:ellipse(buffer,x,y,w-off,h-off,c)
  end
end
function graphics:circleFill(buffer,x,y,r,c)
  for r1 = 1,r do
    self:circle(buffer,x,y,r1,c)
  end
end
function graphics:rectFill(buffer,x,y,w,h,c)
  buffer.changed = true
  for x0 = x,w+x-1 do
    for y0 = y,h+y-1 do
      buffer[x0][y0] = {" ",0,c}
    end
  end
end
function graphics:string(buffer,x,y,str,bg,fg)
  buffer.changed = true
  for i=1,str:len() do
    if not buffer[x+i-1] then return end
    buffer[x+i-1][y] = {str:sub(i,i),bg,fg} 
  end
end
function graphics:createBuffer()
  local width,height = self.gpu.getResolution()
  local result = {}
  for x=1,height do
    result[x] = {}
    for y=1,width do
      result[x][y] = {" ",0,0}
    end
  end
  result.changed = true
  return result
end
function graphics:render(buffer)
  if buffer.changed then
  local sfg = self.gpu.setForeground
  local gfg = self.gpu.getForeground
  local sbg = self.gpu.setBackground
  local gbg = self.gpu.getBackground
  local set = self.gpu.set
  local prevfg = 0
  local prevbg = 0
  sfg(0,true)
  sbg(0,true)
  for x = 1,#buffer do
    local row = buffer[x]
    for y=1,#row do
      local pixel = row[y]
      local char = pixel[1]
      local fg = pixel[2]
      local bg = pixel[3]
      if prevfg ~= fg then
        prevfg = fg
        sfg(fg,true)
      end
      if prevbg ~= bg then
        prevbg = bg
        sbg(bg,true)
      end
      set(x,y,char)
    end
  end
  buffer.changed = false
  end
end
return graphics