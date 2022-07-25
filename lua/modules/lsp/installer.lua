--[[ local servers = {
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
]]

local servers = {
    "clangd",
    "css-lsp",
    "emmet-ls",
    "html-lsp",
    "jedi-language-server",
    "json-lsp",
    "ltex-ls",
    "lua-language-server",
    "rust-analyzer",
    "typescript-language-server",
    "yaml-language-server",
}
local status_ok, mason = pcall(require, "mason")
if not status_ok then
    return
end

mason.setup {
    ui = {
        icons = {
            server_installed = " ",
            server_pending = " ",
            server_uninstalled = " ﮊ",
        },
    },
    -- Limit for the maximum amount of servers to be installed at the same time. Once this limit is reached, any further
    -- servers that are requested to be installed will be put in a queue.

    -- NOTE: to prevent lack
    max_concurrent_installers = 3,
}

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
    return
end

require("mason-lspconfig").setup {
    ensure_installed = servers,
    automatic_installation = true,
}
