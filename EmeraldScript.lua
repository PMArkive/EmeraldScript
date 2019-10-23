dofile('./GBAanalyzer/DEQueue.lua')
dofile('./GBAanalyzer/common.lua')
addresslist = dofile("./GBAanalyzer/ImportAddressList.lua")
log = List.new()
filename = ""

local LCGaddr = 0x0806f050
local seedaddr = 0x3005AE0
-- local EnemyPID = 0x20243E8

local k = 0xFFFF
local InvalidizeEncount = true
local noticeCalledLCG = true

local prev = input.get()
local now={}

while true do
  gui.text(0, 95, vba.framecount().."F") 
  gui.text(0, 105, string.format("Seed: %8X", readMemory(seedaddr)))
  -- gui.text(0, 95, string.format("PID: %8X", readMemory(EnemyPID)))
  -- gui.text(0,105, string.format("Static: %8X", readMemory(0x0E00DF72)))

  -- rewriteRegister(0x0806d74e+4, "r0", 0x4000) -- ポケルス強制感染
  if InvalidizeEncount then rewriteRegister(0x080b48a4+4, "r0", 0xB39) end

  memory.registerexec(LCGaddr, function()
    if memory.getregister("r14") ~= 0x080386ef then
      local ad = string.format("$%.8x", memory.getregister("r14") -5)
      local mes = addresslist[ad]
      local usage = "???unknown???"
      if mes ~= nil then usage = mes.usage end
      if usage == "???" then usage = usage .. "(" .. mes.remark .. ")" end
      if noticeCalledLCG then print(string.format("%sF seed: %#.8x %s %s", vba.framecount(), readMemory(seedaddr), ad, usage)) end
      local message = string.format("%sF,$%.8x,%.8x\n", vba.framecount(), memory.getregister("r14") -5, readMemory(seedaddr))
      List.pushright(log, message)
    end
  end)
  
  noticeCall(0x0808fe16+4, "r0", "%x")
  -- rewriteRegister(0x08000000, "r0", k)

  now=input.get()
  if now['S'] and now['shift'] and not prev['S'] then 
    if filename == "" then 
      local date = string.gsub(string.gsub(string.gsub(os.date(), "/", ""), ":", ""), " ", "_")
      filename = string.format("./Log/Log %s.txt", date)
      local f = io.open(filename, "a")
      f:write("Frame,Address,Seed\n")
      f:close()
    end

    local length = log.last - log.first
    if length > 0 then
      local f = io.open(filename, "a")
      local message
      for i=0, length do
        message = List.popleft(log)
        f:write(message)
      end
      print("Write Log")
      f:close()
    end
  end

  if now['D'] and not prev['D'] then
    local seed = advance(readMemory(seedaddr))
    memory.writedword(seedaddr, seed)
    print(string.format("Advance currentSeed: %08x", seed))
  end
  if now['A'] and not prev['A'] then
    local seed = back(readMemory(seedaddr))
    memory.writedword(seedaddr, seed)
    print(string.format("Back currentSeed: %08x", seed))
  end
  
  prev = now
  emu.frameadvance()
end