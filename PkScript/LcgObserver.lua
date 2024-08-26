return function(lcgAddress, options)
  local function onCallLcg()
    local lr = memory.getregister("r14") - 5
    for _, ex in pairs(options.exclude) do
      if lr == ex then return end
    end

    local frame = vba.framecount()
    local address = string.format("$%.8x", lr)

    for _, f in pairs(options.listeners) do
      f(frame, address)
    end
  end

  memory.registerexec(lcgAddress, onCallLcg)
end
