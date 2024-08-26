local observer = require 'PkScript.Cheat.Observer'
local rewriteRegister = observer.rewriteRegister
local noticeCall = observer.noticeCall

local pickupTable = { 30, 40, 50, 60, 70, 80, 85, 90, 95, 100 }
local function cheat()
  rewriteRegister(0x08161e06+4, "r0", 0) -- 徘徊出現判定
  rewriteRegister(0x08161c2e+4, "r0", 0) -- 徘徊高飛び先
  rewriteRegister(0x080e5846+4, "r0", 9) -- ランダムアピール

  rewriteRegister(0x080b413c+4, "r0", 0) -- ヒンバス判定
  
  rewriteRegister(0x080430cc, "r0", 0) -- 胞子判定
  rewriteRegister(0x080430e8, "r0", 2) -- 胞子効果判定
  
  rewriteRegister(0x081a9a2a+4, "r0", 0)
  -- rewriteRegister(0x0806d74e+4, "r0", 0x4000) -- ポケルス強制感染
  -- rewriteRegister(0x08161caa+4, "r0", 4)
  
  rewriteRegister(0x0803b4d6+4, "r0", 0) -- 爪
  rewriteRegister(0x0803b752+4, "r0", 0) -- 爪
  rewriteRegister(0x08130d02+4, "r0", 2) -- 技選択
  rewriteRegister(0x08070542+4, "r0", 0) -- 卵生成
  --rewriteRegister(0x080677dc+4, "r0", 0x1635) -- 徘徊LID
  --rewriteRegister(0x080677e2+4, "r0", 0x0000) -- 徘徊HID
  rewriteRegister(0x081a866c+4, "r0", 1) -- 威嚇無効化
  --rewriteRegister(0x080b4222+4, "r0", 40) -- スロット決定
  rewriteRegister(0x080465a0+4, "r0", 0) -- 必中
  rewriteRegister(0x0804697a+4, "r0", 0) -- 急所
  rewriteRegister(0x08047536+4, "r0", 0) -- ダメージ乱数
  rewriteRegister(0x08049690+4, "r0", 99) -- 追加効果
  rewriteRegister(0x0805620e+4, "r0", 0) -- 捕獲判定
  rewriteRegister(0x0803ea34+4, "r0", 0) -- 逃走判定
  --rewriteRegister(0x080679ac+4, "r0", 0x7FFF) -- HAB
  --rewriteRegister(0x080679f6+4, "r0", 0x7FFF) -- SCD
  rewriteRegister(0x080b413c+4, "r0", 0x0) -- ヒンバス
  rewriteRegister(0x0808c29c+4, "r0", 0) -- 必ず釣れる
  rewriteRegister(0x08041d6c+4, "r0", 1) -- 麻痺回避
  rewriteRegister(0x08041c96+4, "r0", 1) -- 自傷回避
  -- rewriteRegister(0x080475c2+4, "r0", 0) -- 無限に気合のハチマキ
  -- rewriteRegister(0x0804e94e+4, "r0", 0) -- hachi?
  rewriteRegister(0x0808c350+4, "r0", 0)
  rewriteRegister(0x0805589c+4, "r0", 0) -- ものひろい
  rewriteRegister(0x081aa882+4, "r0", pickupTable[8]-1) -- ものひろいアイテム
  rewriteRegister(0x0804f9ec+4, "r0", 0xFFFF) -- まもる
end

local function notice()
  noticeCall(0x080e5418, "r0") -- 緊張
  
  --noticeCall(0x0804698a)
  noticeCall(0x0803cf08, "r1")
  
  -- noticeCall(0x0806f0a4)
  -- memory.registerexec(0x0806f0a4, function() print(string.format("%dF frameCount: %d HID", vba.framecount(), readLong(seedaddr+4), readLong(seedaddr+4))) end)
end

return {
  load = function()
    cheat()
    notice()
  end,
  encounter = function(option)
    if option == "none" then
      rewriteRegister(0x080b48b4+4, "r0", 0xB39)
    elseif option == "force" then
      rewriteRegister(0x080b48b4+4, "r0", 0)
    end
  end,
}