

-- local current_path = fs.combine(pathA, pathB)
local file_list = fs.list("/home/kai/dev/")
local current_dir = shell.dir()
local directory_table = {}
local function filesize(file)
  fs.getSize(path)
end
local curY = 0
local count = 0

for dir in string.gmatch(current_dir, "%a+") do
    table.insert(directory_table, dir)
end

term.clear()
term.setCursorBlink(true)

local function traverse_dir(dir)
  
end
local function rename_file(file, new_name)
  shell.execute("move", current_dir .. "/" .. file .. " " .. current_dir .. "/" .. new_name)
end

local function print_directory()
  term.clear()
  term.setCursorPos(1,1)
  print(current_dir)
end

local function print_file_list()
  for key, value in pairs(file_list) do
    if key == curY + 1 then
      term.setBackgroundColor(colors.green)
      print(key, value)
    else
      term.setBackgroundColor(colors.black)
      print(key, value)
    end
  end
end

local function edit_program(file)
  shell.execute("edit", file)
end

while count < 1000 do
  -- print_directory()
  -- print_file_list()
  term.setCursorPos(1,curY + 2)
  local event, key, isHeld = os.pullEvent("key")
  print(key)
  count = count + 1
  if key == 200 and curY >= 1 then
    curY = curY - 1
    term.setCursorPos(1,curY)
  elseif key == 208 and curY < #file_list - 1 then
    curY = curY + 1
    term.setCursorPos(1,curY)
  elseif key == 28 then
    edit_program(file_list[curY + 1])
  elseif key == 203 then

  elseif key == 205 then
  elseif key == 60 then
    
    io.write("Enter new name.")
    local new_name = io.read()
    rename_file(file_list[curY + 1], new_name)
  elseif key == 15 then
    term.setCursorPos(1,1)
    print("Goodbye.")
    break
  end
end
-- mount /home/kai/dev /home/kai/Development/computercraft_scripts