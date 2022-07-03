local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

-- Load lua-dev because i am lazyloading it
require("packer").loader "lua-dev.nvim"

-- Dont remove this files
require "modules.lsp.installer"
require "modules.lsp.config"

-- Creating a function call on_attach
local function on_attach(client, bufnr)
    require("modules.lsp.on_attach").setup(client, bufnr)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local completion = capabilities.textDocument.completion.completionItem
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = {
    valueSet = { 1 },
}
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.textDocument.codeAction = {
    dynamicRegistration = false,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = {
                "",
                "quickfix",
                "refactor",
                "refactor.extract",
                "refactor.inline",
                "refactor.rewrite",
                "source",
                "source.organizeImports",
            },
        },
    },
}

-- sumneko_lua
local sumneko = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                },
            },
        },
    },
}
local use_lua_dev = true
if use_lua_dev then
    local luadev = require("lua-dev").setup {
        library = {
            vimruntime = true,
            types = true,
            plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        },
        lspconfig = sumneko,
    }

    lspconfig.sumneko_lua.setup(luadev)
else
    lspconfig.sumneko_lua.setup(sumneko)
end

-- JSON
lspconfig.jsonls.setup {
    on_attach = on_attach,
}

-- Clangd
local clangd_defaults = require "lspconfig.server_configurations.clangd"
local clangd_configs = vim.tbl_deep_extend("force", clangd_defaults["default_config"], {
    on_attach = on_attach,
    cmd = {
        "clangd",
        "-j=4",
        "--background-index",
        "--clang-tidy",
        "--fallback-style=llvm",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        "--pch-storage=memory",
    },
})

local status_ok, clangd = pcall(require, "clangd_extensions")
if not status_ok then
    return
end
clangd.setup {
    server = clangd_configs,
    extensions = {
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            only_current_line = false,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
            priority = 100,
        },
        ast = {
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },
            {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },
            highlights = {
                detail = "Comment",
            },
            memory_usage = {
                border = "none",
            },
            symbol_info = {
                border = "none",
            },
        },
    },
}

-- Pyright
lspconfig.jedi_language_server.setup {}
