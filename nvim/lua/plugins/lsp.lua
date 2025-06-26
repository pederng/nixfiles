return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local bufopts = { noremap = true, silent = true, buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
					vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
					vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
					require("lsp_signature").on_attach({
						bind = true,
						handler_opts = { border = "rounded" },
					}, ev.buf)
				end,
			})
		end,
	},

	{ "lukas-reineke/lsp-format.nvim" },
	{ "onsails/lspkind.nvim" },
	{ "ray-x/lsp_signature.nvim" },
	{ "folke/lsp-colors.nvim",        branch = "main" },
	{
		"lewis6991/hover.nvim",
		config = function()
			require("hover").setup({
				init = function()
					require("hover.providers.lsp")
				end,
				preview_opts = { border = nil },
				title = true,
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		branch = "main",
		config = function()
			local null_ls = require('null-ls')
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.diagnostics.statix,
					-- null_ls.builtins.code_actions.statix,
					null_ls.builtins.formatting.alejandra,
					null_ls.builtins.diagnostics.codespell.with({
						extra_args = { "-L", "nin,bu,tigger" }
					}),
				}
			})
		end,
	},
}
