local rshift = bit.rshift
readMemory = memory.readdwordunsigned

function mult32(a, b)
  local higher = (rshift(a, 16)*(b%0x10000) + (a%0x10000)*rshift(b,16)) % 0x10000
  local lower = (a % 0x10000)*(b % 0x10000)
  return higher*0x10000 + lower
end

function advance(seed)
    seed = mult32(seed, 0x41C64E6D) + 0x6073
    if seed > 0x80000000 then
        local val = bit.bxor(seed, 0xFFFFFFFF) + 1
        seed = 0 - val
    end
    return seed
end
function back(seed)
    seed = mult32(seed, 0xeeb9eb65) + 0xa3561a1
    if seed > 0x80000000 then
        local val = bit.bxor(seed, 0xFFFFFFFF) + 1
        seed = 0 - val
    end
    return seed
end

function rewriteRegister(address, register, value, display) 
  return memory.registerexec(address, function()
    memory.setregister(register, value) 
    if display then print(string.format("rewrite $%.8x %s %x", address, register, value)) 
    end 
  end)
end

function noticeCall(address, register, radix)
  if register == nil then
    return memory.registerexec(address, function() 
      print(string.format("$%.8x called", address))
      print(string.format("  r0:%.8x r1:%.8x r2:%.8x r3:%.8x", memory.getregister("r0"), memory.getregister("r1"), memory.getregister("r2"), memory.getregister("r3")))
      print(string.format("  r4:%.8x r5:%.8x r6:%.8x r7:%.8x", memory.getregister("r4"), memory.getregister("r5"), memory.getregister("r6"), memory.getregister("r7")))
      print(string.format("  r8:%.8x r9:%.8x r10:%.8x r11:%.8x", memory.getregister("r8"), memory.getregister("r9"), memory.getregister("r10"), memory.getregister("r11")))
      print(string.format("  r12:%.8x r13:%.8x r14:%.8x r15:%.8x", memory.getregister("r12"), memory.getregister("r13"), memory.getregister("r14"), memory.getregister("r15")))
    end)
  end
  radix = radix or "%d"
  local s = "$%.8x called %s:" .. radix
  return memory.registerexec(address, function() print(string.format(s, address, register, memory.getregister(register))) end)
end
