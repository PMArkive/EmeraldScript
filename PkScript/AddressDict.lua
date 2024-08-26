local function split(str, ts)
    if ts == nil then return {} end
    local t = {} ; 
    i=1
    for s in string.gmatch(str, "([^"..ts.."]+)") do
        t[i] = s
        i = i + 1
    end
    return t
end

local function createAddressDict(path)
    local dict = {}
    local f = io.open(path)
    while true do
        local read = f:read()
        if read == nil then break end

        local line = split(read, ",")
        local address = line[1]
        local label = line[2]
        
        dict[address] = label
    end

    return {
        get = function(address)
            return dict[address]
        end
    }
end

return createAddressDict
