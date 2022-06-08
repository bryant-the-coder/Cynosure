-- Utilities for creating configurations
local util = require("formatter.util")

require("formatter").setup({
    -- All formatter configurations are opt-in
    filetype = {
        cpp = {
            require("formatter.filetypes.cpp").clangformat,
        },
        lua = {
            require("formatter.filetypes.lua").stylua,
        },
        rust = {
            require("formatter.filetypes.rust").rustfmt,
        },
        html = {
            require("formatter.filetypes.html").prettier,
        },
        css = {
            require("formatter.filetypes.css").prettier,
        },
        javascript = {
            require("formatter.filetypes.javascript").prettier,
        },
        python = {
            require("formatter.filetypes.python").black,
        },
    },
})
