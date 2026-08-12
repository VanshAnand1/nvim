local time = require("utility.time")
local battery = require("utility.battery")

local batteryinfo = {}
local function battery_setup()
    local bString = battery.get_battery()
    -- Only try to parse the icon if we actually got a battery string back
    if bString ~= "" then
        batteryinfo.icon = bString.sub(0, 4)
    end
    return bString
end

local function get_battery()
    vim.go.laststatus = 3
    return battery_setup()
end

-- Condition function to check if the battery component should be drawn
local function is_mac()
    return jit.os == "OSX"
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { 
        options = {
            -- theme = 'tokyonight',
            icons_enabled = true,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = true,
            refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = {
                {
                    "filename",
                    path = 1
                },
            },
            lualine_x = { 'filetype' },
            lualine_y = { 
                'location',
                {
                    get_battery,
                    icon = batteryinfo.icon,
                    cond = is_mac -- Only displays this entire item if on a Mac
                }
            },
            lualine_z = {
                {
                    time.get_time,
                    icon = '', 
                },
            }
        },
        -- inactive_sections = {
        --     lualine_a = {},
        --     lualine_b = {},
        --     lualine_c = { 'filename' },
        --     lualine_x = { 'location' },
        --     lualine_y = { 
        --         {
        --             get_battery,
        --             cond = is_mac -- Only displays on a Mac
        --         }
        --     },
        --     lualine_z = {
        --         {
        --             time.get_time,
        --             icon = '', 
        --         },
        --     }
        -- },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
}
