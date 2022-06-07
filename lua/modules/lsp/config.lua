-- Taken from max. Thanks max

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

local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
    { name = "DiagnosticSignHint", text = "" },
}
for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
    signs = true,
    underline = true,
    severity_sort = true,
    update_in_insert = true,
    virtual_text = false,

    float = {
        focusable = false,
        scope = "cursor",
        source = true,
        border = border,
        header = { "Mistakes you made:", "DiagnosticHeader" },
        prefix = function(diagnostic, i, total)
            local icon, highlight
            if diagnostic.severity == 1 then
                icon = ""
                highlight = "DiagnosticError"
            elseif diagnostic.severity == 2 then
                icon = ""
                highlight = "DiagnosticWarn"
            elseif diagnostic.severity == 3 then
                icon = ""
                highlight = "DiagnosticInfo"
            elseif diagnostic.severity == 4 then
                icon = ""
                highlight = "DiagnosticHint"
            end
            return i .. "/" .. total .. " " .. icon .. "  ", highlight
        end,

        -- Code from TJ
        format = function(d)
            local t = vim.deepcopy(d)
            local code = d.code or d.user_data.lsp.code
            if code then
                t.message = string.format("%s -> (%s)", t.message, code):gsub("1. ", "")
            end
            return t.message
        end,

        -- Code from santigo-zero
        -- format = function(diagnostic)
        --     return string.format(
        --         "%s (%s) [%s]",
        --         diagnostic.message,
        --         diagnostic.source,
        --         diagnostic.code or diagnostic.user_data.lsp.code
        --     )
        -- end,
    },
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
