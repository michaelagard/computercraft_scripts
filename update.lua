
BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Branch = {"master", "dev-update-script"}
Script = {"mine", "update"}
term.setTextColor(color.red)
io.write("Updating\n")

function Update()
    for i = 1, #Script, 1 do
        shell.run("wget", "https://github.com/michaelagard/computercraft_scripts/blob/" .. Branch[2] .. "/" .. Script[1] .. ".lua") 
    end
end

function DeletePreviousFile()
    shell.run("rm", "mine.lua")
    shell.run("rm", "update.lua")
end

DeletePreviousFile()
Update()