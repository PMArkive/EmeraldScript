local altLcgAddress = 0x0806f0a4
local altSeedAddress = 0x3005AE4

local function onCallLcg()
  local lr = memory.getregister("r14") - 5
  local frequent = lr == 0x080109bc
  if frequent then return end

  local frame = vba.framecount()
  local address = string.format("$%.8x", lr)
  local seed = memory.readdwordunsigned(altSeedAddress)

  print(string.format("%sF another %s %s", frame, address, seed))
end

return function()
  memory.registerexec(altLcgAddress, onCallLcg)
end
