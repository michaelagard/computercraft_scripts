BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Settings = {
    ["arguments"] = nil,
    ["branch"] = "master",
    ["scripts"] = {"mine", "update"},
    ["debug"] = true
}

-- check args
-- example commands:
-- update -a / update --all
-- update -s
-- update -b master all
-- update -b dev -s mine

local args = {...}
if (#args == 0) then
    io.write("Usage:\n")
    io.write("update <options> <scripts>\n")
    io.write("Options:\n")
    io.write("-a --all : Updates all scripts.\n")
    io.write("-b --branch <branch-name>\n")
    io.write("-s --script <script1,script2>\n")

else
    for k,v in pairs(args) do
        Settings.arguments[v] = k
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
    for i = 1, #Settings.arguments, 1 do
        print(Settings.arguments[i])
    end
end