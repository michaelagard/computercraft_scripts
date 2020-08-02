while true do
    io.write("I'm waiting on a block to mine!\nHold CTRL+T to terminate this program.")
    if turtle.detect() then
        turtle.dig()
    end
end