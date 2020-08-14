Move = {
    ["forward"] = {["command"] = function() turtle.forward(); Move.forward.count = Move.forward.count + 1; end, ["count"] = 0, ["reverse"] = "back"},
    ["back"] = {["command"] = function() turtle.back() end, ["count"] = 0, ["reverse"] = "forward"},
    ["turnLeft"] = {["command"] = function() turtle.turnLeft() end, ["count"] = 0, ["reverse"] = "turnRight"},
    ["turnRight"] = {["command"] = function() turtle.turnRight() end, ["count"] = 0, ["reverse"] = "turnLeft"},
    ["up"] = {["command"] = function() turtle.up() end, ["count"] = 0, ["reverse"] = "down"},
    ["down"] = {["command"] = function() turtle.down() end, ["count"] = 0, ["reverse"] = "up"},
    ["MoveSequence"] = {}
}

