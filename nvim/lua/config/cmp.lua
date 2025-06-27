vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local function pumvisible()
			return tonumber(vim.fn.pumvisible()) ~= 0
		end

		---For replacing certain <C-x>... keymaps.
		local function feedkeys(keys)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
		end

		local function keymap(lhs, rhs, opts, mode)
			opts = type(opts) == "string" and { desc = opts }
				or vim.tbl_extend("error", opts --[[@as table]], { buffer = ev.buf })
			mode = mode or "n"
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

			-- Use enter to accept completions.
			keymap("<cr>", function()
				return pumvisible() and "<C-y>" or "<cr>"
			end, { expr = true }, "i")

			-- Use slash to dismiss the completion menu.
			keymap("/", function()
				return pumvisible() and "<C-e>" or "/"
			end, { expr = true }, "i")

			-- Navigate/trigger completions with <Tab>/<S-Tab>
			keymap("<Tab>", function()
				if pumvisible() then
					feedkeys("<C-n>")
				else
					if next(vim.lsp.get_clients({ bufnr = 0 })) then
						vim.lsp.completion.get()
					else
						feedkeys("<Tab>")
					end
				end
			end, {}, { "i", "s" })

			keymap("<S-Tab>", function()
				if pumvisible() then
					feedkeys("<C-p>")
				else
					feedkeys("<S-Tab>")
				end
			end, {}, { "i", "s" })
		end
	end,
})
