return function(lcgAddress, listeners)
  local function onCallLcg()
    -- 毎フレーム発生する描画消費・戦闘画面の消費は無視する
    local lr = memory.getregister("r14")
    local frequent = lr == 0x080386ef or lr == 0x080007ba + 5
    if frequent then return end

    local frame = vba.framecount()
    local address = string.format("$%.8x", memory.getregister("r14") - 5)

    for _, f in pairs(listeners) do
      f(frame, address)
    end
  end

  memory.registerexec(lcgAddress, onCallLcg)
end
