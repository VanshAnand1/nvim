-- local time = require("utility.time")
--
-- local battery = require("utility.battery")
--
-- local batteryinfo = {}
-- local function battery_setup()
--     local bString = battery.get_battery()
--     batteryinfo.icon = bString.sub(0, 4)
--     return bString
-- end
-- local function get_battery()
--     vim.go.laststatus = 3
--     return battery_setup()
-- end


return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { 
        options = {
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
            globalstatus = false,
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
            lualine_y = { 'location',
                -- {
                --     get_battery,
                --     icon = batteryinfo.icon
                -- }
            },
            lualine_z = {
            --     {
            --         time.get_time,
            --         icon = '', 
            --     },
            }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = { 
                -- get_battery 
                 },
            lualine_z = {
                -- {
                --     time.get_time,
                --     icon = '', 
                -- },
            }
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
}
