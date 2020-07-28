local settings = {
    ["MoveResources"] = {
        ["forward"] = {["command"] = function() turtle.forward() end, ["reverse"] = "back"},
        ["back"] = {["command"] = function() turtle.back() end, ["reverse"] = "forward"},
        ["turnLeft"] = {["command"] = function() turtle.turnLeft() end, ["reverse"] = "turnRight"},
        ["turnRight"] = {["command"] = function() turtle.turnRight() end, ["reverse"] = "turnLeft"},
        ["up"] = {["command"] = function() turtle.up() end, ["reverse"] = "down"},
        ["down"] = {["command"] = function() turtle.down() end, ["reverse"] = "up"},
        ["MoveSequence"] = {}
    },
    ["currentPOS"] = {["x"] = 0, ["y"] = 0, ["z"] = 0},
    ["area_to_mine"] = {["height"] = 0, ["width"] = 0, ["depth"] = 0}
}

local turtle_menu = function ()
    
end

local active = true
local inventory = {}
-- construct pattern
-- traverse pattern
    -- https://en.wikipedia.org/wiki/Body_relative_direction
    -- y = forward, -y = backwards
    -- x = right,   -x = left
    -- z = up,      -z = down
-- mine predictably
-- find shortest path back
-- refuel when low on fuel
-- inventory management
-- menu mockup
    -- Specify Coordinates

io.write("input height, width, depth\n")
local xyz_answer = io.read()
local function addXYZToSettings(xyzanswer)
    local xyz_table = {}
    for i in string.gmatch(xyzanswer, "%S+") do
        table.insert(xyz_table, i)
    end
    local count = 0
    for key, value in pairs(settings.area_to_mine) do
        count = count + 1
        settings.area_to_mine[key] = xyz_table[count]
    end
end

addXYZToSettings(xyz_answer)

for key, value in pairs(settings.area_to_mine) do
    print(key,value)
end

local function moveXYZ()
    settings.MoveResources.forward()
end