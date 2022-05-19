require("core.disable_builtin")

local g = vim.g
local o = vim.opt

--Cursor & cursorline
o.guicursor = "n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
o.cursorline = true
o.cursorlineopt = { "number" } -- Highlighting the number where the cursor is on

-- Mappings
g.mapleader = ","
o.mouse = "a"

-- Theme
o.termguicolors = true

-- Number
o.number = true
o.relativenumber = true
o.signcolumn = "yes:2"
o.scrolloff = 1000 -- Stop scrolling on the number set

-- Splits
o.splitright = true
o.splitbelow = true

-- Command line
o.shortmess:append("I")
o.cmdheight = 1
o.hidden = true
o.history = 300
o.updatetime = 200
o.smd = false -- Don't show mode in cmdline

-- Tabs & Indent
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.smartindent = true
o.autoindent = true
o.smarttab = true
o.linebreak = true
o.breakindent = true

-- Editor
o.wrap = false
o.clipboard = "unnamedplus"
o.foldmethod = "marker"
o.completeopt = "menuone,noselect,menu"
o.lazyredraw = true

-- Search
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.showmatch = true -- Shows show match
o.smartcase = true -- Don't ignore when uppercase search

-- Statusline
o.laststatus = 3
o.winbar = "%{%v:lua.require'custom.winbar'.eval()%}"

-- Conceal
o.conceallevel = 2

-- See :h fillchars
-- See :h fillchars
o.fillchars = {
    eob = " ",
    vert = "║",
    horiz = "═",
    horizup = "╩",
    horizdown = "╦",
    vertleft = "╣",
    vertright = "╠",
    verthoriz = "╬",
}

-- Backups / Undo
o.backup = false -- Don't backup files
o.writebackup = false -- Don't write backup
o.undofile = false -- Don't write undofile
o.swapfile = false -- Don't write swapfile

-- Terminal
if vim.fn.has("win32") == 1 then
    o.shell = "pwsh.exe -nol"
    o.shellcmdflag = "-nop -c"
    o.shellquote = '"'
    o.shellxquote = ""
    o.shellpipe = "| Out-File -Encoding UTF8 %s"
    o.shellredir = "| Out-File -Encoding UTF8 %s"
end
