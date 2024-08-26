return function()
    local list = { first = 0, last = -1, filename = "" }

    list.pushleft = function(value)
        local first = list.first - 1
        list.first = first
        list[first] = value
    end

    list.pushright = function(value)
        local last = list.last + 1
        list.last = last
        list[last] = value
    end

    list.popleft = function()
        local first = list.first
        if first > list.last then error("Queue: list is empty") end

        local value = list[first]
        list[first] = nil
        list.first = first + 1
        return value
    end

    list.popright = function()
        local last = list.last
        if list.first > last then error("Queue: list is empty") end

        local value = list[last]
        list[last] = nil
        list.last = last - 1
        return value
    end

    list.save = function()
        if list.filename == "" then
            ---@diagnostic disable-next-line: param-type-mismatch
            local date = string.gsub(string.gsub(string.gsub(os.date(), "/", ""), ":", ""), " ", "_")
            list.filename = string.format("./Log/Log %s.txt", date)
            local f = io.open(list.filename, "a")
            f:write("Frame,Address,Seed\n")
            f:close()
        end

        local len = list.last - list.first
        if len > 0 then
            local f = io.open(list.filename, "a")
            local message
            for _ = 0, len do
                message = list.popleft()
                f:write(message)
            end
            print("Write Log")
            f:close()
        end
    end

    return list
end
