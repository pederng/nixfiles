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
	{ "kana/vim-textobj-entire", dependencies = { 'kana/vim-textobj-user' }},

	-- -- Searching
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

	-- -- LSP
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
					vim.keymap.set("n", "d<C-]>", vim.lsp.buf.definition, bufopts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
					vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
					vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
					require("lsp_signature").on_attach({
						bind = true,
						handler_opts = { border = "rounded" },
					}, ev.buf)
				end,
			})


			local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local servers = { "ansiblels", "bashls", "dockerls", "docker_compose_language_service", "rnix", "terraformls", "rust_analyzer"}
			for _, lsp in pairs(servers) do
				require("lspconfig")[lsp].setup({
					capabilities = capabilities,
				})
			end

			require("lspconfig").pyright.setup({
				capabilities = {
					textDocument = {
						publishDiagnostics = {
							tagSupport = {
								valueSet = { 2 },
							}
						}
					},
				},
				settings = {
					pyright = {
						disableOrganizeImports = true;  -- Use ruff
					},
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							autoImportCompletions = true,
						},
					},
				},
			})

			local function lsp_client(name)
				return assert(
					vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf(), name = name })[1],
					('No %s client found for the current buffer'):format(name)
				)
			end

			require("lspconfig").ruff_lsp.setup({
				commands = {
				RuffAutofix = {
					function()
						lsp_client('ruff_lsp').request("workspace/executeCommand", {
							command = 'ruff.applyAutofix',
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						})
					end,
					description = 'Ruff: Fix all auto-fixable problems',
				},
				RuffOrganizeImports = {
					function()
						lsp_client('ruff_lsp').request("workspace/executeCommand", {
							command = 'ruff.applyOrganizeImports',
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						})
					end,
					description = 'Ruff: Format imports',
				},
				},
			})

			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")

			require("lspconfig").lua_ls.setup({
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
		end,
	},
	{ "folke/lsp-colors.nvim",           branch = "main" },
	{ "hrsh7th/cmp-nvim-lsp",            branch = "main" },
	{ "hrsh7th/cmp-buffer",              branch = "main" },
	{ "hrsh7th/cmp-path",                branch = "main" },
	{ "hrsh7th/cmp-cmdline",             branch = "main" },
	{
		"hrsh7th/nvim-cmp",
		 branch = "main",
		 config = function()
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
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		branch = "main",
		config = function()
			local null_ls = require('null-ls')
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.mypy,
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.diagnostics.ansiblelint,
					null_ls.builtins.diagnostics.statix,
					null_ls.builtins.diagnostics.codespell.with({
							extra_args = { "-L", "nin,bu" }
						}),
				}})
		end,
	},
	{ "onsails/lspkind.nvim" },
	{ "ray-x/lsp_signature.nvim" },

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
	{ "will133/vim-dirdiff" },
	{
		"lewis6991/gitsigns.nvim",
		branch = "main",
		config = function()
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
		end,
	},
	{ "github/copilot.vim" },

	-- -- Other langs
	{ "sheerun/vim-polyglot" },
	{ "nathangrigg/vim-beancount" },
	{ "jjo/vim-cue" },
	{ "luizribeiro/vim-cooklang" },
	{ "ellisonleao/glow.nvim",         branch = "main" },

	-- -- Visuals
	{
		"folke/trouble.nvim",
		branch = "main",
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
	{ "romgrk/nvim-treesitter-context" },
	{ "nvim-lualine/lualine.nvim",
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
	{ "stevearc/dressing.nvim",        opts = {} },
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


