
BaseUrl = "https://raw.githubusercontent.com/michaelagard/computercraft_scripts"
Branch = {"master"}
Script = {"mine"}
io.write("Updating")
shell.run("wget", "https://github.com/michaelagard/computercraft_scripts/blob/master/mine.lua", Scripts[1] .. ".lua")

function Update()
    for i = 1, #Script, 1 do
        shell.run("wget", "https://github.com/michaelagard/computercraft_scripts/blob/" .. Branch[1] .. "/" .. Script[1] .. ".lua") 
    end
end