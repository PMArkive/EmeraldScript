function split(str, ts)
    if ts == nil then return {} end
    local t = {} ; 
    i=1
    for s in string.gmatch(str, "([^"..ts.."]+)") do
        t[i] = s
        i = i + 1
    end
    return t
end

local list = {}
local f = io.open("./GBAanalyzer/AddressList_Em.txt")
while true do
    local read = f:read()
    if read == nil then break end
    local line = split(read, ",")
    list[line[1]] = { usage = line[2], remark = line[3] }
end
return list