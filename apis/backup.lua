
local function handleArguments(arguments, valid_argument_table)
    local argument_table = {} -- a collection of passed arguments
    local passed_arguments_table = {} -- used to easily check passed arguments
    local current_valid_argument = "" -- current argument to add options to

    for i = 1, #arguments do
        -- check if passed argument exists in valid_argument_table
        if isValidArgument(arguments[i], valid_argument_table) then
            -- check if passed argument has not been passed
            if not(hasArgumentPassed(arguments[i], passed_arguments_table, valid_argument_table)) then
                argument_table[arguments[i]] = {}
                table.insert(passed_arguments_table, arguments[i])
                current_valid_argument = arguments[i]
            end
        -- check if current_valid_argument isn't empty and is a 
        elseif (current_valid_argument ~= nil) then

            if valid_argument_table[current_valid_argument].accepts_options == true then
                argument_table[current_valid_argument][arguments[i]] = true
            else
                error(current_valid_argument .. " does not accept options.")
            end
        else
            
            error(arguments[i] .. " is not a valid option for " .. current_valid_argument)
        end
    end

    for arg_key, arg_value in pairs(argument_table) do
            validateOptions(arg_key, argument_table[arg_key], valid_argument_table)
    end
    print(textutils.serialise(argument_table))
    return argument_table
end