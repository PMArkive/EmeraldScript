local Counter = {
  new = function()
    local obj = {}
    obj.i = -1
    obj.increment = function(self)
      self.i = self.i + 1
      return self.i
    end
    obj.reset = function(self) self.i = -1 end
    return obj
  end
}

-- アドレスに対して呼び出し回数を記録しておく
local counterList = {}

-- 指定されたアドレスが実行されたときに、レジスタ `register` の値を `value` で上書きします。
-- `value`の値として`"counter"`が渡された場合、アドレスが実行されるごとに加算されるカウンタの値で上書きします。
local function rewrite(address, register, value)
  if counterList[address] == nil then counterList[address] = Counter.new() end
  return memory.registerexec(address, function()
    if value == "counter" then value = counterList[address]:increment() end
    memory.setregister(register, value)
  end)
end

-- 指定されたアドレスが実行されたときにレジスタの状態をログに出力します。
-- 第2引数が渡された場合は対応するレジスタのみを、渡されない場合は全てのレジスタの値を出力します。
local function watch(address, register, radix)
  if register == nil then
    return memory.registerexec(address, function()
      print(string.format("$%.8x called", address))
      print(string.format("  r0:%.8x r1:%.8x r2:%.8x r3:%.8x", memory.getregister("r0"), memory.getregister("r1"),
        memory.getregister("r2"), memory.getregister("r3")))
      print(string.format("  r4:%.8x r5:%.8x r6:%.8x r7:%.8x", memory.getregister("r4"), memory.getregister("r5"),
        memory.getregister("r6"), memory.getregister("r7")))
      print(string.format("  r8:%.8x r9:%.8x r10:%.8x r11:%.8x", memory.getregister("r8"), memory.getregister("r9"),
        memory.getregister("r10"), memory.getregister("r11")))
      print(string.format("  r12:%.8x r13:%.8x r14:%.8x r15:%.8x", memory.getregister("r12"), memory.getregister("r13"),
        memory.getregister("r14"), memory.getregister("r15")))
    end)
  end
  radix = radix or "%d"
  local s = "$%.8x called %s:" .. radix
  return memory.registerexec(address,
    function() print(string.format(s, address, register, memory.getregister(register))) end)
end

return {
  rewrite = rewrite,
  watch = watch,
}
