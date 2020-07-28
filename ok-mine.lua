local settings = {
    ["move_resources"] = {
        ["forward"] = {["command"] = function() turtle.forward() end, ["reverse"] = "back"},
        ["back"] = {["command"] = function() turtle.back() end, ["reverse"] = "forward"},
        ["turnLeft"] = {["command"] = function() turtle.turnLeft() end, ["reverse"] = "turnRight"},
        ["turnRight"] = {["command"] = function() turtle.turnRight() end, ["reverse"] = "turnLeft"},
        ["up"] = {["command"] = function() turtle.up() end, ["reverse"] = "down"},
        ["down"] = {["command"] = function() turtle.down() end, ["reverse"] = "up"},
        ["MoveSequence"] = {}
    },
    ["current_pos"] = {["x"] = 0, ["y"] = 0, ["z"] = 0},
    ["area_to_mine"] = {["right"] = 0, ["forward"] = 0, ["up"] = 0},
    ["inventory"] = {}
}

local active = true
local turtle_menu = function ()
end
local current_pos = settings.current_pos
local movement = settings.move_resources
local move_count = 0
local inventory = settings.inventory

local function tableLength(table)
    local count = 0
    if type(table) == "table" then
        for key, value in pairs(table) do
            count = count + 1
        end
    return count
    else
        error(table, "not a table")
    end
end

-- construct pattern
-- traverse pattern
    -- https://en.wikipedia.org/wiki/Body_relative_direction
    -- y = forward, -y = backwards
    -- x = right,   -x = left
    -- z = up,      -z = down
        -- move forward/backward, proceed to next row until left/right is exhausted
-- mine predictably
-- find shortest path back
-- refuel when low on fuel
-- inventory management
-- menu mockup
    -- Specify Coordinates

io.write("input right, forward, up\n")
local xyz_answer = io.read()

local function addXYZToSettings(xyzanswer)
    local xyz_table = {}

    for i in string.gmatch(xyzanswer, "%S+") do
        table.insert(xyz_table, i)
    end

    if (tableLength(xyz_table) ~= 3) then
        error("Invalid input.")
    end

    local count = 0
    for key, value in pairs(settings.area_to_mine) do
        count = count + 1
        settings.area_to_mine[key] = xyz_table[count]
        print(key, settings.area_to_mine[key])
    end
end

addXYZToSettings(xyz_answer)
local function tunnelSegment(up_count)
    turtle.turnRight()
    for i = 1, up_count, 1 do
        if (up_count < i) then
            turtle.digUp()
        end
        turtle.dig()
        turtle.up()
    end
    turtle.turnRight()
    turtle.turnRight()
    for i = 1, up_count, 1 do
        if (up_count < i) then
            turtle.digDown()
        end
        turtle.dig()
        turtle.down()
    end
    turtle.turnRight()
    turtle.dig()
    turtle.forward()
end

for i = 1, tonumber(settings.area_to_mine["forward"]), 1 do
    tunnelSegment(tonumber(settings.area_to_mine["up"]))
end