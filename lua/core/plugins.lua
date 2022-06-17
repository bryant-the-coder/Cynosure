-- ULES TO FOLLOW
-- 1. use ({})
-- 2. lazy load ( see :h events )
-- 3. add comment or sections
-- 4. add disable option

local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Cloning packer...\nSettting up config"
    vim.cmd [[packadd packer.nvim]]
end

return require("packer").startup {
    function(use)
        -----------------------------------
        --              Core             --
        -----------------------------------
        use {
            "wbthomason/packer.nvim",
        }

        -----------------------------------
        --          Dependencies         --
        -----------------------------------
        use {
            "nvim-lua/plenary.nvim",
            module = "plenary",
            disable = false,
        }
        use {
            "kyazdani42/nvim-web-devicons",
            module = "nvim-web-devicons",
            config = function()
                require "modules.ui.devicons"
            end,
            disable = false,
        }

        -- Theme
        use {
            "bryant-the-coder/base16",
            disable = false,
        }

        use {
            "MunifTanjim/nui.nvim",
            opt = true,
        }

        -----------------------------------
        --           Completion          --
        -----------------------------------
        -- CMP
        use {
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
                require "modules.completion.cmp"
            end,
        }

        -- Snippets
        use {
            "L3MON4D3/LuaSnip",
            event = "InsertEnter",
            disable = false,
            config = function()
                require "modules.completion.snippets"
            end,
        }
        use {
            "bryant-the-coder/friendly-snippets",
            event = "InsertEnter",
        }

        -- Autopairs
        use {
            "windwp/nvim-autopairs",
            event = {
                "InsertEnter",
                -- for working with cmp
                "CmdLineEnter",
            },
            after = "nvim-cmp",
            opt = true,
            disable = false,
            config = function()
                require "modules.completion.autopairs"
            end,
        }

        -----------------------------------
        --             Editor            --
        -----------------------------------
        -- Impatient
        use {
            "lewis6991/impatient.nvim",
            disable = false,
            config = function()
                require "modules.editor.impatient"
            end,
        }

        -- Comment
        use {
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
                require "modules.editor.comment"
            end,
        }

        -- Neorg
        use {
            "nvim-neorg/neorg",
            ft = "norg",
            after = "nvim-treesitter", -- You may want to specify Telescope here as well
            disable = false,
            config = function()
                require "modules.editor.neorg"
            end,
        }
        use {
            "max397574/neorg-kanban",
            after = "neorg",
        }
        use {
            "nvim-neorg/neorg-telescope",
            after = "neorg",
        }

        -----------------------------------
        --              Files            --
        -----------------------------------
        -- Nvim-Tree
        use {
            "kyazdani42/nvim-tree.lua",
            opt = true,
            cmd = "NvimTreeToggle",
            tag = "nightly",
            config = function()
                require "modules.files.nvim-tree"
            end,
            disable = false,
        }

        use {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            cmd = { "Neotree", "NeoTreeShow", "NeoTreeFocus", "NeoTreeFocusToggle" },
            config = function()
                require "modules.files.neo-tree"
            end,
        }

        -- Harpoon
        use {
            "bryant-the-coder/harpoon",
            opt = true,
            disable = false,
            config = function()
                require "modules.files.harpoon"
            end,
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            disable = false,
            module = { "telescope", "modules.files.telescope" },
            cmd = "Telescope",
            config = function()
                require "modules.files.telescope"
            end,
        }
        use {
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make",
            after = "telescope.nvim",
        }
        use {
            "nvim-telescope/telescope-file-browser.nvim",
            after = "telescope.nvim",
        }

        -----------------------------------
        --            Language           --
        -----------------------------------
        -- Formatter
        use {
            "mhartington/formatter.nvim",
            disable = true,
            cmd = "FormatWrite",
            setup = function()
                local group = vim.api.nvim_create_augroup("Formatter", {})
                vim.api.nvim_create_autocmd("BufWritePost", {
                    callback = function()
                        vim.cmd [[FormatWrite]]
                    end,
                    group = group,
                })
            end,
            config = function()
                require "modules.lang.formatter"
            end,
        }

        -- Neogen
        use {
            "danymat/neogen",
            cmd = "Neogen",
            disable = false,
            config = function()
                require "modules.lang.neogen"
            end,
        }

        -- Null-ls
        use {
            "Jose-elias-alvarez/null-ls.nvim",
            event = { "InsertEnter" },
            disable = false,
            config = function()
                require "modules.lang.null-ls"
            end,
        }

        -- Treesitter
        use {
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
                require "modules.lang.treesitter"
            end,
        }

        -- Vscode like rainbow parenthesis
        use {
            "p00f/nvim-ts-rainbow",
            after = "nvim-treesitter",
            opt = true,
            disable = false,
        }

        -- Auto complete tag
        use {
            "windwp/nvim-ts-autotag",
            opt = true,
            ft = { "html", "tsx" },
            disable = true,
        }

        use {
            "nvim-treesitter/playground",
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
            opt = true,
            disable = false,
        }

        use {
            "lewis6991/nvim-treesitter-context",
            after = "nvim-treesitter",
            cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
        }

        -- Trouble
        use {
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
                require "modules.lang.trouble"
            end,
        }

        -- LSP
        --[[ use({
            "williamboman/nvim-lsp-installer",
            disable = false,
            {
                "neovim/nvim-lspconfig",
                module = "lspconfig",
                event = "BufRead",
                disable = false,
                tag = "v0.1.3",
                config = function()
                    require("plugins.config.lsp")
                end,
            },
        }) ]]
        use {
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
                "python",
            },
            config = function()
                require "modules.lsp.init"
                require "modules.lsp.installer"
            end,
        }

        -- LSP installer
        use {
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
        }

        use {
            "max397574/lua-dev.nvim",
            after = "nvim-lspconfig",
            disable = false,
        }

        use {
            "p00f/clangd_extensions.nvim",
            disable = false,
            ft = { "cpp", "c" },
        }

        use {
            "ray-x/lsp_signature.nvim",
            after = "nvim-lspconfig",
            config = function()
                require "modules.lsp.signature"
            end,
        }

        -----------------------------------
        --             Tools             --
        -----------------------------------
        -- Colors the word
        use {
            "norcalli/nvim-colorizer.lua",
            disable = false,
            opt = true,
            setup = function()
                require("custom.load").colorizer()
            end,
            config = function()
                require "modules.tools.colorizer"
            end,
        }

        -- Change colors live in a window
        use {
            "max397574/colortils.nvim",
            cmd = "Colortils",
            config = function()
                require "modules.tools.colortils"
            end,
        }

        -- Show lsp progress when you enter a file
        use {
            "j-hui/fidget.nvim",
            disable = false,
            module = "lspconfig",
            config = function()
                require "modules.tools.fidget"
            end,
        }

        -- Terminal
        use {
            "akinsho/toggleterm.nvim",
            keys = "<c-b>",
            module = { "toggleterm" },
            config = function()
                require "modules.tools.toggleterm"
            end,
            disable = false,
        }

        -- Git intergrations
        use {
            "lewis6991/gitsigns.nvim",
            -- event = "BufRead",
            opt = true,
            setup = function()
                require("custom.load").gitsigns()
            end,
            disable = false,
            config = function()
                require "modules.tools.gitsigns"
            end,
        }

        -- Share code
        use {
            "rktjmp/paperplanes.nvim",
            cmd = "PP",
            disable = false,
        }

        -- Faster movement
        use {
            "ggandor/lightspeed.nvim",
            keys = { "S", "s", "f", "F", "t", "T" },
            disable = false,
        }

        use {
            "folke/todo-comments.nvim",
            event = "InsertEnter",
            config = function()
                require "modules.tools.todo"
            end,
        }

        -----------------------------------
        --               UI              --
        -----------------------------------
        -- Bufferline
        use {
            "akinsho/bufferline.nvim",
            opt = true,
            -- Taken from https://github.com/max397574/omega-nvim
            setup = function()
                require("custom.load").bufferline()
            end,
            disable = false,
            config = function()
                require "modules.ui.bufferline"
            end,
        }

        -- Indentation
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "InsertEnter",
            disable = false,
            opt = true,
            config = function()
                require "modules.ui.indent"
            end,
        }

        -- Notifications
        use {
            "rcarriga/nvim-notify",
            opt = true,
            event = "BufEnter",
            disable = false,
            config = function()
                require "modules.ui.notify"
            end,
        }

        use {
            "andweeb/presence.nvim",
            config = function()
                require "modules.editor.presence"
            end,
        }

        -- Install packer and plugins if it doesn't exist
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
            --[[ open_fn = function()
                return require("packer.util").float { border = "single" }
            end, ]]
        },
        max_jobs = 6,
    },
}
