-- Usage: >update 
BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Branch = "master"
Script = {"mine"}

term.setTextColor(color.red)
io.write("Updating\n")

function Update()
    for i = 1, #Script, 1 do
        shell.run("wget", "https://github.com/michaelagard/computercraft_scripts/blob/" .. Branch[2] .. "/" .. Script[1] .. ".lua") 
    end
    
end

function DeletePreviousFile()
    shell.run("rm", "mine.lua")
end

local args = {...}

-- check update arguments
if (#args == 0) then
    io.write("Usage:\nupdate [-b branch] [scriptName1, ...]\nupdate all")
end

if (#args >= 2 and args[1] == "-b") then
    Branch = args[2]
end

print(Branch)