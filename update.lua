local settings = {
    ["baseURL"] = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts/",
    ["branch"] = {"master"},
    ["flags"] = {
        ["-a"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--all", ["rel_setting"] = "scripts"},
        ["-b"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--branch", ["rel_setting"] = "branch"},
        ["-s"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--script", ["rel_setting"] = "scripts"},
        ["--all"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-a", ["rel_setting"] = "scripts"},
        ["--branch"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-b", ["rel_setting"] = "branch"},
        ["--script"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-s", ["rel_setting"] = "scripts"},
        ["--debug"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--debug", ["rel_setting"] = "debug"},
    },
    ["scripts"] = {"mine", "update"},
    ["debug"] = false,
    ["error"] = {},
    ["error_type"] = {
        ["duplicate_flag"] = function (flag) return "'" .. flag .. "'" .. " Duplicate flag found." end,
        ["invalid_flag"] = function (flag) return "'" .. flag .. "'" .. " is not a valid flag. Please type 'update' to see list of flags." end,
        ["download_error"] = function (files) return "Faild to open script '" .. files[1] .. "' at: " .. files[2] .. "." end,
        ["open_script"] = function (files) return "Faild to open script '" .. files[1] end,
        ["no_script"] = function () return "No script specified." end,
    }
}

local function debug() return settings.debug == true end
local function addError(type, arg) table.insert(settings.error, settings.error_type[type](arg)) end
local function validFlag(flag) return settings.flags[flag] ~= nil end
local function addFlagToIgnored(flag)
    settings.flags[flag].passed = true
    settings.flags[settings.flags[flag].rel_flag].passed = "ignored"
end
local function flagIgnored(flag) return settings.flags[flag].passed end
local function addArgumentToFlag(flag, arg)
    if (debug()) then
        print("addArgumentToFlag", flag, arg)
    end
    table.insert(settings.flags[flag].arguments, arg)
end

local function updateSettings()
    for key, value in pairs(settings.flags) do
        if settings.flags[key].passed == true then
            local newSettings = {}
            for i = 1, #settings.flags[key].arguments, 1 do
                if (debug()) then
                    print("updateSettings()", settings.flags[key].rel_setting, settings.flags[key].arguments[i])
                end
                table.insert(newSettings, settings.flags[key].arguments[i])
            end
            settings[settings.flags[key].rel_setting] = newSettings
        end
    end
    if settings.scripts[1] == nil then
        addError("no_script")
    end
end

local function updateScript(script)
	local scriptUrl = settings.baseURL .. "/" .. settings.branch[1] .."/" .. script .. ".lua"
    local scriptPath = shell.dir() .. "/" .. script .. ".lua"
    io.write("> Attempting to download '" .. script .. ".lua' from the " .. settings.branch[1] .. " branch.")
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
            if args[i] == "--debug" then
                settings.flags["--debug"].arguments = {true}
                settings.debug = true
            end
            if (debug()) then
                print("Valid flag Found at index: " .. i, args[i])
            end

            if flagIgnored(args[i]) then
                addError("duplicate_flag", args[i])
            end

            addFlagToIgnored(args[i])
            CurrentArg = args[i]
        elseif (CurrentArg ~= nil) then
            addArgumentToFlag(CurrentArg, args[i])
        end
    end

    if (#settings.error > 0) then
        for i = 1, #settings.error, 1 do
            error(settings.error[i])
        end
    else
        updateSettings()
        for i = 1, #settings.scripts, 1 do
            updateScript(settings.scripts[i])
        end
    end
end

if (debug()) then
    print("-Selected Scripts-")
    for i = 1, #settings.scripts, 1 do
        print("", settings.scripts[i])
    end
    print("-Selected Branch-")
    print("", settings["branch"][1])
    print("-Selected Flags-\n", "-Flag-","-Args-")
    for flagKey, flagVal in pairs(settings.flags) do
        for i = 1, #settings.flags[flagKey].arguments , 1 do
            print("", flagKey, settings.flags[flagKey].arguments[i])
        end
    end
end