local M = {}

M.eval = function()
    if vim.api.nvim_eval_statusline("%f", {})["str"] == "[No Name]" then
        return ""
    end
    if vim.api.nvim_eval_statusline("%f", {})["str"] == "[Scratch]" then
        return ""
    end
    return "%#WinBarSeparator#"
        .. ""
        .. "%*"
        .. "%#WinBarContent#"
        .. "%f"
        .. "%*"
        .. "%#WinBarSeparator#"
        .. ""
        .. "%*"
end

return M
