local keymap = vim.keymap.set
local remap = { remap = true }
local silent = { silent = true }

keymap('n', '<space>', '<Nop>')
keymap('n', '<leader>h', ':nohlsearch<CR><C-L>')
keymap('v', '.', ':norm.<CR>')
keymap('i', 'jk', '<ESC>')
keymap('n', 'Q', '<NOP>')
keymap('n', '<leader>p', ':set paste<CR>o<esc>"*]p:set nopaste<cr>')

--Force hjkl usage
keymap('n', '<Up>', '<NOP>')
keymap('n', '<Down>', '<NOP>')
keymap('n', '<Left>', '<NOP>')
keymap('n', '<Right>', '<NOP>')
keymap('i', '<Up>', '<NOP>')
keymap('i', '<Down>', '<NOP>')
keymap('i', '<Left>', '<NOP>')
keymap('i', '<Right>', '<NOP>')

keymap('n', '<leader>bd', ':bp<CR>:bd #<CR>')
keymap('n', '<C-h>', '<C-w>h', remap)
keymap('n', '<C-j>', '<C-w>j', remap)
keymap('n', '<C-k>', '<C-w>k', remap)
keymap('n', '<C-l>', '<C-w>l', remap)

keymap('n', '<C-p>', ':Telescope<cr>', silent)
keymap('n', '<C-p><C-p>', ':Telescope<cr>', silent)
keymap('n', '<C-p><C-t>', ':Telescope lsp_dynamic_workspace_symbols<cr>', silent)
keymap('n', '<C-p><C-o>', ':Telescope lsp_document_symbols<cr>', silent)
keymap('n', 'r<C-]>', ':Telescope lsp_references<CR>', silent)
keymap('n', '<C-p><C-f>', ':Telescope git_files<cr>', silent)
keymap('n', '<C-p><C-g>', ':Telescope live_grep<cr>', silent)
keymap('n', '<C-p><C-h>', ':Telescope oldfiles<cr>', silent)
keymap('n', '<C-p><C-b>', ':Telescope buffers<cr>', silent)
keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', silent)
keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', silent)
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', silent)
keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', silent)
keymap("n", "<C-x><C-x>", "<cmd>Trouble<cr>", silent)
keymap("n", "<C-x><C-w>", "<cmd>Trouble workspace_diagnostics<cr>", silent)
keymap("n", "<C-x><C-d>", "<cmd>Trouble document_diagnostics<cr>", silent)
keymap("n", "<C-x><C-l>", "<cmd>Trouble loclist<cr>", silent)
keymap("n", "<C-x><C-q>", "<cmd>Trouble quickfix<cr>", silent)

keymap('n', '<C-y>', require('hover').hover, { desc = 'hover.nvim' })
