local function round(number)
    return number - (number % 1)
end

local function binary_search(my_list, search_item)
    local low = 0
    local high = #my_list
    
    while (low <= high) do
        local middle = round((low + high) / 2)
            local guess = my_list[middle]
        if (guess == search_item) then
            return middle
        end
        if (guess > search_item) then
            high = middle - 1
        else
            low = middle + 1
        end
    end
    return "None"
end

local test_list = {2,4,7,8,9,10,12,34,45}

print(binary_search(test_list, 7)) -- 3
print(binary_search(test_list, 34)) -- 8