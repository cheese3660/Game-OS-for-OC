--the first library, an image library
local img = {}
local gpu = component.proxy(component.list("gpu")())
function img:loadFromFile(file,address)
  local newImage = {}
  local fs = component.proxy(address)
  local handle = fs.open("rb")
  newImage.w = fs.read(handle,1)
  newImage.h = fs.read(handle,1)
  newImage.data = {}
  for y = 1, newImage.h do
    newImage.data[y] = {}
    for x = 1, newImage.w do
      newImage.data[y][x] = fs.read(handle,1)
    end
  end
  fs.close(handle)
  function newImage:set(x,y,color)
    self.data[y][x] = color
  end
  function newImage:get(x,y)
    return self.data[y][x]
  end
  function newImage:addToBuffer(x,y,buffer)
    local d = self.data
    for iy=1,self.h do
      local r = d[iy]
      for ix=1,self.w do
        buffer[ix+x-1][iy+y-1]={" ",0,r[ix]}
      end
    end
  end
  return newImage
end
function img:loadFromStr(str)
  local newImage = {}
  local i = 1
  local function read(s)
    i = i+1
    return s:sub(i-1,i-1)
  end
  newImage.w = read(str)
  newImage.h = read(str)
  newImage.data = {}
  for y = 1, newImage.h do
    newImage.data[y] = {}
    for x = 1, newImage.w do
      newImage.data[y][x] = read(str)
    end
  end
  function newImage:set(x,y,color)
    self.data[y][x] = color
  end
  function newImage:get(x,y)
    return self.data[y][x]
  end
  function newImage:addToBuffer(x,y,buffer)
    local d = self.data
    for iy = 1, self.h do
      local r = d[iy]
      for ix=1,self.w do
        buffer[ix+x-1][iy+y-1] = {" ",0,r[ix]}
      end
    end
  end
  return newImage
end
function img:new(w,h)
  local newImage = {}
  newImage.w = w
  newImage.h = h
  newImage.data = {}
  for y=1,h do
    newImage.data[y] = {}
    for x=1,w do
      newImage.data[y][x] = 0
    end
  end
  function newImage:set(x,y,color)
    self.data[y][x] = color
  end
  function newImage:get(x,y)
    return self.data[y][x]
  end
  function newImage:addToBuffer(x,y,buffer)
    local d = self.data
    for iy = 1, self.h do
      local r = d[iy]
      for ix=1,self.w do
        buffer[ix+x-1][iy+y-1] = {" ",0,r[ix]}
      end
    end
  end
  return newImage
end
return img