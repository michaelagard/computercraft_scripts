-- example valid_argument_table
-- local valid_arguments = {
--     ["-?"] = {
--         ["synonymous"] = {"--help", "-h"},
--         ["accepts_options"] = false
--     },
--     ["-v"] = {
--         ["synonymous"] = {"--version"},
--         ["accepts_options"] = false
--     },
--     ["-s"] = {
--         ["synonymous"] = {"--script"},
--         ["accepts_options"] = true
--     }
-- }

local function findSynonymousArguments(argument, valid_argument_table)
    local synonymous_arguments = {}

    if (valid_argument_table[argument] == nil) then

        for arg_key, arg_value_unused in pairs(valid_argument_table) do

            for i = 1, #valid_argument_table[arg_key].synonymous, 1 do

                if valid_argument_table[arg_key].synonymous[i] == argument then

                    for j = 1, #valid_argument_table[arg_key].synonymous, 1 do
                        table.insert(synonymous_arguments, valid_argument_table[arg_key].synonymous[j])
                    end
                    table.insert(synonymous_arguments, arg_key)
                end
            end
        end
    else

        for i = 1, #valid_argument_table[argument].synonymous, 1 do
            table.insert(synonymous_arguments, valid_argument_table[argument].synonymous[i])
        end
    end

    return synonymous_arguments
end

local function isValidArgument(argument, valid_argument_table)
    
    if (valid_argument_table[argument]) then
        return true
    else
        
        local synonymous_table = findSynonymousArguments(argument, valid_argument_table)
        for i = 1, #synonymous_table, 1 do
            if (synonymous_table[i] == argument) then
                return true
            end
        end
    end

    return false
end



local function hasArgumentPassed(passed_argument, passed_argument_table, valid_argument_table)

    if not(passed_argument_table[passed_argument] == nil) then
        error("Duplicate argument '" .. passed_argument .. "' found.")
    end
    
    local synonymous_table = findSynonymousArguments(passed_argument, valid_argument_table)

    for i = 1, #synonymous_table do
        for j = 1, #passed_argument_table do

            if synonymous_table[i] == passed_argument_table[j] then
                error("Duplicate argument '" .. passed_argument .. "' found.")
            end
        end
    end

    return false
end



local function handleArguments(arguments, valid_argument_table)
    local argument_table = {}
    local passed_arguments_table = {}
    local current_valid_argument = ""

    for i = 1, #arguments do

        if isValidArgument(arguments[i], valid_argument_table) and not(hasArgumentPassed(arguments[i], passed_arguments_table, valid_argument_table)) then
            argument_table[arguments[i]] = {}
            table.insert(passed_arguments_table, arguments[i])
            current_valid_argument = arguments[i]

        elseif not(current_valid_argument == nil) and valid_argument_table[current_valid_argument] then

            if valid_argument_table[current_valid_argument].accepts_options == true then
                table.insert(argument_table[current_valid_argument], arguments[i])
            else
                error(current_valid_argument .. " does not accept options.")
            end
        else
            
            error(arguments[i] .. " is not a valid option for " .. current_valid_argument)
        end
    end

    return argument_table
end