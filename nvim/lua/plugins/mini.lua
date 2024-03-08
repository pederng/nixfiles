return {
	{
		"echasnovski/mini.nvim",
		version = '*',
		config = function()
			require("mini.ai").setup()
			require("mini.indentscope").setup()
			require("mini.comment").setup()
			require("mini.bufremove").setup()
		end,
	},
}
