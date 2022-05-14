local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("modules.lsp.installer")
require("modules.lsp.config")

local function lsp_highlight_document(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.lsp.buf.document_highlight()
			end,
			buffer = bufnr,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = function()
				vim.lsp.buf.clear_references()
			end,
			buffer = bufnr,
		})
	end

	vim.api.nvim_set_hl(0, "LspReferenceText", { nocombine = true, reverse = false, underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { nocombine = true, reverse = false, underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { nocombine = true, reverse = false, underline = true })
end

local function on_attach(client, bufnr)
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false
	lsp_highlight_document(client, bufnr)
end

local function on_attach16(client, bufnr)
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false
	client.offset_encoding = "utf-16"
	lsp_highlight_document(client, bufnr)
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
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
local use_lua_dev = false
if use_lua_dev then
	local luadev = require("lua-dev").setup({
		library = {
			vimruntime = true,
			types = true,
			plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
		},
		lspconfig = sumneko,
	})

	lspconfig.sumneko_lua.setup(luadev)
else
	lspconfig.sumneko_lua.setup(sumneko)
end

-- JSON
lspconfig.jsonls.setup({
	on_attach = on_attach,
})

lspconfig.clangd.setup({
	on_attach = on_attach16,
	capabilities = capabilities,
})
