local M = {}

local function write_enabled_langs(enabled_langs)
    local path = vim.fn.stdpath("config") .. "/lua/languages/enabled.lua"
    local lines = { "return {", }
    for _, lang in ipairs(enabled_langs) do
        table.insert(lines, string.format('  "%s",', lang))
    end
    table.insert(lines, "}")
    vim.fn.writefile(lines, path)
end

local function get_enabled_langs()
    local enabled_path = vim.fn.stdpath("config") .. "/lua/languages/enabled.lua"
    local ok, mod = pcall(dofile, enabled_path)
    if ok and type(mod) == "table" then
        return mod
    end
    return {}
end

local function get_all_langs()
    local langs_dir = vim.fn.stdpath("config") .. "/lua/languages"
    local all_langs = {}
    
    local okdir, iter = pcall(vim.fs.dir, langs_dir)
    if okdir then
        for name, type_ in iter do
            if type_ == "file"
                and name:sub(-4) == ".lua"
                and name ~= "init.lua"
                and name ~= "enabled.lua"
                and name ~= "menu.lua"
            then
                table.insert(all_langs, name:sub(1, -5))
            end
        end
    else
        for _, name in ipairs(vim.fn.readdir(langs_dir, [[v:val =~ '\.lua$']])) do
            if name ~= "init.lua" and name ~= "enabled.lua" and name ~= "menu.lua" then
                table.insert(all_langs, name:sub(1, -5))
            end
        end
    end
    
    table.sort(all_langs)
    return all_langs
end

function M.select_languages()
    local enabled = get_enabled_langs()
    local all_langs = get_all_langs()
    
    -- Create a set for fast lookup
    local enabled_set = {}
    for _, lang in ipairs(enabled) do
        enabled_set[lang] = true
    end
    
    -- Build options with checkmarks
    local options = {}
    for _, lang in ipairs(all_langs) do
        local prefix = enabled_set[lang] and "✔ " or "  "
        table.insert(options, prefix .. lang)
    end
    
    vim.ui.select(options, {
        prompt = "Select language to toggle (Esc to close):",
        format_item = function(item)
            return item
        end,
    }, function(choice)
        if not choice then return end
        
        -- Extract the language name (remove checkbox/space prefix)
        local lang = choice:gsub("^[✔ ]+", "")
        if not lang or lang == "" then return end
        
        -- Reload enabled langs to get fresh state
        local current_enabled = get_enabled_langs()
        local is_enabled = false
        for _, l in ipairs(current_enabled) do
            if l == lang then
                is_enabled = true
                break
            end
        end
        
        -- Toggle the language
        if is_enabled then
            -- Remove from enabled
            local new_enabled = {}
            for _, l in ipairs(current_enabled) do
                if l ~= lang then
                    table.insert(new_enabled, l)
                end
            end
            write_enabled_langs(new_enabled)
            vim.notify("Disabled: " .. lang, vim.log.levels.INFO)
        else
            -- Add to enabled
            table.insert(current_enabled, lang)
            table.sort(current_enabled)
            write_enabled_langs(current_enabled)
            vim.notify("Enabled: " .. lang, vim.log.levels.INFO)
        end
        
        -- Reopen the menu for more toggles
        vim.defer_fn(function()
            M.select_languages()
        end, 100)
    end)
end

return M
