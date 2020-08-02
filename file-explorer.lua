local screen_width, screen_height = term.getSize()
local current_dir = shell.dir()
local file_list = fs.list(shell.dir())
local count = 0
local curY = 1

local screen_width, screen_height = term.getSize()
local myWindow1Border = window.create(term.current(), 1, 1, math.floor(screen_width / 2), screen_height)
local myWindow1 = window.create(term.current(), 2, 2, screen_width / 2 - 2, screen_height - 2)
local myWindow2Border = window.create(term.current(), math.floor(screen_width / 2) + 1, 1, math.floor(screen_width / 2) + 1, screen_height)
local myWindow2 = window.create(term.current(), math.floor(screen_width / 2) + 2, 2, math.floor(screen_width / 2) - 1, screen_height - 2)
-- local myWindow2 = window.create


-- window.create(parentTerm, xPOS, yPOS, width, height, visible)
term.clear()
myWindow1Border.setBackgroundColor(colors.green)
myWindow1Border.clear()
myWindow1.setBackgroundColor(colors.black)
myWindow1.clear()
myWindow2Border.setBackgroundColor(colors.red)
myWindow2Border.clear()
myWindow2.setBackgroundColor(colors.black)
myWindow2.clear()
local function print_file_list(xFL, yFL, fgColor, bgColor)
	for key, value in pairs(file_list) do
		term.setCursorPos(xFL, yFL)
	  if key == curY then
		term.setBackgroundColor(colors.green)
		io.write(value .. "\n")
	  else
		term.setBackgroundColor(colors.black)
		io.write(value .. "\n")
	  end
	  yFL = yFL + 1
	end
  end
-- y = up / down
-- x = left / right

local function printCurrentDir(xDir, yDir, dirBGColor)
	term.setCursorPos(xDir, yDir)
	term.setBackgroundColor(colors[dirBGColor])
	io.write("> /" .. current_dir)
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
	elseif key == 208 and curY < #file_list - 1 then
	  curY = curY + 1
	elseif key == 15 then
		term.clear()
	  term.setCursorPos(1,1)
	  print("Goodbye.")
	  break
	end
  end