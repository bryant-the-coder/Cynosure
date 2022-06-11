local servers = {
    "emmet_ls",
    "html",
    "tsserver",
    "jsonls",
    "cssls",
    "clangd",
    "rust_analyzer",
    "sumneko_lua",
    "yamils",
    "ltex",
    "jedi_language_server",
}

-- Setting up installer
require("nvim-lsp-installer").setup {
    ensure_installed = servers,
    ui = {
        icons = {
            server_installed = " ",
            server_pending = " ",
            server_uninstalled = " ﮊ",
        },
    },
    -- Limit for the maximum amount of servers to be installed at the same time. Once this limit is reached, any further
    -- servers that are requested to be installed will be put in a queue.
    max_concurrent_installers = 3,
}
