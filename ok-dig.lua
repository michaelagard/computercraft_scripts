local args = {...}
local mined_count = 0
local message = ""
local wait_string = "STATUS: Observing.\n"
local term_string = "Hold CTRL+T to terminate.\n"
local mined_blocks = {}

local current_directory = shell.resolve("")
os.loadAPI(current_directory .. "/apis/tabletools")

local function addCountToBlock(block_name)
    local formatted_block_name = string.match(block_name, ":.*"):sub(2):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end):gsub("_", " ")

    if (mined_blocks[formatted_block_name] == nil) then
        mined_blocks[formatted_block_name] = 1
    else
        mined_blocks[formatted_block_name] = mined_blocks[formatted_block_name] + 1
    end
end

local function formattedBlockTable(block_table)
    local formatted_block_table = {}
    for block_name, block_count in pairs(block_table) do
        table.insert(formatted_block_table, block_name .. ": " .. tostring(block_count))
    end
    return formatted_block_table
end

local function writeMinedBlocks()
    local return_message = ""
    if not(mined_blocks == nil) then
        if tabletools.length(mined_blocks) < 1 then
            return_message ="No blocks have been mined."
        else
            return_message = "Blockes Mined:\n" .. table.concat(formattedBlockTable(mined_blocks), "\n")
        end
    end
    return return_message
end

if not(type(args[1]) == "number") then
    args[1] = 1000000
end

while mined_count < tonumber(args[1]) do
    if args[1] == "--help" or args[1] == "-h" then
        io.write("Usage: ok-dig [ammount to dig]\nAmount defaults to 1000000.")
        break
    end
    local success, block_data = turtle.inspect()
    local inspected_block = block_data.name
    term.setCursorPos(1,1)
    term.clear()
    io.write(message)
    if (success == true) then
        message = inspected_block .. " found!"
        turtle.dig()
        addCountToBlock(inspected_block)
        mined_count = mined_count + 1
    else
        message = wait_string .. term_string  .. writeMinedBlocks()
    end
end