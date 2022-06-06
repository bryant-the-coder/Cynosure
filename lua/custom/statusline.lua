local fn = vim.fn
local api = vim.api
local fmt = string.format
local space = " "

local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    [""] = "VISUAL BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    [""] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}

local M = {}

-- Making the modes name UPPERCASE
local function mode()
    local current_mode = api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode]):upper()
end

-- Change the color base on the modes
--- Mode colors
---@return any modes | colors
local function update_mode_colors()
    local current_mode = api.nvim_get_mode().mode
    local mode_color = "%#StatusLineAccent#"
    if current_mode == "n" then
        mode_color = "%#StatusNormal#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_color = "%#StatusInsert#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
        mode_color = "%#StatusVisual#"
    elseif current_mode == "R" then
        mode_color = "%#StatusReplace#"
    elseif current_mode == "c" then
        mode_color = "%#StatusCommand#"
    elseif current_mode == "t" then
        mode_color = "%#StatusTerminal#"
    end
    return mode_color
end

-- Filename
local function file()
    local icon = ""
    local filename = fn.fnamemodify(fn.expand("%:t"), ":r")
    local extension = fn.expand("%:e")

    if filename == "" then
        icon = icon .. "  Empty "
    else
        filename = " " .. filename .. " "
    end

    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if not devicons_present then
        return " "
    end

    local ft_icon = devicons.get_icon(filename, extension)
    icon = (ft_icon ~= nil and " " .. ft_icon) or icon

    return icon .. filename
end

-- Nvim-gps
local function gps()
    local gps_present, gps = pcall(require, "nvim-gps")
    return gps_present and gps.is_available() and gps.get_location() or ""
end

-- Git
local git = function()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end

    return "%#Branch#  " .. git_info.head .. " "
end

-- LSP
local function get_diagnostic(prefix, severity)
    local count
    if vim.fn.has("nvim-0.6") == 0 then
        count = vim.lsp.diagnostic.get_count(0, severity)
    else
        local severities = {
            ["Warning"] = vim.diagnostic.severity.WARN,
            ["Error"] = vim.diagnostic.severity.ERROR,
            ["Info"] = vim.diagnostic.severity.INFO,
            ["Hint"] = vim.diagnostic.severity.HINT,
        }
        count = #vim.diagnostic.get(0, { severity = severities[severity] })
    end
    return fmt(" %s:%d ", prefix, count)
end

local function get_error()
    return get_diagnostic("X", "Error")
end
local function get_warning()
    return get_diagnostic("W", "Warning")
end

-- Clock
local function clock()
    return " 什 " .. os.date("%H:%M ")
end

-- Treesitter status
local function ts_status()
    local ts = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
    -- If ts is available, return ""
    -- If ts isnt available, return "滑 unavailable"
    return (ts and next(ts)) and "" or " 滑 unavailable "
end

M.run = function()
    return table.concat({
        "%#Statusline#",
        update_mode_colors(), -- Update mode colors
        mode(), -- Show mode
        "%#Normal#",
        git(),
        "%#Statusline#",
        ts_status(),

        "%=",
        -- gps(),
        "%#Filename#",
        file(), -- Show filename
        "%#Statusline#",
        "%=",

        space,
        "%#Error#",
        get_error(),
        "%#Warning#",
        get_warning(),
        "%#Clock#",
        clock(),
    })
end

return M
