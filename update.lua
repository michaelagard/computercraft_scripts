BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Settings = {
    ["branch"] = "master",
    ["scripts"] = {"mine", "update"},
    ["debug"] = true
}

Branch = "master"
Scripts = {"mine", "update"}
Debug = true

function UpdateScripts()
    
end

-- check args
-- example commands:
-- update all
-- update mine
-- update -b master all
-- update -b dev mine

local args = {...}
if (#args == 0) then
    io.write("Usage:\n")
    io.write("update <options> <scripts>\n")
    io.write("Options:\n")
    io.write("-a --all : Updates all scripts.\n")
    io.write("-b --branch <branch-name>\n")
    io.write("-s --script <script-names>")
    -- update -b master -a
else
    for key, value in pairs(args) do
        print(key, value)
    end
end

--debug code

if (Settings["debug"]) then
    print("        -Scripts-")
    for i = 1, #Settings["scripts"], 1 do
        print(Scripts[i])
    end
    
    print("        -Branch-")
    print(#Settings["branch"])
end