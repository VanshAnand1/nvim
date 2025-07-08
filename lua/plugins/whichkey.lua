return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset  = "helix",
        triggers = {
            { "<leader>", mode = { "n", "v" } },
            { "m", mode = { "n", "v" } },
        }

    },
    keys = {
        {
            "<leader>?",
            "m?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
