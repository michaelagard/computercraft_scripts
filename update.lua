BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Settings = {
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
    io.write("-s --script <script-names>\n")

else
    for i = 1, #args, 1 do
        if (string.find(args[i], "-b" or "--branch" or "-s" or "--script")) then
            print(args[i], "flag found!")
        end
    end
end

--debug code

if (Settings["debug"]) then
    print("        -Scripts-")
    for i = 1, #Settings["scripts"], 1 do
        print(Settings.scripts[i])
    end
    
    print("        -Branch-")
    print(#Settings["branch"])
end