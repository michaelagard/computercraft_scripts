local settings = {
    ["baseURL"] = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts",
    ["branch"] = "master",
    ["flags"] = {
        ["-a"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--all"},
        ["-b"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--branch"},
        ["-s"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "--script"},
        ["--all"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-a"},
        ["--branch"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-b"},
        ["--script"] = {["arguments"] = {}, ["passed"] = false, ["rel_flag"] = "-s"},
    },
    ["scripts"] = {"mine", "update"},
    ["debug"] = true,
    ["error"] = {},
    ["error_type"] = {
        ["duplicate_flag"] = function (flag) return "ERROR: " .. "'" .. flag .. "'" .. " Duplicate flag found." end,
        ["invalid_flag"] = function (flag) return "ERROR: " .. "'" .. flag .. "'" .. " is not a valid flag. Please type 'update' to see list of flags." end
    }
}

-- helper functions

local function debug()
    return settings.debug == true
end

local function addError(type, flag) table.insert(settings.error, settings.error_type[type](flag)) end

local function validFlag(flag) return settings.flags[flag] ~= nil end

local function addFlagToIgnored(flag)
    settings.flags[flag].passed = true
    settings.flags[settings.flags[flag].rel_flag].passed = true
end

local function flagIgnored(flag) return settings.flags[flag].passed end

local function addArgumentToFlag(flag, arg)
    if (debug()) then
        print("addArgumentToFlag", arg, flag)
    end
    table.insert(settings.flags[flag].arguments, arg)
end

local function updateSettings(setting, arg)
    for key, value in pairs(settings.flags) do
        -- if settings.flag[key].arguments ~= nil then
        --     for i = 1, #settings.flag[key].arguments do
        --         print(settings.flags[key].arguments[i])
        --     end
        -- end
    end
end

-- arg parse code

local args = {...}
if (#args == 0) then
    io.write("Usage:\nupdate <options> <scripts>\nOptions/flags:\n-a --all : Updates all scripts.\n-b --branch <branch-name>\n-s --script <script1,script2>\n")
else
    for i = 1, #args, 1 do
        if (settings.flags[args[i]] == nil and string.match(args[i], '^%-')) then
            addError("invalid_flag", args[i])
        end

        if (validFlag(args[i])) then
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
end








if (settings.error[1] ~= nil) then
    for i = 1, #settings.error, 1 do
        print(settings.error[i])
    end
else
    updateSettings()
    if (debug()) then
        print("-Selected Scripts-")
        for i = 1, #settings.scripts, 1 do
            print(settings.scripts[i])
        end
        print("-Selected Branch-")
        print(settings["branch"])
        print("-Flag-","-Args-")
        for flagKey, flagVal in pairs(settings.flags) do
            for i = 1, #settings.flags[flagKey].arguments , 1 do
                print(flagKey, settings.flags[flagKey].arguments[i])
            end
        end
    end
end
-- for key, value in pairs(Settings.flags["-s"]) do
--     print(key, value)
-- end
        --         if (string.match(args[j], '^%-')) then
