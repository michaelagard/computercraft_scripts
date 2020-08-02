Message = ""
while true do
    term.clear()
    io.write(Message)
    if turtle.detect() then
        Message = "Block found!"
        turtle.dig()
    else
        Message = "I'm waiting on a block to mine!\nHold CTRL+T to terminate this program."
    end
end