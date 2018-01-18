local map = {}
map.layers = {}
function map:load(file,address)
  local fs = component.proxy(address)
  local handle = fs.open(file,"rb")
  local layers = read(handle,1)
  self.w = read(handle,1)
  self.h = read(handle,1)
  for i = 1,layers do
    self.layers[i] = {}
    for y = 1, self.w do
      self.layers[i][y] = {}
      for x = 1, self.h do
        self.layers[i][y][x] = read(handle,1)
      end
    end
  end
end
function map:get(x,y,l)
  return self.layers[l][y][x]
end
function map:set(x,y,l,tile)
  self.layers[l][y][x] = tile
end
return map
