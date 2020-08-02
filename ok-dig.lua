local message = ""
local count = 0
local wait_string = "I'm waiting on a block to mine!"
local term_string = "Hold CTRL+T to terminate this program."
local current_fuel = "Current Fuel: " .. turtle.getFuelLevel()
local mined_blocks = {}



local function addCountToBlock(count, block)
    if (mined_blocks[block] == nil) then
        table.insert(mined_blocks, block)
        mined_blocks[block] = count
    else
        mined_blocks[block] = mined_blocks[block] + count
    end
end

local function writeMinedBlocks()
    if mined_blocks == {} then
        return "No blocks have been mined."
    else
        io.write("Blocks Mined:\n")
        for block, count in pairs(mined_blocks) do
            io.write(block .. ": " .. count .. "\n")
        end
    end
end

while true do
    local success, block_data = turtle.inspect()
    local inspected_block = block_data.name
    term.setCursorPos(1,1)
    term.clear()
    io.write(message)
    if (success == true) then
        message = inspected_block .. " found!"
        turtle.dig()
        addCountToBlock(1, inspected_block)
    else
        message = wait_string .. "\n" .. term_string .. "\n" .. current_fuel
    end
    writeMinedBlocks()
end