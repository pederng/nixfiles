local keymap = vim.keymap.set
local fn = vim.fn
local cmd = vim.cmd

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
	-- General Utils
	{ "echasnovski/mini.nvim",           version = false },
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
	{ "karb94/neoscroll.nvim" },
	{ "freitass/todo.txt-vim" },

	-- -- Searching
	{ "nvim-telescope/telescope.nvim" },
	{ "nvim-pack/nvim-spectre",          dependencies = { "nvim-lua/plenary.nvim" } },

	-- -- LSP
	{ "neovim/nvim-lspconfig" },
	{ "folke/lsp-colors.nvim",           branch = "main" },
	{ "hrsh7th/cmp-nvim-lsp",            branch = "main" },
	{ "hrsh7th/cmp-buffer",              branch = "main" },
	{ "hrsh7th/cmp-path",                branch = "main" },
	{ "hrsh7th/cmp-cmdline",             branch = "main" },
	{ "hrsh7th/nvim-cmp",                branch = "main" },
	{ "nvimtools/none-ls.nvim",          branch = "main" },
	{ "onsails/lspkind.nvim" },
	{ "ray-x/lsp_signature.nvim" },
	{ "lukas-reineke/lsp-format.nvim" },

	-- -- File system
	{ "tpope/vim-vinegar" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},

	-- -- Git
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-rhubarb" },
	{ "lewis6991/gitsigns.nvim",       branch = "main" },

	-- -- Other langs
	{ "sheerun/vim-polyglot" },
	{ "nathangrigg/vim-beancount" },
	{ "jjo/vim-cue" },
	{ "luizribeiro/vim-cooklang" },
	{ "ellisonleao/glow.nvim",         branch = "main" },

	-- -- Visuals
	{ "folke/trouble.nvim",            branch = "main" },
	{ "folke/todo-comments.nvim" },
	{ "romgrk/nvim-treesitter-context" },
	{ "nvim-lualine/lualine.nvim" },
	{ "akinsho/bufferline.nvim",       version = "*" },
	{ "RRethy/nvim-base16" },
	{ "folke/tokyonight.nvim" },
	{ "lewis6991/hover.nvim" },
	{ "stevearc/dressing.nvim",        opts = {} },
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"rcarriga/nvim-notify",
	-- 	},
	-- },
})

require "nvim-treesitter.configs".setup {
	playground = {
		enable = true,
		disable = {},
		updatetime = 25,       -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = 'o',
			toggle_hl_groups = 'i',
			toggle_injected_languages = 't',
			toggle_anonymous_nodes = 'a',
			toggle_language_display = 'I',
			focus_language = 'f',
			unfocus_language = 'F',
			update = 'R',
			goto_node = '<cr>',
			show_help = '?',
		},
	}
}

local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
			},
		},
	},
})
require("mini.ai").setup()
require("mini.indentscope").setup()
require("mini.comment").setup()
require("mini.bufremove").setup()
require("neoscroll").setup()
require("lualine").setup({})
require("trouble").setup({ mode = "document_diagnostics" })
require("bufferline").setup({ options = { diagnostics = "nvim_lsp" } })
require("todo-comments").setup({})
require("spectre").setup({})
require("hover").setup({
	init = function()
		require("hover.providers.lsp")
	end,
	preview_opts = { border = nil },
	title = true,
})
require("lsp-format").setup {}

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "d<C-]>", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	require("lsp_signature").on_attach()
	require("lsp-format").on_attach(client, bufnr)
end


local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = { "ansiblels", "bashls", "dockerls", "zk", "ruff_lsp", "rnix", "terraformls" }
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
require("lspconfig").pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				autoImportCompletions = false,
			},
		},
	},
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require("cmp")

local lspkind = require("lspkind")
cmp.setup({
	formatting = {
		format = lspkind.cmp_format(),
	},
	mapping = {
		["<Tab>"] = function(fallback)
			if not cmp.select_next_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,
		["<S-Tab>"] = function(fallback)
			if not cmp.select_prev_item() then
				if vim.bo.buftype ~= "prompt" and has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end,
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local null_ls = require("null-ls")
local sources = {
	null_ls.builtins.diagnostics.mypy,
	null_ls.builtins.diagnostics.hadolint,
	null_ls.builtins.diagnostics.ansiblelint,
	null_ls.builtins.diagnostics.shellcheck,
	null_ls.builtins.diagnostics.statix,
	-- null_ls.builtins.formatting.black,
	-- null_ls.builtins.formatting.ruff,
	null_ls.builtins.formatting.terraform_fmt,
	null_ls.builtins.code_actions.gitsigns,
}

local async_formatting = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		{ textDocument = { uri = vim.uri_from_bufnr(bufnr) } },
		function(err, res)
			if err then
				local err_msg = type(err) == "string" and err or err.message
				vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
				return
			end

			if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
				return
			end

			if res then
				vim.lsp.util.apply_text_edits(res, bufnr, "utf-8")
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent noautocmd update")
				end)
			end
		end
	)
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					async_formatting(bufnr)
				end,
			})
		end
	end,
})

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			keymap(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>gS", gs.stage_buffer)
		map("n", "<leader>gu", gs.undo_stage_hunk)
		map("n", "<leader>gR", gs.reset_buffer)
		map("n", "<leader>gp", gs.preview_hunk)
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<leader>tb", gs.toggle_current_line_blame)
		map("n", "<leader>gd", gs.diffthis)
		map("n", "<leader>gD", function()
			gs.diffthis("~")
		end)
		map("n", "<leader>gd", gs.toggle_deleted)
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
