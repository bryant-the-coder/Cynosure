local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

-- WARN: DONT PLACE ANY LSP CONFIG BELOW CLANGD (just in case you know)

-- Load lua-dev because i am lazyloading it
require("packer").loader "lua-dev.nvim"

-- Dont remove this files
require "modules.lsp.installer"
require "modules.lsp.config"
local capabilities = require "modules.lsp.capabilities"

-- Creating a function call on_attach
local function on_attach(client, bufnr)
    require("modules.lsp.on_attach").setup(client, bufnr)
end

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
            hint = {
                enable = true,
                arrayIndex = "Enable", -- "Enable", "Auto", "Disable"
                await = true,
                paramName = "All", -- "All", "Literal", "Disable"
                paramType = true,
                semicolon = "All", -- "All", "SameLine", "Disable"
                setType = true,
            },
        },
    },
}
local use_lua_dev = false
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

-- Pyright
require("lspconfig").jedi_language_server.setup {
    -- cmd = { "jedi-language-server" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                indexing = true,
                typeCheckingMode = "basic",
                diagnosticMode = "workspace",
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                },
                stubPath = vim.fn.expand "$HOME/typings",
                diagnosticSeverityOverrides = {
                    reportMissingTypeStubs = "information",

                    reportGeneralTypeIssues = "warning",
                    reportUnboundVariable = "warning",
                    reportUndefinedVariable = "error",
                    reportUnknownMemberType = "information",
                    reportUnknownVariableType = "information",
                    reportUntypedClassDecorator = "none",
                    reportUntypedFunctionDecorator = "none",
                    reportFunctionMemberAccess = "warning",
                    reportUnknownArgumentType = "warning",
                    reportUnknownParameterType = "warning",
                    reportUnknownLambdaType = "warning",
                    reportUnusedImport = "information",
                    reportUnusedFunction = "information",
                    reportUnusedVariable = "information",
                    reportUnusedClass = "information",
                    strictParameterNoneValue = false,
                    reportOptionalSubscript = "warning",
                    reportOptionalMemberAccess = "warning",
                    reportOptionalIterable = "warning",
                    reportOptionalCall = "none",
                },
            },
        },
    },
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
require("clangd_extensions").setup {
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
                type = "???",
                declaration = "???",
                expression = "???",
                specifier = "???",
                statement = "???",
                ["template argument"] = "???",
            },
            {
                Compound = "???",
                Recovery = "???",
                TranslationUnit = "???",
                PackExpansion = "???",
                TemplateTypeParm = "???",
                TemplateTemplateParm = "???",
                TemplateParamObject = "???",
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
