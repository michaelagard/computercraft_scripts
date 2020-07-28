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
        return 0
    end
end

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

local function traversePath()
    if move_count ~= movement.forward then
        movement["forward"].command()        
    end
    move_count = move_count + 1
end

local function fakeTraversePath()
    if move_count ~= movement.forward then
        movement["forward"].command()
    -- else
    --     break
    end
    move_count = move_count + 1
end

while (move_count <= 100) do
    move_count = move_count + 1
    if move_count <= tonumber(settings.area_to_mine.forward) then
        traversePath()
    else
        break
    end
end