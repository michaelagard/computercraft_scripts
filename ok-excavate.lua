Move = {
    ["forward"] = {["command"] = function() turtle.forward(); Move.forward.count = Move.forward.count + 1; end, ["count"] = 0, ["reverse"] = "back"},
    ["back"] = {["command"] = function() turtle.back() end, ["count"] = 0, ["reverse"] = "forward"},
    ["turnLeft"] = {["command"] = function() turtle.turnLeft() end, ["count"] = 0, ["reverse"] = "turnRight"},
    ["turnRight"] = {["command"] = function() turtle.turnRight() end, ["count"] = 0, ["reverse"] = "turnLeft"},
    ["up"] = {["command"] = function() turtle.up() end, ["count"] = 0, ["reverse"] = "down"},
    ["down"] = {["command"] = function() turtle.down() end, ["count"] = 0, ["reverse"] = "up"},
    ["MoveSequence"] = {}
}

Settings = {
    ["arg_x"] = 0, --right/left
    ["arg_y"] = 0, --forward/backwards
    ["arg_z"] = 0, --up/down
}

local function tableLength(table)
    local table_count = 0
    if (type(table) == "table") then
        for key, value in pairs(table) do
            table_count = table_count + 1
        end
        return table_count
    end
    return 0
end

local args = {...}

local function handleArguments()
    for i = 1, tableLength(args), 1 do
        if (type(args[i]) == "number") then
            if (i == 1) then
                Settings.arg_x = args[i]
            elseif (i == 2) then
                Settings.arg_y = args[i]
            elseif (i == 3) then
                Settings.arg_z = args[i]
            else
                error("too many arguments")
            end
        else
            error("argument is not a number.")
        end
    end 
end

handleArguments()