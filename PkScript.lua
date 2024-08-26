
local seedAddress = 0x3005AE0
local function readSeed()
  return memory.readdwordunsigned(seedAddress)
end


-- LCG呼び出しを監視してログ等に出力
local observeLcg = require 'PkScript.LcgObserver'

local logger = (require 'PkScript.Logger')()
local function printToLog(frame, address)
  local seed = readSeed()
  logger.pushright(string.format("%sF,%s,%.8x\n", frame, address, seed))
end

local addressDict = (require 'PkScript.AddressDict')("./PkScript/AddressList_Em.txt")
local function printLcgEvent(frame, address)
  local seed = readSeed()
  local record = addressDict.get(address)
  print(string.format("%sF seed: %#.8x %s %s", frame, seed, address, record or "???unknown???"))
end

observeLcg(0x0806f050, {
  printToLog,
  printLcgEvent,
})

-- 通常乱数列のほかに稀に使われる代替LCGの監視
local observeAltLcg = require 'PkScript.AltLcgObserver'
observeAltLcg()

-- LCG呼び出しにフックしてレジスタを書き換えるチート
local cheat = require 'PkScript.Cheat'
cheat.load()
cheat.encounter("none")


-- その他、便利モジュール群
local LCG = require 'PkScript.Lcg'
local moveNames = require 'PkScript.moves.moveJP'
local getMoves = require 'PkScript.moves.getMoves'

local enemyPidAddress = 0x20243E8

-- local feebas = 0x020388a4


-- main loop
local prev = input.get()
local now={}
while true do
  gui.text(0, 75, vba.framecount().."F") 
  gui.text(0, 85, string.format("Seed: %8X", readSeed()))
  -- gui.text(0, 95, string.format("PID: %8X", memory.readdwordunsigned(enemyPidAddress)))
  -- gui.text(0, 105, string.format("Route %d", 100 + memory.readbyte(0x0203B953)-0xF))
  
  now=input.get()
  if now['S'] and now['shift'] and not prev['S'] then
    logger.save()
  end

  if now['M'] and not prev['M'] then 
    local moves = getMoves(enemyPidAddress, 0)
    print(string.format("%s/%s/%s/%s", moveNames[moves[1]] or "", moveNames[moves[2]] or "", moveNames[moves[3]] or "", moveNames[moves[4]] or ""))
  end

  if now['N'] and not prev['N'] then 
    local nextMove = memory.readdwordunsigned(0x02023F1A)
    print(string.format("NextMove: %s", moveNames[nextMove] or ""))
  end

  -- LCGの手動更新
  if now['D'] and not prev['D'] then
    local seed = LCG.advance(readSeed())
    memory.writedword(seedaddr, seed)
    print(string.format("Advance currentSeed: %08x", seed))
  end
  if now['A'] and not prev['A'] then
    local seed = LCG.back(readSeed())
    memory.writedword(seedaddr, seed)
    print(string.format("Back currentSeed: %08x", seed))
  end
  
  prev = now
  emu.frameadvance()
end
