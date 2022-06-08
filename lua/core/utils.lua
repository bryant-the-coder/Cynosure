local M = {}
local cmd = vim.cmd

--- Define bg color
---@param group string
---@param col string
M.bg = function(group, col)
    cmd("hi " .. group .. " guibg=" .. col)
end

--- Define fg color
---@param gruop string
---@param col string
M.fg = function(gruop, col)
    cmd("hi " .. gruop .. " guifg=" .. col)
end

--- Define fg & bg color
---@param group string
---@param fgcol string
---@param bgcol string
M.fg_bg = function(group, fgcol, bgcol)
    cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

--- Getting color from base16
M.get = function()
    local theme = _G.theme
    -- local time = os.date("*t")
    -- if time.hour < 7 or time.hour >= 21 then
    --     theme = "onedark"
    -- else
    --     theme = "everblush"
    -- end
    return require("hl_themes." .. theme)
end

--- Go to url
---@param cmd thread https://github.com
M.url = function(cmd)
    local url = vim.api.nvim_get_current_line():match([[%[.*]%((.*)%)]]) -- To work on md links
    if url == nil then
        url = vim.fn.expand("<cWORD>")
        if not string.match(url, "http") then
            url = "https://github.com/" .. url
        end
        if string.match(url, [[(.+)[,:]$]]) then
            url = url:sub(1, -2)
        end -- to check commas at the end
    end

    vim.notify("Going to " .. url, "info", { title = "Opening browser..." })
    vim.cmd(":silent !" .. cmd .. " " .. url)
    -- vim.cmd(':silent !'..(cmd or "xdg-open")..' '..url..' 1>/dev/null')
end

--- Swap between booleans with ease
M.swap_boolean = function()
    local c = vim.api.nvim_get_current_line()
    local subs = c:match("true") and c:gsub("true", "false") or c:gsub("false", "true")
    vim.api.nvim_set_current_line(subs)
end

--- Rename a variable (simple)
---@return string
M.rename = function()
    -- local border = {
    --     { "┏", "FloatBorder" },
    --     { "━", "FloatBorder" },
    --     { "┓", "FloatBorder" },
    --     { "┃", "FloatBorder" },
    --     { "┛", "FloatBorder" },
    --     { "━", "FloatBorder" },
    --     { "┗", "FloatBorder" },
    --     { "┃", "FloatBorder" },
    -- }

    -- local border = {
    -- 	{ "╔", "FloatBorder" },
    -- 	{ "═", "FloatBorder" },
    -- 	{ "╗", "FloatBorder" },
    -- 	{ "║", "FloatBorder" },
    -- 	{ "╝", "FloatBorder" },
    -- 	{ "═", "FloatBorder" },
    -- 	{ "╚", "FloatBorder" },
    -- 	{ "║", "FloatBorder" },
    -- }

    -- local border = {
    --     { "╭", "FloatBorder" },
    --     { "─", "FloatBorder" },
    --     { "╮", "FloatBorder" },
    --     { "│", "FloatBorder" },
    --     { "╯", "FloatBorder" },
    --     { "─", "FloatBorder" },
    --     { "╰", "FloatBorder" },
    --     { "│", "FloatBorder" },
    -- }

    local border = {
        { "┌", "FloatBorder" },
        { "─", "FloatBorder" },
        { "┐", "FloatBorder" },
        { "│", "FloatBorder" },
        { "┘", "FloatBorder" },
        { "─", "FloatBorder" },
        { "└", "FloatBorder" },
        { "│", "FloatBorder" },
    }

    local function post(rename_old)
        vim.cmd("stopinsert!")
        local rename_new = vim.api.nvim_get_current_line()
        vim.schedule(function()
            vim.api.nvim_win_close(0, true)
            vim.lsp.buf.rename(vim.trim(rename_new))
        end)
        -- Use notify.nvim, logs notification as warn, title as Variable Rename
        vim.notify(rename_old .. "  " .. rename_new, "warn", { title = "Variable Rename", icon = "ﰇ" })
    end

    local rename_old = vim.fn.expand("<cword>")
    local created_buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(created_buffer, true, {
        relative = "cursor",
        style = "minimal",
        border = border,
        row = 1,
        col = 0,
        width = 30,
        height = 1,
    })
    vim.cmd("startinsert")

    vim.keymap.set("i", "<ESC>", function()
        vim.cmd("q")
        vim.cmd("stopinsert")
    end, { buffer = created_buffer })

    vim.keymap.set("i", "<CR>", function()
        return post(rename_old)
    end, { buffer = created_buffer })
end

M.l_motion = function()
    local cursorPosition = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal ^")
    local firstChar = vim.api.nvim_win_get_cursor(0)

    if cursorPosition[2] < firstChar[2] then
        vim.cmd("normal ^")
    else
        vim.api.nvim_win_set_cursor(0, cursorPosition)
        vim.cmd("normal! l")
    end
end

M.h_motion = function()
    local cursorPosition = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal ^")
    local firstChar = vim.api.nvim_win_get_cursor(0)

    if cursorPosition[2] <= firstChar[2] then
        vim.cmd("normal 0")
    else
        vim.api.nvim_win_set_cursor(0, cursorPosition)
        vim.cmd("normal! h")
    end
end

M.border = function()
    return {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    }
end

--- Inserts a "," add the end of line
M.insert_comma = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- append ,
    vim.cmd([[normal A,]])
    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
end

--- Inserts a ";" add the end of line
M.insert_semicolon = function()
    -- save cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- append ,
    vim.cmd([[normal A;]])
    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
end

--- Checking for neovim version
---@param version string version number
---@return boolean has_version
M.has_version = function(version)
    return vim.fn.has("nvim-" .. version) > 0
end

M.open = function()
    local currName = vim.fn.expand("<cword>") .. " "

    local win = require("plenary.popup").create("  ", {
        title = currName,
        style = "minimal",
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        relative = "cursor",
        borderhighlight = "RenamerBorder",
        titlehighlight = "RenamerTitle",
        focusable = true,
        width = 25,
        height = 1,
        line = "cursor+2",
        col = "cursor-1",
    })

    local map_opts = { noremap = true, silent = true }

    vim.cmd("normal w")
    vim.cmd("startinsert")

    vim.api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)

    vim.api.nvim_buf_set_keymap(
        0,
        "i",
        "<CR>",
        "<cmd>stopinsert | lua require'core.utils'.apply(" .. currName .. "," .. win .. ")<CR>",
        map_opts
    )

    vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<CR>",
        "<cmd>stopinsert | lua require'core.utils'.apply(" .. currName .. "," .. win .. ")<CR>",
        map_opts
    )
end

M.apply = function(curr, win)
    local newName = vim.trim(vim.fn.getline("."))
    vim.api.nvim_win_close(win, true)

    if #newName > 0 and newName ~= curr then
        local params = vim.lsp.util.make_position_params()
        params.newName = newName

        vim.lsp.buf_request(0, "textDocument/rename", params)
        vim.notify(newName .. " is set", "warn", { title = "Variable Rename", icon = "凜" })
    end
end

return M
