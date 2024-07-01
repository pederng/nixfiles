local keymap = vim.keymap.set
local silent = { silent = true }

keymap("n", "<space>", "<Nop>")
keymap("n", "<leader>h", ":nohlsearch<CR><C-L>")
keymap("v", ".", ":norm.<CR>")
keymap("i", "jk", "<ESC>")
keymap("n", "Q", "<NOP>")
keymap("n", "<leader>p", ':set paste<CR>o<esc>"*]p:set nopaste<cr>')

--Force hjkl usage
keymap("n", "<Up>", "<NOP>")
keymap("n", "<Down>", "<NOP>")
keymap("n", "<Left>", "<NOP>")
keymap("n", "<Right>", "<NOP>")
keymap("i", "<Up>", "<NOP>")
keymap("i", "<Down>", "<NOP>")
keymap("i", "<Left>", "<NOP>")
keymap("i", "<Right>", "<NOP>")

keymap("n", "<leader>bd", ":bp<CR>:bd #<CR>")
keymap("n", "<C-h>", ":TmuxNavigateLeft<CR>", silent)
keymap("n", "<C-j>", ":TmuxNavigateDown<CR>", silent)
keymap("n", "<C-k>", ":TmuxNavigateUp<CR>", silent)
keymap("n", "<C-l>", ":TmuxNavigateRight<CR>", silent)

keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", silent)
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", silent)
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", silent)
keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", silent)

keymap("n", "<C-x><C-x>", "<cmd>Trouble<cr>", silent)
keymap("n", "<C-x><C-w>", "<cmd>Trouble workspace_diagnostics<cr>", silent)
keymap("n", "<C-x><C-d>", "<cmd>Trouble document_diagnostics<cr>", silent)
keymap("n", "<C-x><C-l>", "<cmd>Trouble loclist<cr>", silent)
keymap("n", "<C-x><C-q>", "<cmd>Trouble quickfix<cr>", silent)

keymap("n", "<C-y>", require("hover").hover, { desc = "hover.nvim" })
