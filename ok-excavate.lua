local args = {...}


local settings = {
    --uses body relative directions 0 = +y | 1 = +x | 2 = -y | 3 = -x
    ["arg_x"] = 1,      --right/left
    ["arg_y"] = 1,      --forward/backwards
    ["arg_z"] = 1,      --up/down
    ["current_pos"] = {
        ["x"] = 0,
        ["y"] = 0,
        ["z"] = 0,
    },
    ["move_count"] = 0,
    ["current_face"] = 0,   -- 0 = +y | 1 = +x | 2 = -y | 3 = -x
    ["dig_count"] = 0,
    ["debug_mode"] = true,
    ["sim_mode"] = turtle == nil
            
}

local time = os.time()
local formatted_24_hour_time = "[" .. textutils.formatTime(time, true) .. "] "


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

local function handleArguments()
    if tableLength(args) > 0 then
    for i = 1, tableLength(args), 1 do
        if (type(tonumber(args[i])) == "number") then
            if (i == 1) then
                settings.arg_y = tonumber(args[i])
            elseif (i == 2) then
                settings.arg_x = tonumber(args[i])
            elseif (i == 3) then
                settings.arg_z = tonumber(args[i])
            else
                error("too many arguments")
            end
        else
            error("argument is not a number.")
        end
    end 
    else
        print("Usage: ok-excavate [y] [x] [z]\n[y] - fowards | [x] left | [z] down")
    end
end


local function move(direction)
    if (direction == "forward") then
        if (settings.current_face == 0) then
            settings.current_pos.y = settings.current_pos.y + 1
        elseif (settings.current_face == 1) then
            settings.current_pos.x = settings.current_pos.x + 1
        elseif (settings.current_face == 2) then
            settings.current_pos.y = settings.current_pos.y - 1
        elseif (settings.current_face == 3) then
            settings.current_pos.x = settings.current_pos.x - 1
        end
        if (settings.sim_mode == false) then
            turtle.forward()
        end
    elseif (direction == "back") then
        if (settings.current_face == 0) then
            settings.current_pos.y = settings.current_pos.y - 1
        elseif (settings.current_face == 1) then
            settings.current_pos.x = settings.current_pos.x - 1
        elseif (settings.current_face == 2) then
            settings.current_pos.y = settings.current_pos.y + 1
        elseif (settings.current_face == 3) then
            settings.current_pos.x = settings.current_pos.x + 1
        end

        if (settings.sim_mode == false) then
            turtle.back()
        end
    elseif (direction == "turnRight") then
        if (settings.current_face == 3) then
            settings.current_face = 0
        else
            settings.current_face = settings.current_face + 1
        end
        if (settings.sim_mode == false) then
            turtle.turnRight()
        end
    elseif (direction == "turnLeft") then
        if (settings.current_face == 0) then
            settings.current_face = 3
        else
            settings.current_face = settings.current_face - 1
        end
        if (settings.sim_mode == false) then
            turtle.turnLeft()
        end
    elseif (direction == "up") then
        settings.current_pos.z = settings.current_pos.z + 1
        if (settings.sim_mode == false) then
            turtle.up()
        end
    elseif (direction == "down") then
        settings.current_pos.z = settings.current_pos.z - 1
        if (settings.sim_mode == false) then
            turtle.down()
        end
    else
        error("'" .. direction .. "' is not a valid direction.")
    end

    local formatted_current_pos = "[" .. settings.current_pos.x .. "," .. settings.current_pos.y .. "," .. settings.current_pos.z .. "] "
    local formatted_current_face = "F" .. settings.current_face .. " "
    
    if (settings.debug_mode == true) then
        print(formatted_24_hour_time .. formatted_current_pos .. formatted_current_face .. direction)
    end
end

local function dig(direction)
    if (direction == "forward") then
        if (settings.sim_mode == false) then
            if (turtle.detect()) then
                settings.dig_count = settings.dig_count + 1
                turtle.dig()
            end
        else
            settings.dig_count = settings.dig_count + 1
        end
        if settings.debug_mode == true then
            -- print(formatted_24_hour_time .. "Digging " .. direction .. ".")
        end
    end
    if (direction == "down") then
        if (settings.sim_mode == false) then
            if (turtle.detectDown()) then
                settings.dig_count = settings.dig_count + 1
                turtle.digDown()
            end
        else
            settings.dig_count = settings.dig_count + 1
        end
        if settings.debug_mode == true then
            print(formatted_24_hour_time .. "Digging " .. direction .. ".")
        end
    end
end



local function excavate(x, y, z)
    for i_z = 1, z, 1 do
        if i_z > 1 then
            dig("down")
            move("down")
            move("turnRight")
            move("turnRight")
        end
        for i_x = 1, x, 1 do
            for i_y = 2, y, 1 do
                dig("forward")
                move("forward")
            end
            if (x > 1 and i_x < x) then
                if (i_z % 2 == 0 or i_z == 1) then
                    if not(i_x % 2 == 0) then
                        move("turnRight")
                        dig("forward")
                        move("forward")
                        move("turnRight")
                    else
                        move("turnLeft")
                        dig("forward")
                        move("forward")
                        move("turnLeft")
                    end
                else
                    if (i_x % 2 == 0) then
                        move("turnRight")
                        dig("forward")
                        move("forward")
                        move("turnRight")
                    else
                        move("turnLeft")
                        dig("forward")
                        move("forward")
                        move("turnLeft")
                    end
                end
            end
        end
    end
end

local function returnToStart()

end

handleArguments()
excavate(settings.arg_x, settings.arg_y, settings.arg_z)