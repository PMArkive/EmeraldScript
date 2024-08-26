-- 指定されたアドレスが実行されたときに、レジスタ `register` の値を `value` で上書きします。
-- `value`に関数が渡された場合、その関数に「アドレスが実行されるごとに加算されるカウンタの値」を渡して評価された値で上書きします。
local function rewrite(address, register, value)
  local t = type(value)
  if t == "number" then
    memory.registerexec(address, function()
      memory.setregister(register, value)
    end)
  elseif t == "function" then
    local cnt = 0
    memory.registerexec(address, function()
      memory.setregister(register, value(cnt))
      cnt = cnt + 1
    end)
  else
    error("value must be number or function")
  end
end

-- 指定されたアドレスが実行されたときにレジスタの状態をログに出力します。
local function watch(address, register, radix)
  radix = radix or "%d"
  local template = "$%.8x called %s:" .. radix
  return memory.registerexec(address, function()
    print(string.format(template, address, register, memory.getregister(register)))
  end)
end

return {
  rewrite = rewrite,
  watch = watch,
}
