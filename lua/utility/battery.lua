local M = {}

-- Define battery symbols and thresholds
local battery_symbols = {
    { threshold = 90, symbol = "󰁹"}, -- Green for 90%+
    { threshold = 70, symbol = "󰂂" }, -- Green for 90%+
    { threshold = 60, symbol = "󰂁" }, -- Green for 90%+
    { threshold = 50, symbol = "󰂀" }, -- Green for 90%+
    { threshold = 40, symbol = "󰁿" }, -- Light Green for 70%-89%
    { threshold = 30, symbol = "󰁽" }, -- Yellow for 50%-69%
    { threshold = 20, symbol = "󰁼" }, -- Orange for 30%-49%
    { threshold = 10, symbol = "󰁻" }, -- Red for 10%-29%
    { threshold = 0, symbol = "󰁺"},  -- Bright Red for 0%-9%
}

-- Function to fetch battery percentage and assign symbol and color
function M.get_battery()
    -- BAT1 might not be the battery that is being used
    -- run ls /sys/class/power_supply/ on linux to find the correct battery supplier
    -- on MacOS replace with: 
    -- local handle = io.popen("pmset -g batt | grep -Eo '\\d+%' | cut -d'%' -f1")
    local handle = io.popen("cat /sys/class/power_supply/BAT1/capacity 2>/dev/null")
    if not handle then
        return "No Battery 1" -- Default fallback if the command fails
    end

    local percentage = handle:read("*a") -- Read the output
    handle:close()

    -- Handle nil or empty output
    if not percentage or percentage:match("^%s*$") then
        return "No Battery 2"
    end
    -- Trim whitespace
    percentage = percentage:gsub("%s+", ""):gsub("%z", "")

    local charging_handle = io.popen("cat /sys/class/power_supply/BAT1/status 2>/dev/null")
    if not charging_handle then
        return "No Battery 3"
    end
    local status = charging_handle:read("*a") -- Read the charging status
    charging_handle:close()

    -- Clean the status string
    if not status or status:match("^%s*$") then
        status = "Unknown"
    end
    status = status:gsub("%s+", ""):gsub("%z","") -- Remove extra whitespace 

    if tonumber(percentage) then
        -- Map percentage to symbol and return (escape % once for lualine)
        for _, entry in ipairs(battery_symbols) do
            if tonumber(percentage) >= entry.threshold then
                if status == "Charging" then
                    return "󰂄 "..percentage
                else
                    return entry.symbol .. " "..percentage
                end
            end
        end
    else
        return "failed number"
    end

    return "No Battery 4"
end


return M
