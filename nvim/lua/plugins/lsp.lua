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


			local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local servers = {
				ansiblels = {},
				bashls = {},
				ruff = {},
				dockerls = {
					settings = {
						docker = {
							languageserver = {
								formatter = {
									ignoreMultilineInstructions = true,
								},
							},
						}
					}
				},
				docker_compose_language_service = {},
				terraformls = {},
				rust_analyzer = {},
				nixd = {},
				hls = {},
				pyright = {
					capabilities = {
						worksapce = {
							didChangeWatchedFiles = {
								dynamicRegistration = false,
							},
						},
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
							disableOrganizeImports = true, -- Use ruff
						},
						python = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
								autoImportCompletions = true,
							},
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
			}
			for lsp, config in pairs(servers) do
				require("lspconfig")[lsp].setup({
					capabilities = config.capabilities or capabilities,
					settings = config.settings,
					on_attach = require("lsp-format").on_attach,
				})
			end
		end,
	},

	{ "lukas-reineke/lsp-format.nvim" },
	{
		"williamboman/mason.nvim",
		desc = "https://mason-registry.dev/registry/list",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"VonHeikemen/lsp-zero.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
				},
			})
		end,
	},

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
					null_ls.builtins.diagnostics.codespell.with({
						extra_args = { "-L", "nin,bu" }
					}),
				}
			})
		end,
	},
}
