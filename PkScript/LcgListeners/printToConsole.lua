local rngSys = require 'PkScript.RngSystem'

local addressDict = (require 'PkScript.AddressDict')("./PkScript/AddressList_Em.txt")
return function(frame, address)
  local seed = rngSys.readSeed()
  local record = addressDict.get(address)
  print(string.format("%sF seed: %#.8x %s %s", frame, seed, address, record or "???unknown???"))
end
