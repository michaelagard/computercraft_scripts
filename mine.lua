term.setBackgroundColor(colors.blue)

Running = true

MoveResources = {
    ["forward"] = {["command"] = function() turtle.forward() end, ["count"] = 0, ["reverse"] = "back"},
    ["back"] = {["command"] = function() turtle.back() end, ["count"] = 0, ["reverse"] = "forward"},
    ["turnLeft"] = {["command"] = function() turtle.turnLeft() end, ["count"] = 0, ["reverse"] = "turnRight"},
    ["turnRight"] = {["command"] = function() turtle.turnRight() end, ["count"] = 0, ["reverse"] = "turnLeft"},
    ["up"] = {["command"] = function() turtle.up() end, ["count"] = 0, ["reverse"] = "down"},
    ["down"] = {["command"] = function() turtle.down() end, ["count"] = 0, ["reverse"] = "up"},
    ["MoveSequence"] = {}
}

TurtleInventory = {}

function Move(direction, count)
    for i = 1, count, 1 do
        MoveResources[direction].command()
        AddMoveSequence(direction)
        AddDirectionCount(direction)
    end
end

function AddDirectionCount(direction)
    MoveResources[direction].count = MoveResources[direction].count + 1
end

function AddMoveSequence(direction)
    table.insert(MoveResources.MoveSequence, direction)
end

function SimpleReturnToStart()
    for i = #MoveResources.MoveSequence, 1, -1 do
        Move(MoveResources[MoveResources.MoveSequence[i]]["reverse"])
    end
end

function FuelLevel()
    return turtle.getFuelLevel()
end

function Refuel(count)
    turtle.refuel(count)
end

function ShouldRefuel()
    if (FuelLevel() < #MoveResources.MoveSequence + 5) then
        return true
    else
        return false
    end
end

function SimpleRefuelSequence()
    SimpleReturnToStart()
    Refuel()
end

function ScanEntireSelfInventory()
    for i = 1, 16, 1 do
        local item = turtle.getItemDetail()
        turtle.select(i)
        if (not(data == nil)) then
            TurtleInventory[i] = {["name"] = item.name, ["damage_value"] = item.damage, ["count"] = item.count}
            print(TurtleInventory[i].name, TurtleInventory[i].damage_value, TurtleInventory[i].count)
        end
    end
end

function ScanCurrentInventorySlot()
    local item = turtle.getItemDetail()
end

ScanEntireSelfInventory()