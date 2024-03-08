return {
	-- General Utils
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
	{ "tpope/vim-repeat" },
	{ "tpope/vim-surround" },
	{ "tpope/vim-unimpaired" },
	{ "tpope/vim-speeddating" },
	{ "tpope/vim-rsi" },
	{ "ntpeters/vim-better-whitespace" },
	{ "vim-scripts/ReplaceWithRegister" },
	{ "christoomey/vim-system-copy" },
	{ "christoomey/vim-tmux-navigator" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-treesitter/playground" },
	{ "nvim-lua/plenary.nvim" },
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	},
	{ "freitass/todo.txt-vim" },
	{ "kana/vim-textobj-entire", dependencies = { 'kana/vim-textobj-user' } },

	-- -- File system
	{ "tpope/vim-vinegar" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	-- -- Other langs
	{ "sheerun/vim-polyglot" },
	{ "nathangrigg/vim-beancount" },
	{ "jjo/vim-cue" },
	{ "luizribeiro/vim-cooklang" },
	{ "ellisonleao/glow.nvim",    branch = "main" },

	{
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},
	{ "romgrk/nvim-treesitter-context" },
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		config = function()
			require("bufferline").setup({ options = { diagnostics = "nvim_lsp" } })
		end,
	},
	{ "RRethy/nvim-base16" },
	{ "folke/tokyonight.nvim" },
	{ "stevearc/dressing.nvim", opts = {} },
}
