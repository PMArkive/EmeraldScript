local function mult32(a, b)
  local higher = (bit.rshift(a, 16) * (b % 0x10000) + (a % 0x10000) * bit.rshift(b, 16)) % 0x10000
  local lower = (a % 0x10000) * (b % 0x10000)
  return higher * 0x10000 + lower
end

local function advance(seed)
  seed = mult32(seed, 0x41C64E6D) + 0x6073
  if seed > 0x80000000 then
    local val = bit.bxor(seed, 0xFFFFFFFF) + 1
    seed = 0 - val
  end
  return seed
end
local function back(seed)
  seed = mult32(seed, 0xeeb9eb65) + 0xa3561a1
  if seed > 0x80000000 then
    local val = bit.bxor(seed, 0xFFFFFFFF) + 1
    seed = 0 - val
  end
  return seed
end

return {
  advance = advance,
  back = back,
}
