local keymap = vim.keymap.set
local silent = { silent = true }

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
		},
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
			require("telescope").load_extension("undo")
			keymap("n", "<C-p>", ":Telescope<cr>", silent)
			keymap("n", "<C-p><C-p>", ":Telescope<cr>", silent)
			keymap("n", "<C-p><C-t>", ":Telescope lsp_dynamic_workspace_symbols<cr>", silent)
			keymap("n", "<C-p><C-o>", ":Telescope lsp_document_symbols<cr>", silent)
			keymap("n", "r<C-]>", ":Telescope lsp_references<CR>", silent)
			keymap("n", "<C-p><C-f>", ":Telescope find_files<cr>", silent)
			keymap("n", "<C-p><C-g>", ":Telescope live_grep<cr>", silent)
			keymap("n", "<C-p><C-h>", ":Telescope oldfiles<cr>", silent)
			keymap("n", "<C-p><C-b>", ":Telescope buffers<cr>", silent)
			keymap("n", "<C-p><C-c>", ":Telescope commands<cr>", silent)
			keymap("n", "<C-p><C-u>", ":Telescope undo<cr>", silent)
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({ mode = "document_diagnostics" })
		end,
	},
	{
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},
}
