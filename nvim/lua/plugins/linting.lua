return {
	{
		"nvimtools/none-ls.nvim",
		branch = "main",
		config = function()
			local null_ls = require('null-ls')
			null_ls.setup({
				sources = {
					-- null_ls.builtins.diagnostics.mypy,
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.diagnostics.ansiblelint,
					null_ls.builtins.diagnostics.statix,
					null_ls.builtins.diagnostics.codespell.with({
						extra_args = { "-L", "nin,bu" }
					}),
				}
			})
		end,
	},
}
