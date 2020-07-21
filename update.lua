-- Usage: >update 
BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Branch = "master"
Scripts = {"mine", "update"}

function UpdateScripts()
    
end

local args = {...}

-- check args
if (#args == 0) then
    io.write("Usage:\nupdate [-b branch] [scriptName1, ...]\nupdate all\n")

elseif (#args[1] == "-b") then
    Branch = args[2]
    
    if (not(#args[3] == "all")) then
        for i = 3, #args, 1 do
            Scripts[i - 2] = args[i]
        end
    end
end



if (#args >= 2 and args[1] == "-b") then
    Branch = args[2]
end

for i = 1, #Scripts, 1 do
    print(Scripts[i])
end