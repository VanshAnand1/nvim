local M = {}

-- Function to get the current time
function M.get_time()
    return os.date('%I:%M %p')
end

return M
