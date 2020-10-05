local args = {...}
-- example valid_argument table
local valid_arguments = {
    ["-?"] = {
        ["synonymous_arguments"] = {"--help", "-h"},
        ["accepts_options"] = false,
        ["maximum_options"] = 0,
        ["minimum_options"] = 0,
        ["data_type"] = nil -- string / integer
    },
    ["-v"] = {
        ["synonymous_arguments"] = {"--version"},
        ["accepts_options"] = false,
        ["maximum_options"] = 0,
        ["minimum_options"] = 0,
        ["data_type"] = nil -- string / integer
    },
    ["-s"] = {
        ["synonymous_arguments"] = {"--script"},
        ["accepts_options"] = true,
        ["maximum_options"] = 12,
        ["minimum_options"] = 1,
        ["data_type"] = nil -- string / integer
    },
    ["-a"] = {
        ["synonymous_arguments"] = {"--all"},
        ["accepts_options"] = false,
        ["maximum_options"] = 0,
        ["minimum_options"] = 0,
        ["data_type"] = nil -- string / integer
    },
    ["--debug"] = {
        ["synonymous_arguments"] = {},
        ["accepts_options"] = false,
        ["maximum_options"] = 0,
        ["minimum_options"] = 0,
        ["data_type"] = nil -- string / integer
    }
}

local function constructPassedArgumentTable(passed_arguments)
    local constructed_passed_argument_table = {}
    local current_argument

    for i_arg = 1, #passed_arguments do

        if string.match(passed_arguments[i_arg], "^%-") then
            current_argument = passed_arguments[i_arg]

            if constructed_passed_argument_table[current_argument] == nil then
                print("Current Argument: '" .. current_argument .. "'.")
                constructed_passed_argument_table[current_argument] = {}
            else
                error("Duplicate argument found: '" .. current_argument .. "'.")
            end
        else
            local current_option = passed_arguments[i_arg]
            print("Adding '" .. current_option .. "' to '" .. current_argument)
            constructed_passed_argument_table[current_argument][current_option] = true
        end
    end
    
    return constructed_passed_argument_table
end

local function constructNestedArgumentSet(valid_argument_table)
    local return_nested_argument_set = {}
    for arg_key, arg_value in pairs(valid_argument_table) do
        return_nested_argument_set[arg_key] = {}
        for i_arg = 1, #valid_argument_table[arg_key].synonymous_arguments do
            return_nested_argument_set[arg_key][valid_argument_table[arg_key].synonymous_arguments[i_arg]] = true
        end
    end
    return return_nested_argument_set
end

local function areArgumentsValid(passed_argument_table, valid_nested_argument_set)
    for arg_key, arg_value in pairs(passed_argument_table) do
        for valid_arg_key, valid_arg_value in pairs(valid_nested_argument_set) do
            if (valid_nested_argument_set[valid_arg_key][arg_key] == nil) then
                error("Invalid argument '" .. arg_key .. "'.")
            end
        end
    end
end


local function checkForDuplicateArguments(passed_argument_table, valid_nested_argument_set)
    local temp_check_table = {}
    print(textutils.serialise(passed_argument_table))
    for arg_key, arg_value in pairs(passed_argument_table) do
        local current_argument = arg_key
        for valid_arg_key, valid_arg_value in pairs(valid_nested_argument_set) do
        end
    end
end

-- before validation, create nested set / key table of all arguments and options
-- iterate through arguments and check if they exist in the nested set / key table
-- check if argument exists in another form in the synonymous table and root
-- iterate through options and check if they pass the rules of the valid_argument_table
-- return formatted argument_table

local function handleArguments(arguments, valid_argument_table)
    local return_table = {}
    local passed_argument_table = constructPassedArgumentTable(arguments)
    -- print(textutils.serialise(passed_argument_table))
    local valid_nested_argument_set = constructNestedArgumentSet(valid_argument_table)
    print(textutils.serialise(valid_nested_argument_set))
    areArgumentsValid(passed_argument_table, valid_nested_argument_set)
    checkForDuplicateArguments(passed_argument_table, valid_nested_argument_set)
    return return_table
end

handleArguments(args, valid_arguments)