local LCG = require 'PkScript.Lcg'

local seedAddress = 0x03005AE0
local function readSeed()
  return memory.readdwordunsigned(seedAddress)
end
local function writeSeed(seed)
  memory.writedword(seedAddress, seed)
end

local function advance()
  local seed = LCG.advance(readSeed())
  writeSeed(seed)
  return seed
end
local function back()
  local seed = LCG.back(readSeed())
  writeSeed(seed)
  return seed
end

return {
  readSeed = readSeed,
  writeSeed = writeSeed,
  advance = advance,
  back = back,
}
