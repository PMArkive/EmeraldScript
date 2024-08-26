local EmJp = {
  seedAddress = 0x03005AE0,
  lcgFnAddress = 0x0806f050,
  lcgExcludeAddresses = {
    0x080007ba, -- 描画消費
    0x080386ea, -- 戦闘消費
  },
  enemyPidAddress = 0x020243E8,
  altSeedAddress = 0x03005AE4,
  altLcgFnAddress = 0x0806f0a4,
  altLcgEdcludeAddresses = {
    0x080109bc, -- 用途不明
  },
}

return {
  EmJp = EmJp,
}
