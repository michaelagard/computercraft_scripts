-- Usage: >update 
BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Branch = "master"
Scripts = {"mine", "update"}

function UpdateScripts()
    
end

local args = {...}

-- check update arguments
if (#args == 0) then
    io.write("Usage:\nupdate [-b branch] [scriptName1, ...]\nupdate all")
end

if (#args >= 2 and args[1] == "-b") then
    Branch = args[2]
end