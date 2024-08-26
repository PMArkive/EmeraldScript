
local readLong = memory.readdwordunsigned

local offsetTable = { 1,1,2,3,2,3, 0,0,0,0,0,0, 2,3,1,1,3,2, 2,3,1,1,3,2 }
local function getMoves(startAddress, n)
  n = n or 0
  startAddress = startAddress + n * 100
  local EnemyPID = readLong(startAddress)
  local MaskID = readLong(startAddress + 4)
  local mask = bit.bxor(EnemyPID, MaskID)
  local index = (EnemyPID%24) + 1
  local offset = offsetTable[index] * 12 + 32
  local move12 = bit.bxor(readLong(startAddress + offset), mask)
  local move34 = bit.bxor(readLong(startAddress + offset + 4), mask)
  local moves = { move12 % 0x10000, bit.rshift(move12,16), move34 % 0x10000, bit.rshift(move34,16) }
  return moves
end

return getMoves
