BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Branch = "master"
Scripts = {"mine", "update"}
Debug = true
local args = {...}

function UpdateScripts()
    
end

-- check args
-- example commands:
-- update all
-- update mine
-- update -b master all
-- update -b dev mine

if (#args == 0) then
    io.write("Usage:\n")
    io.write("update [OPTION]... [scriptName1, scriptName2, ...]")
    io.write("Options:\n")
    io.write(" -b, --branch - Specify repo branch.\n")
    
elseif (args[1] == "-b" or args[1] == "--branch") then
    Branch = args[2]

elseif (not(args[3] == "all" or args[1 == "all"])) then
    Scripts = {}
    for i = 3, #args, 1 do
        Scripts[i - 2] = args[i]
    end
end

--debug code

if (debug) then
    print("Scripts")
    for i = 1, #Scripts, 1 do
        print(Scripts[i])
    end

    print("Args")
    for i = 1, #args, 1 do
        print(args[i])
    end
end