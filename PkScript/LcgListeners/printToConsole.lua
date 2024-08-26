return function(rngSys, addressDict)
  return function(frame, address)
    local seed = rngSys.readSeed()
    local record = addressDict.get(address)
    print(string.format("%sF seed: %#.8x %s %s", frame, seed, address, record or "???unknown???"))
  end
end
