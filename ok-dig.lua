local message = ""
local count = 0
local wait_string = "STATUS: Observing.\n"
local term_string = "Hold CTRL+T to terminate.\n"
local current_fuel = "Current Fuel: " .. turtle.getFuelLevel() .. "\n"
local mined_blocks = {}

local function addCountToBlock(count, raw_block)
    local formatted_block_name = string.match(raw_block, "(:.*)")
    if (mined_blocks[formatted_block_name] == nil) then
        table.insert(mined_blocks, formatted_block_name)
        mined_blocks[formatted_block_name] = count
    else
        mined_blocks[formatted_block_name] = mined_blocks[formatted_block_name] + count
    end
end

local function formattedBlockTable(block_table)
    local formatted_block_table = {}
    for block_name, block_count in pairs(block_table) do
        table.insert(formatted_block_table, block_name .. ": " .. tostring(block_count))
    end
    return formattedBlockTable
end

local function writeMinedBlocks()
    local return_message = ""
    if #mined_blocks < 1 then
        return_message ="No blocks have been mined."
    else
        return_message = table.concat(formattedBlockTable(mined_blocks), "\n")
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
        message = wait_string .. term_string .. current_fuel .. "Blocks mined:\n" .. writeMinedBlocks()
    end
end