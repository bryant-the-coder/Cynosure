-- ULES TO FOLLOW
-- 1. use ({})
-- 2. lazy load ( see :h events )
-- 3. add comment or sections
-- 4. add disable option

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Cloning packer...\nSettting up config")
    vim.cmd([[packadd packer.nvim]])
end

return require("packer").startup({
    function(use)
        -- Packer can manage itself
        use({
            "wbthomason/packer.nvim",
        })

        -- Better performance
        use({
            "lewis6991/impatient.nvim",
            disable = false,
            config = function()
                require("modules.editor.impatient")
            end,
        })

        -- Dependencies
        use({
            "nvim-lua/plenary.nvim",
            disable = false,
        })
        use({
            "kyazdani42/nvim-web-devicons",
            module = "nvim-web-devicons",
            disable = false,
        })

        -- Theme
        use({
            "bryant-the-coder/base16",
            disable = false,
        })

        -- Bufferline
        use({
            "akinsho/bufferline.nvim",
            opt = true,
            setup = function()
                vim.api.nvim_create_autocmd({ "BufAdd", "TabEnter" }, {
                    pattern = "*",
                    group = vim.api.nvim_create_augroup("BufferLineLazyLoading", {}),
                    callback = function()
                        local count = #vim.fn.getbufinfo({ buflisted = 1 })
                        if count >= 2 then
                            vim.cmd([[PackerLoad bufferline.nvim]])
                        end
                    end,
                })
            end,
            disable = false,
            config = function()
                require("modules.ui.bufferline")
            end,
        })

        -- Neorg
        -- Notes taking
        use({
            "nvim-neorg/neorg",
            ft = "norg",
            after = "nvim-treesitter", -- You may want to specify Telescope here as well
            disable = false,
            config = function()
                require("modules.editor.neorg")
            end,
        })

        use({
            "max397574/neorg-kanban",
            after = "neorg",
        })

        use({
            "nvim-neorg/neorg-telescope",
            after = "neorg",
        })

        -- Explorer menu
        use({
            "kyazdani42/nvim-tree.lua",
            opt = true,
            cmd = "NvimTreeToggle",
            tag = "nightly",
            config = function()
                require("modules.files.nvim-tree")
            end,
            disable = false,
        })

        -- Treesitter
        use({
            "nvim-treesitter/nvim-treesitter",
            disable = false,
            ft = {
                "lua",
                "rust",
                "c",
                "cpp",
                "html",
                "css",
                "javascript",
                "typescript",
                "tex",
                "json",
            },
            run = ":TSUpdate",
            event = { "BufRead", "BufNewFile" },
            config = function()
                require("modules.lang.treesitter")
            end,
        })

        -- Vscode like rainbow parenthesis
        use({
            "p00f/nvim-ts-rainbow",
            after = "nvim-treesitter",
            opt = true,
            disable = false,
        })

        -- Auto complete tag
        use({
            "windwp/nvim-ts-autotag",
            opt = true,
            ft = { "html", "tsx" },
            disable = true,
        })

        -- Complete pairs automatically
        use({
            "windwp/nvim-autopairs",
            event = {
                "InsertEnter",
                -- for working with cmp
                "CmdLineEnter",
            },
            -- TODO: uncomment this
            after = "nvim-cmp",
            opt = true,
            disable = false,
            config = function()
                require("modules.completion.autopairs")
            end,
        })

        use({
            "nvim-treesitter/playground",
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
            opt = true,
            disable = false,
        })

        use({
            "lewis6991/nvim-treesitter-context",
            after = "nvim-treesitter",
            cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
        })

        -- LSP
        -- use({
        --     "williamboman/nvim-lsp-installer",
        --     disable = false,
        --     {
        --         "neovim/nvim-lspconfig",
        --         module = "lspconfig",
        --         event = "BufRead",
        --         disable = false,
        --         tag = "v0.1.3",
        --         config = function()
        --             require("plugins.config.lsp")
        --         end,
        --     },
        -- })
        use({
            "neovim/nvim-lspconfig",
            opt = true,
            ft = {
                "lua",
                "rust",
                "c",
                "cpp",
                "html",
                "css",
                "javascript",
                "typescript",
                "tex",
                "json",
            },
            config = function()
                require("modules.lsp.init")
                require("modules.lsp.installer")
            end,
        })

        -- LSP installer
        use({
            "williamboman/nvim-lsp-installer",
            ft = {
                "lua",
                "rust",
                "c",
                "cpp",
                "html",
                "css",
                "javascript",
                "typescript",
                "tex",
                "json",
            },
            disable = false,
        })

        use({
            "max397574/lua-dev.nvim",
            after = "nvim-lspconfig",
            disable = false,
        })

        use({
            "p00f/clangd_extensions.nvim",
            disable = false,
            ft = { "cpp", "c" },
        })

        -- Formatting
        --[[ use({
            "Jose-elias-alvarez/null-ls.nvim",
            event = { "BufRead", "InsertEnter" },
            disable = false,
            config = function()
                require("modules.lang.null-ls")
            end,
        } )]]

        use({
            "mhartington/formatter.nvim",
            cmd = "FormatWrite",
            setup = function()
                local group = vim.api.nvim_create_augroup("Formatter", {})
                vim.api.nvim_create_autocmd("BufWritePost", {
                    callback = function()
                        vim.cmd([[FormatWrite]])
                    end,
                    group = group,
                })
            end,
            config = function()
                require("modules.lang.formatter")
            end,
        })

        -- Completion
        use({
            "hrsh7th/nvim-cmp",
            event = { "InsertEnter", "CmdLineEnter" },
            after = { "LuaSnip" },
            disable = false,
            requires = {
                {
                    "saadparwaiz1/cmp_luasnip",
                    after = { "nvim-cmp" },
                },
                { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
                { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                { "hrsh7th/cmp-path", after = "nvim-cmp" },
            },
            config = function()
                require("modules.completion.cmp")
            end,
        })

        -- Snippet
        use({
            "L3MON4D3/LuaSnip",
            event = "InsertEnter",
            disable = false,
            config = function()
                require("modules.completion.snippets")
            end,
        })
        use({
            "bryant-the-coder/friendly-snippets",
            event = "InsertEnter",
        })

        -- Telescope
        -- Fuzzy-finder
        use({
            "nvim-telescope/telescope.nvim",
            disable = false,
            module = { "telescope", "modules.files.telescope" },
            cmd = "Telescope",
            config = function()
                require("modules.files.telescope")
            end,
        })
        use({
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make",
        })
        use({
            "nvim-telescope/telescope-file-browser.nvim",
        })

        -- Colorizer
        use({
            "norcalli/nvim-colorizer.lua",
            disable = false,
            ft = { "lua", "css", "scss", "html", "js", "jsx" },
            opt = true,
            config = function()
                require("modules.tools.colorizer")
            end,
        })
        use({
            "max397574/colortils.nvim",
            cmd = "Colortils",
            config = function()
                require("modules.tools.colortils")
            end,
        })

        -- Indentation
        use({
            "lukas-reineke/indent-blankline.nvim",
            event = "InsertEnter",
            disable = false,
            opt = true,
            config = function()
                require("modules.ui.indent")
            end,
        })

        -- Comment
        use({
            "numToStr/Comment.nvim",
            keys = {
                "gcc",
                "gc",
                "gcb",
                "gb",
                "gco",
                "gcO",
            },
            opt = true,
            requires = {
                "JoosepAlviste/nvim-ts-context-commentstring",
                event = "InsertEnter",
            },
            disable = false,
            config = function()
                require("modules.editor.comment")
            end,
        })

        -- Terminal
        use({
            "akinsho/toggleterm.nvim",
            keys = "<c-b>",
            module = { "toggleterm" },
            config = function()
                require("modules.tools.toggleterm")
            end,
            disable = false,
        })

        -- Harpoon
        use({
            "bryant-the-coder/harpoon",
            module = "harpoon",
            opt = true,
            after = "telescope.nvim",
            disable = false,
            config = function()
                require("modules.files.harpoon")
            end,
        })

        -- Finding errors easily
        use({
            "folke/trouble.nvim",
            cmd = {
                "Trouble",
                "TroubleRefresh",
                "TroubleClose",
                "TroubleToggle",
            },
            opt = true,
            disable = false,
            config = function()
                require("modules.lang.trouble")
            end,
        })

        -- Neogen
        use({
            "danymat/neogen",
            -- after = { "LuaSnip" },
            command = "Neogen",
            disable = false,
            config = function()
                require("modules.lang.neogen")
            end,
        })

        -- Git intergrations
        use({
            "lewis6991/gitsigns.nvim",
            event = "BufRead",
            opt = true,
            -- opt = true,
            --[[setup = function()
                vim.api.nvim_create_autocmd({ "BufAdd", "VimEnter" }, {
                    -- vim.api.nvim_create_autocmd({ "BufAdd" }, {
                    callback = function()
                        local function onexit(code, _)
                            if code == 0 then
                                vim.schedule(function()
                                    require("packer").loader("gitsigns.nvim")
                                end)
                            end
                        end
                        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        if lines ~= { "" } then
                            vim.loop.spawn("git", {
                                args = {
                                    "ls-files",
                                    "--error-unmatch",
                                    vim.fn.expand("%"),
                                },
                            }, onexit)
                        end
                    end,
                })
            end, ]]
            disable = false,
            config = function()
                require("modules.tools.gitsigns")
            end,
        })

        -- Share code
        use({
            "rktjmp/paperplanes.nvim",
            cmd = "PP",
            disable = false,
        })

        -- Faster movement
        use({
            "ggandor/lightspeed.nvim",
            keys = { "S", "s", "f", "F", "t", "T" },
            disable = false,
        })

        -- Notifications
        use({
            "rcarriga/nvim-notify",
            opt = true,
            event = "BufEnter",
            disable = false,
            config = function()
                require("modules.ui.notify")
            end,
        })

        use({
            "j-hui/fidget.nvim",
            disable = false,
            module = "lspconfig",
            config = function()
                require("modules.tools.fidget")
            end,
        })

        -- Install packer and plugins if it does not exist
        if BOOTSTRAP then
            require("packer").sync()
        end
    end,
    config = {
        profile = {
            enable = true,
            threshold = 0.0001,
        },
        display = {
            title = "Packer", -- Packer, Installing
            done_sym = "",
            error_syn = "×",
            -- open_fn = function()
            --     require("packer.util").float({ border = border })
            -- end,
        },
        max_jobs = 6,
    },
})
