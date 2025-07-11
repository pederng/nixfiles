return {
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup()
		end,
	},
	{
		"johnseth97/codex.nvim",
		lazy = true,
		keys = {
			{
				"<leader>cc",
				function()
					require("codex").toggle()
				end,
				desc = "Toggle Codex popup",
			},
		},
		opts = {
			keymaps = {}, -- disable internal mapping
			border = "rounded", -- or 'double'
			width = 0.8,
			height = 0.8,
			autoinstall = true,
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		opts = {
			provider = "copilot",
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
				config = function()
					require("render-markdown").setup()
					vim.api.nvim_create_autocmd("FileType", {
						pattern = "markdown",
						callback = function(event)
							vim.treesitter.start(event.buf, "markdown")
						end,
					})
				end,
			},
		},
	},
}
