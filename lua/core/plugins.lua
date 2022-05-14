-- ULES TO FOLLOW
-- 1. use ({})
-- 2. lazy load ( see :h events )
-- 3. add comment or sections
-- 4. add disable option

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Cloning packer...\nSettting up NvHack")
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
			after = "nvim-base16.lua",
			disable = false,
		})

		-- Theme
		use({
			"bryant-the-coder/nvim-base16.lua",
			disable = false,
		})

		-- Bufferline
		use({
			"akinsho/bufferline.nvim",
			after = "nvim-web-devicons",
			event = "BufEnter",
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
			after = "nvim-treesitter",
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
			event = { "BufRead", "BufNewFile" },
			module = "nvim-treesitter",
			-- commit = "bca65c068b92f19174dbba15d538315e8c89a5d6",
			disable = false,
			run = ":TSUpdate",
			config = function()
				require("modules.lang.treesitter")
			end,
		})

		-- Vscode like rainbow parenthesis
		use({
			"p00f/nvim-ts-rainbow",
			after = "nvim-treesitter",
			event = "InsertEnter",
			opt = true,
			disable = false,
		})

		-- Auto complete tag
		use({
			"windwp/nvim-ts-autotag",
			opt = true,
			event = "InsertEnter",
			ft = { "html", "tsx" },
			disable = true,
		})

		use({
			"nvim-treesitter/nvim-treesitter-textobjects",
			after = "nvim-treesitter",
			event = "InsertEnter",
			opt = true,
			disable = false,
		})

		-- Complete pairs automatically
		use({
			"windwp/nvim-autopairs",
			after = "nvim-cmp",
			event = "InsertEnter",
			opt = true,
			disable = false,
			config = function()
				require("modules.completion.autopairs")
			end,
		})

		use({
			"nvim-treesitter/playground",
			cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
			after = "nvim-treesitter",
			opt = true,
			event = { "CursorMoved", "CursorMovedI" },
			disable = false,
		})

		use({
			"lewis6991/nvim-treesitter-context",
			after = "nvim-treesitter",
			event = "InsertEnter",
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
			module = "lspconfig",
			event = "BufRead",
			disable = false,
			tag = "v0.1.3",
			config = function()
				require("modules.lsp.init")
				require("modules.lsp.installer")
			end,
		})

		-- LSP installer
		use({
			"williamboman/nvim-lsp-installer",
			disable = false,
		})

		use({
			"max397574/lua-dev.nvim",
			module = "lua-dev",
			after = "nvim-lspconfig",
			disable = false,
		})

		use({
			"p00f/clangd_extensions.nvim",
			module = "clangd_extensions",
			disable = true,
			ft = { "cpp", "c" },
		})

		-- Formatting
		use({
			"Jose-elias-alvarez/null-ls.nvim",
			event = { "BufRead", "InsertEnter" },
			disable = false,
			config = function()
				require("modules.lang.null-ls")
			end,
		})

		-- Completion
		use({
			"hrsh7th/nvim-cmp",
			module = "cmp",
			event = { "InsertEnter", "CmdLineEnter", "InsertCharPre" }, -- InsertCharPre Due to luasnip
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
			requires = {
				"bryant-the-coder/friendly-snippets",
				event = "InsertEnter",
			},
			module = "luasnip",
			event = "InsertEnter",
			disable = false,
			config = function()
				require("modules.completion.snippets")
			end,
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
			module = "colorizer",
			ft = { "lua", "css", "scss", "html", "js", "jsx" },
			opt = true,
			config = function()
				require("modules.tools.colorizer")
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
			tag = "v1.*",
			config = function()
				require("modules.tools.toggleterm")
			end,
			opt = true,
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
			event = { "InsertEnter" },
			disable = false,
			config = function()
				require("modules.lang.trouble")
			end,
		})

		-- Neogen
		use({
			"danymat/neogen",
			after = "LuaSnip",
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
			disable = false,
			config = function()
				require("modules.tools.gitsigns")
			end,
		})

		-- Share code
		use({
			"rktjmp/paperplanes.nvim",
			event = "BufEnter",
			cmd = "PP",
			opt = true,
			disable = false,
			-- disable = true,
		})

		-- Faster movement
		use({
			"ggandor/lightspeed.nvim",
			event = "BufEnter",
			opt = true,
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
			config = function()
				require("modules.tools.fidget")
			end,
		})
	end,
	config = {
		profile = {
			enable = true,
			threshold = 0.0001,
		},
		display = {
			title = "Downloading / Updating", -- Packer, Installing
			done_sym = "",
			error_syn = "×",
			-- open_fn = function()
			--     require("packer.util").float({ border = border })
			-- end,
		},
		max_jobs = 6,
	},
})
