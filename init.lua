function getEvent(name, index)
  while true do
    ev = table.pack(computer.pullSignal())
    if ev[1] == name then
      if index then
        return ev[index]
      else
        return table.unpack(ev)
      end
    end
  end
end
bootAddress = computer.getBootAddress()
bootFS = component.proxy(bootAddress)
gpu = component.proxy(component.list("gpu")())
screen = component.list("screen")()
gpu.bind(screen)
sw,sh = gpu.getResolution()
gpu.fill(1,1,sw,sh," ")
packages={}
function loadfile(file,address)
  local cp = component
  local addr, invoke = address, cp.invoke
  local handle, reason = invoke(addr, "open", file)
  assert(handle, "Loading: "..reason)
  local buffer = ""
  repeat
    local data, reason = invoke(addr, "read", handle, math.huge)
    assert(data or not reason, reason)
    buffer = buffer .. (data or "")
  until not data
  invoke(addr, "close", handle)
  return load(buffer, "=" .. file, "bt", _G)
end
if bootFS.exists("lib") then
  for k,v in pairs(bootFS.list("lib")) do
    packages[v] = loadfile("lib/"..v,bootAddress) 
  end
end
function require(file)
  if packages[file] then
    return packages[file]()
  else
    error("Invalid library: "..file.."\nUse dofile instead")
  end
end
function dofile(file,address,...)
  loadfile(file,address)(...)
end
