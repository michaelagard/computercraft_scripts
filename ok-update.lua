local settings = {
    ["base_repository_url"] = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts",
    ["default_branch"] = {"master"},
    ["default_scripts"] = {"ok-update", "ok-dig", "ok-excavate", "ok-branchmine"},
    ["branch"] = {},
    ["scripts"] = {},
    ["flags"] = {
        ["-b"] = {["arguments"] = {}, ["passed"] = false, ["verbose_flag"] = "--branch", ["related_settings"] = "branch"},
        ["-s"] = {["arguments"] = {}, ["passed"] = false, ["verbose_flag"] = "--script", ["related_settings"] = "scripts"},
        ["-a"] = {["passed"] = false, ["verbose_flag"] = "--all", ["related_settings"] = "scripts"},
        ["-v"] = {["passed"] = false, ["verbose_flag"] = "--version"},
        ["--debug"] = {["passed"] = false},
    },
    ["usage_string"] = "Usage: update [options...]\nFlags:\n-a --all: Updates default scripts.\n-b --branch <branch-name>\n-s --script <script1,script2>\n-v --version: Displays version number.",
    ["version"] = "2020.7.24.1",
}

local errors = {
        ["duplicate_flag"] = function (flag) return "'" .. flag .. "'" .. " is a duplicate flag." end,
        ["invalid_flag"] = function (flag) return "'" .. flag .. "'" .. " is not a valid flag. Type 'update' to see list of flags." end,
        ["open_script"] = function (files) return "Faild to open script '" .. files[1]"." end,
        ["no_script"] = function () return "No script specified." end,
        ["conflicting_flag"] = function (flags) return "Cannot use the flag " .. flags[1] .. " with " .. flags[2] .. "." end,
        ["failed_opening_script"] = function (file) return "Failed opening script" end,
        ["download_error"] = function (file) return "404: " .. file .. " not found." end,
        ["flag_cannot_have_arguments"] = function (flag) return "`" .. flag .. "` cannot take arguments." end,
        ["no_flag_set"] = function (flag) return "`" .. flag .. "` cannot be applied without a flag." end,
}

local args = {...}
local valid_flag_table = settings.flags

local function debugMode() return settings.flags["--debug"].passed end

local function stdoutError(err, args)
    term.setTextColor(colors.red)
    print("Error: " .. errors[err](args))
end

local function tableLength(table)
    local count = 0
    if type(table) == "table" then
        for key, value in pairs(table) do
            count = count + 1
        end
    return count
    else
        return 0
    end
end

local function findAbbreviatedFlag(verbose_flag)
    for abbreviated_flag, table in pairs(valid_flag_table) do
        if (valid_flag_table[abbreviated_flag].verbose_flag == verbose_flag) then
            return abbreviated_flag
        end
    end
    return verbose_flag
end

local function isValidAbbreviatedFlag(param)
    return valid_flag_table[param] ~= nil
end

local function isValidVerboseFlag(param)
    for abbreviated_flag, table in pairs(valid_flag_table) do
        if (valid_flag_table[abbreviated_flag].verbose_flag == param) then return true end
    end
    return false
end

local function isValidFlag(param)
    return isValidAbbreviatedFlag(param) or isValidVerboseFlag(param)
end

local function setFlagToPassed(abbreviated_flag, argument_index)
    valid_flag_table[abbreviated_flag].passed = true
    if (debugMode()) then print(argument_index, "setFlagToPassed()", abbreviated_flag) end
end

local function hasFlagBeenPassed(valid_flag)
    return valid_flag_table[findAbbreviatedFlag(valid_flag)].passed
end

local function flagCanHaveArguments(valid_flag)
    return valid_flag_table[findAbbreviatedFlag(valid_flag)].arguments ~= nil
end


local function addArgumentToFlag(abbreviated_flag, argument, argument_index)
    table.insert(valid_flag_table[abbreviated_flag].arguments, argument)
    if (debugMode()) then
        print(argument_index, "addArgumentToFlag()", abbreviated_flag, argument)
    end
end

local function updateSettings(flag, arguments)
    if (settings.flags[flag].related_settings ~= nil) then
        if (debugMode()) then
            print("updateSettings()", flag, arguments)
        end
        settings[settings.flags[flag].related_settings] = arguments
    end
end

local function handleArguments(args_table)
    local current_flag = ""

    for argument_index = 1, tableLength(args_table), 1 do
        local current_argument = args_table[argument_index]
        -- checks for valid flag
        if (isValidFlag(current_argument)) then
            local current_abbreviated_argument = findAbbreviatedFlag(current_argument)
            -- checks if valid flag has been pasesd
            if (hasFlagBeenPassed(current_abbreviated_argument) == false) then
                if (current_argument == "-a" or current_argument == "--all") then

                    if (settings.flags["-s"].passed == true) then
                        error(stdoutError("conflicting_flag", {current_argument, "-s or --script"}))
                    end
                end

                setFlagToPassed(current_abbreviated_argument, argument_index)
                current_flag = current_argument
            else
                error(stdoutError("duplicate_flag", current_argument))
            end
        --checks if current_argument starts with a hyphen and if it's not a valid flag
        elseif (string.match(current_argument, '^%-')) then
            error(stdoutError("invalid_flag", current_argument))
        -- checks if current_flag is empty
        elseif (current_flag == "") then
            error(stdoutError("no_flag_set", current_argument))
        -- checks if the current flag can have arguments
        elseif (flagCanHaveArguments(current_flag)) then
                addArgumentToFlag(findAbbreviatedFlag(current_flag), current_argument, argument_index)
        else
            error(stdoutError("flag_cannot_have_arguments", current_flag))
        end
    end
    for flag, value in pairs(valid_flag_table) do
        if hasFlagBeenPassed(findAbbreviatedFlag(flag)) then
            updateSettings(flag, valid_flag_table[flag].arguments)
        end
    end

    if tableLength(settings.scripts) == 0 then
        settings.scripts = settings.default_scripts
    end
    if tableLength(settings.branch) == 0 then
        settings.branch = settings.default_branch
    end
    if (valid_flag_table["-v"].passed == true) then
        print(settings.version)
        return
    end
    if tableLength(args_table) == 0 then
        print(settings.usage_string)
        return
    end
    Arguments_Handled = true
end

local function confirmContinue()
    term.setTextColor(colors.yellow)
    io.write("- Selected Scripts:\t")
    term.setTextColor(colors.orange)
    for script = 1, tableLength(settings.scripts), 1 do
        if (tableLength(settings.scripts) ~= script) then
            io.write(tostring(settings.scripts[script]) .. ", ")
        else
            io.write(tostring(settings.scripts[script]))
        end
    end
    term.setTextColor(colors.yellow)
    io.write("\n- Selected Branch:\t\t")
    term.setTextColor(colors.orange)
    io.write(settings.branch[1] or "")

    term.setTextColor(colors.white)
    io.write("\nConfirm settings? (y/N) : ")
    local answer=io.read()
    if answer:match("[yY]") then
        return true
    elseif (answer:match("[nN]") or answer == "") then
        print("Aborting script.")
        return false
    else
        print("Invalid response.")
        return false
    end
end

local function updateScript(scriptName)
	local scriptUrl = settings.base_repository_url .. "/" .. settings.branch[1] .."/" .. scriptName .. ".lua"
	local scriptPath = shell.dir() .. "/" .. scriptName .. ".lua"
	print("> " .. scriptPath .. "...")

    local remoteScript = http.get(scriptUrl)
    
	if not remoteScript then
        error(stdoutError("failed_opening_script", scriptPath))
	end

	local localScript = fs.open(scriptPath, "w")
	if not localScript then
        error(stdoutError("failed_opening_script", scriptPath))
	end
	localScript.write(remoteScript.readAll())
	localScript.close()
end

handleArguments(args)

if (Arguments_Handled == true) then
    if (debugMode()) then
        term.setTextColor(colors.orange)
        io.write("* Selected Scripts:\t")
        for i = 1, tableLength(settings.scripts), 1 do
            io.write(settings.scripts[i] .. " ")
        end
        io.write("\n* Selected Branch:\t\t" ..  (settings.branch[1] or ""))
        io.write("\n* Argument List")
        for FlagString, unusedValue in pairs(settings.flags) do
            if (flagCanHaveArguments(FlagString) and valid_flag_table[FlagString].arguments[1] ~= nil) then
                io.write("\n" .. FlagString .. ": ")
                for i = 1, tableLength(settings.flags[FlagString].arguments) , 1 do
                    if (settings.flags[FlagString].arguments ~= {}) then
                        if (tableLength(settings.flags[FlagString].arguments) ~= i) then
                            io.write(tostring(settings.flags[FlagString].arguments[i]) .. ", ")
                        else
                            io.write(tostring(settings.flags[FlagString].arguments[i]))
                        end
                    end
                end
            end
        end
    io.write("\n")
    end
    if confirmContinue() then
        for i = 1, tableLength(settings.scripts), 1 do
            updateScript(settings.scripts[i])
        end
    end        
end