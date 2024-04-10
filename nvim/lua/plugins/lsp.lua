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


			local async_formatting = function(bufnr)
				bufnr = bufnr or vim.api.nvim_get_current_buf()
				vim.lsp.buf_request(
					bufnr,
					"textDocument/formatting",
					vim.lsp.util.make_formatting_params(),
					function(err, res, ctx)
						if err then
							local err_msg = type(err) == "string" and err or err.message
							vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
							return
						end

						if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
							return
						end

						if res then
							local client = vim.lsp.get_client_by_id(ctx.client_id)
							vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
							vim.api.nvim_buf_call(bufnr, function()
								vim.cmd("silent noautocmd update")
							end)
						end
					end
				)
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local servers = {
				ansiblels = {},
				bashls = {},
				dockerls = {},
				docker_compose_language_service = {},
				terraformls = {},
				rust_analyzer = {},
				nixd = {},
				pyright = {
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
							disableOrganizeImports = true, -- Use ruff
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
			local format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			for lsp, config in pairs(servers) do
				require("lspconfig")[lsp].setup({
					capabilities = config.capabilities or capabilities,
					settings = config.settings,
				})
			end

			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.lua",
				callback = function()
					vim.lsp.buf.format()
				end,
			})

			local function lsp_client(name)
				return assert(
					vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf(), name = name })[1],
					('No %s client found for the current buffer'):format(name)
				)
			end

			local function ruff_organize_imports()
				lsp_client('ruff_lsp').request("workspace/executeCommand", {
					command = 'ruff.applyOrganizeImports',
					arguments = {
						{ uri = vim.uri_from_bufnr(0) },
					},
				})
			end

			require("lspconfig").ruff_lsp.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.hoverProvider = false
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = format_augroup,
							buffer = bufnr,
							callback = function()
								async_formatting(bufnr)
								ruff_organize_imports()
							end,
						})
					end
				end,
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
				},
			})
		end,
	},

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
					"ruff_lsp",
					"lua_ls",
				},
			})
		end,
	},

	{ "onsails/lspkind.nvim" },
	{ "ray-x/lsp_signature.nvim" },
	{ "folke/lsp-colors.nvim",   branch = "main" },
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
