return {
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		branch = "main",
		config = function()
			require("trouble").setup({ mode = "document_diagnostics" })
		end,
	},
}
