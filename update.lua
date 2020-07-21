BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
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
    io.write("all : Updates all scripts.\n")
    io.write("-b, --branch - Specify repo branch.\n")
elseif (#args >= 2 and args[1] == "-b") then
    Branch = args[2]
    for k ,v in pairs(args) do
        print (k,v)
    end 
end

--debug code

if (debug) then
    print("        -Scripts-")
    for i = 1, #Scripts, 1 do
        print(Scripts[i])
    end

    print("        -ArgTable-")
    for i = 1, #ArgTable, 1 do
        print(ArgTable[i])
    end
end