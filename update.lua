local settings = {
    ["baseURL"] = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts/",
    ["default_branch"] = {"master"},
    ["branch"] = {},
    ["flags"] = {
        ["-a"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--all", ["rel_setting"] = "scripts"},
        ["-b"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--branch", ["rel_setting"] = "branch"},
        ["-s"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--script", ["rel_setting"] = "scripts"},
        ["--all"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-a", ["rel_setting"] = "scripts"},
        ["--branch"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-b", ["rel_setting"] = "branch"},
        ["--script"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-s", ["rel_setting"] = "scripts"},
        ["--debug"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--debug", ["rel_setting"] = "debug"},
        ["-v"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--version", ["rel_setting"] = ""},
        ["--version"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--version", ["rel_setting"] = ""},
    },
    ["default_scripts"] = {"mine", "update"},
    ["scripts"] = {},
    ["debug"] = false,
    ["error"] = {},
    ["error_type"] = {
        ["duplicate_flag"] = function (flag) return "'" .. flag .. "'" .. " Duplicate flag found." end,
        ["invalid_flag"] = function (flag) return "'" .. flag .. "'" .. " is not a valid flag. Please type 'update' to see list of flags." end,
        ["download_error"] = function (files) return "Faild to open script '" .. files[1] .. "' at: " .. files[2] .. "." end,
        ["open_script"] = function (files) return "Faild to open script '" .. files[1] end,
        ["no_script"] = function () return "No script specified." end,
    },
    ["version"] = "2020.7.22.1"
}

local function debug()
    return settings.debug == true
end

local function addError(type, arg)
    table.insert(settings.error, settings.error_type[type](arg))
end

local function validFlag(flag)
    return settings.flags[flag] ~= nil
end

local function addFlagToIgnored(flag)
    settings.flags[flag].passed = true
    settings.flags[settings.flags[flag].rel_flag].passed = "ignored"
end

local function flagIgnored(flag)
    return settings.flags[flag].passed
end

local function addArgumentToFlag(flag, arg)
    if (debug()) then
        print("addArgumentToFlag", flag, arg)
    end

    table.insert(settings.flags[flag].arguments, arg)
end

local function updateSettings()
    for flagString, unusedValue in pairs(settings.flags) do
        if (settings.flags[flagString].passed == true) then
            local newSettings = {}
            local argument = settings.flags[flagString].arguments

            for i = 1, #argument, 1 do
                if (debug()) then
                    print("updateSettings()", settings.flags[flagString].rel_setting, argument[i])
                end

                table.insert(newSettings, argument[i])
            end
            
            settings[settings.flags[flagString].rel_setting] = newSettings
        end
    end

    if (settings.flags["-a"].passed == true) then
        settings.scripts = settings.default_scripts
    end

    if (settings.flags["-b"].passed == false) then
        settings.branch = settings.default_branch
    end
end

local function updateScript(script)
	local scriptUrl = settings.baseURL .. "/" .. settings.branch[1] .."/" .. script .. ".lua"
    local scriptPath = shell.dir() .. "/" .. script .. ".lua"
    io.write("> Attempting to download '" .. script .. ".lua' from the " .. settings.branch[1] .. " branch.\n")
	local remoteScript = http.get(scriptUrl)
    local localScript = fs.open(scriptPath, "w")
    
    if not remoteScript then
		addError("download_error", {script, scriptUrl})
    end

	if not localScript then
		addError("open_script", scriptPath .. script)
	end

	localScript.write(remoteScript.readAll())
	localScript.close()
end

local args = {...}
if (#args == 0) then
    io.write("Usage:\nupdate <options> <scripts>\nOptions/flags:\n-a --all : Updates all scripts.\n-b --branch <branch-name>\n-s --script <script1,script2>\n")

else
    for i = 1, #args, 1 do
        if (settings.flags[args[i]] == nil and string.match(args[i], '^%-')) then
            addError("invalid_flag", args[i])
        end

        if (validFlag(args[i])) then
            if (args[i] == "--debug") then
                settings.flags["--debug"].arguments = {true}
                settings.debug = true
            end

            if (args[i] == "-v" or args[i] == "--version") then
                settings.flags["-v"].arguments = {true}
                settings.flags["--version"].arguments = {true}
                print("v" .. settings.version)
            end

            if (debug()) then
                print("Valid flag Found at index: " .. i, args[i])
            end

            if (flagIgnored(args[i])) then
                addError("duplicate_flag", args[i])
            end

            addFlagToIgnored(args[i])
            CurrentArg = args[i]
            
        elseif (CurrentArg ~= nil) then
            addArgumentToFlag(CurrentArg, args[i])
        end
    end
    
    updateSettings()

    if (settings.scripts[1] == nil and "-v" == false) then
        addError("no_script")
    end

    if (#settings.error > 0) then
        for i = 1, #settings.error, 1 do
            error(settings.error[i])
        end
    else
        for i = 1, #settings.scripts, 1 do
            updateScript(settings.scripts[i])
        end
    end
end

if (debug()) then
    io.write("- Selected Scripts:\t")
    for i = 1, #settings.scripts, 1 do
        io.write(settings.scripts[i] .. " ")
    end
    io.write("\n- Selected Branch:\t", settings["branch"][1])
    io.write("\n- Selected Flags -\n", "-Flag-\t" .. "-Args-\n")
    for FlagString, unusedValue in pairs(settings.flags) do
        for i = 1, #settings.flags[FlagString].arguments , 1 do
            print("", FlagString, settings.flags[FlagString].arguments[i])
        end
    end
end