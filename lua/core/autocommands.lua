local api = vim.api
local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local create_command = vim.api.nvim_create_user_command

-- Disable autocommenting {{{
cmd("BufEnter", {
    desc = "Disable autocommenting in new lines",
    command = "set fp-=c fo-=r fo-=o",
})
-- }}}

-- Terminal {{{
augroup("_terminal", {})
cmd("TermOpen", {
    desc = "Terminal settings",
    group = "_terminal",
    command = "startinsert",
})
cmd("TermOpen", {
    desc = "Terminal settings",
    group = "_terminal",
    command = "setlocal nonumber norelativenumber",
})
-- }}}

cmd("FileType", {
    pattern = "norg",
    callback = function()
        vim.opt.number = false
        vim.opt.cole = 1
        vim.opt.foldlevel = 10
        vim.opt.signcolumn = "yes:2"
    end,
})

cmd("FileType", {
    pattern = "plaintex",
    callback = function()
        vim.bo.ft = "tex"
    end,
})

-- Auto resize panes
cmd("VimResized", {
    pattern = "*",
    command = "tabdo wincmd =",
})

augroup("_buffer", {})
-- Trim whitespace {{{
local NoWhitespace = vim.api.nvim_exec(
    [[
    function! NoWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endfunction
    call NoWhitespace()
    ]],
    true
)

cmd("BufWritePre", {
    desc = "Trim whitespace on save",
    group = "_buffer",
    command = [[call NoWhitespace()]],
})
-- }}}

-- Cursor position {{{
cmd("BufReadPost", {
    desc = "Restore cursor position upon reopening the file",
    group = "_buffer",
    command = [[
       if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"zvzz" | endif
    ]],
})
-- }}}

-- Highlight while yanking {{{
cmd("TextYankPost", {
    pattern = "*",
    desc = "Highlight while yanking",
    group = "_buffer",
    callback = function()
        vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
    end,
})
-- }}}

-- q as escape key {{{
cmd("FileType", {
    desc = "Quit with q in this filetypes",
    group = "_buffer",
    pattern = "qf,help,man,lspinfo,startuptime,Trouble",
    callback = function()
        vim.keymap.set("n", "q", "<CMD>close<CR>")
    end,
})
-- }}}

-- Custom dashboard display {{{
--[[ cmd({ "VimEnter" }, {
    callback = function()
        require("custom.dashboard").display()
    end,
}) ]]

-- If filetype is dashboard then do not show statusline
cmd("FileType", {
    pattern = "dashboard",
    callback = function()
        vim.opt.laststatus = 0
        vim.opt.list = false
    end,
})

-- Other filetype, show statusline
cmd("BufUnload", {
    buffer = 0,
    callback = function()
        vim.opt.laststatus = 3
        vim.opt.list = true
    end,
})
-- }}}

-- Nofity when file changes {{{
augroup("_auto_reload_file", {})
cmd("FileChangedShellPost", {
    desc = "Actions when the file is changed outside of Neovim",
    group = "_auto_reload_file",
    callback = function()
        vim.notify("File changed, reloading the buffer", "error", { title = "Buffer changed", icon = "勒" })
    end,
})

cmd({ "FocusGained", "CursorHold" }, {
    desc = "Actions when the file is changed outside of Neovim",
    group = "_auto_reload_file",
    command = [[if getcmdwintype() == '' | checktime | endif]],
})
-- }}}

augroup("_lsp", {})
-- Open float when there are diagnostics {{{
cmd({ "CursorHold" }, {
    desc = "Open float when there is diagnostics",
    group = "_lsp",
    callback = vim.diagnostic.open_float,
})
--}}}

-- Autoformat on save {{{
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     group = "_lsp",
--     callback = function()
--         vim.cmd([[FormatWrite]])
--     end,
-- })
-- }}}

augroup("git_repo_check", {})
-- Custom event {{{
cmd({ "VimEnter", "DirChanged" }, {
    group = "git_repo_check",
    callback = function()
        local is_git = vim.api.nvim_exec("!git rev-parse --is-inside-work-tree", true)
        if is_git:match "true" then
            vim.cmd "doautocmd User IsGit"
            return true
        else
            return false
        end
    end,
})
-- }}}

-- Autorun function {{{
local attach_to_buffer = function(output_bufnr, pattern, command)
    api.nvim_create_autocmd("BufWritePost", {
        group = api.nvim_create_augroup("autorun", { clear = true }),
        pattern = pattern,
        callback = function()
            local append_data = function(_, data)
                if data then
                    api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
                end
            end
            api.nvim_buf_set_lines(output_bufnr, -1, -1, false, { "Output of file: " })
            vim.fn.jobstart(command, {
                stdout_buffered = true,
                on_stdout = append_data(),
                on_stderr = append_data(),
            })
        end,
    })
end

create_command("AutoRun", function()
    print "Autorun will start..."
    local bufnr = vim.fn.input "Bufnr: "
    local pattern = vim.fn.input "Pattern: "
    local command = vim.split(vim.fn.input "Command: ", " ")
    attach_to_buffer(tonumber(bufnr), pattern, command)
end, {})
-- }}}
