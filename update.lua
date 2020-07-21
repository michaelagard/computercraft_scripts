Settings = {
    ["arguments"] = {},
    ["baseURL"] = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts",
    ["branch"] = "master",
    ["scripts"] = {"mine", "update"},
    ["debug"] = true
}

-- arg parse code

local args = {...}
if (#args == 0) then
    io.write("Usage:\nupdate <options> <scripts>\nOptions:\n-a --all : Updates all scripts.\n-b --branch <branch-name>\n-s --script <script1,script2>\n")
else
    for i = 1, #args, 1 do
        if (args[i] == "-b") then
            Settings.branch = args[i+1]
        end

        if (args[i] == "-s") then
            ScriptTable = {}
            for j = i, #args, 1 do
                if string.find(args[j], "-") then
                    break
                else
                    ScriptTable[i] = args[i]
                end
            end

            Settings.scripts = ScriptTable
        end
    end
end

--debug code

if (Settings["debug"]) then
    print("        -Scripts-")
    for i = 1, #Settings.scripts, 1 do
        print(Settings.scripts[i])
    end
    print("        -Branch-")
    print(Settings["branch"])
    print("        -Args-")
    for ArgCount = 1, #args, 1 do
        print(args[ArgCount])
    end
end