local message = ""
local count = 0
local wait_string = "STATUS: Observing.\n"
local term_string = "Hold CTRL+T to terminate.\n"
local current_fuel = "Current Fuel: " .. turtle.getFuelLevel() .. "\n"
local mined_blocks = {}

local function addCountToBlock(count, block)
    if (mined_blocks[block] == nil) then
        table.insert(mined_blocks, block)
        mined_blocks[block] = count
    else
        mined_blocks[block] = mined_blocks[block] + count
    end
    print("added ", block, "+1")
end

local function writeMinedBlocks()
    local return_message = ""
    if #mined_blocks < 1 then
        return_message ="No blocks have been mined."
    else
        io.write("Blocks Mined:")
        return_message = table.concat(mined_blocks, "\n")
    end
    return return_message
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
        message = wait_string .. term_string .. current_fuel .. writeMinedBlocks()
    end
end