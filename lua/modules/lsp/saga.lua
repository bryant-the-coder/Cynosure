local status_ok, saga = pcall(require, "lspsaga")
if not status_ok then
    return
end

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

saga.init_lsp_saga {
    border_style = border,
    move_in_saga = { prev = "<C-p>", next = "<C-n>" },
    diagnostic_header = { " ", " ", " ", " " },
    show_diagnostic_source = true,
    diagnostic_source_bracket = {},
    code_action_icon = "💡",
    code_action_num_shortcut = true,
    code_action_lightbulb = {
        enable = true,
        sign = true,
        sign_priority = 20,
        virtual_text = true,
    },
    finder_separator = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
        open = "o",
        vsplit = "s",
        split = "i",
        tabe = "t",
        quit = "q",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>", -- quit can be a table
    },
    code_action_keys = {
        quit = "q",
        exec = "<CR>",
    },
    rename_action_quit = "<C-c>",
    definition_preview_icon = "  ",
    server_filetype_map = {},
}
