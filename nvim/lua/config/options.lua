local set = vim.opt
local g = vim.g

set.number = true
set.relativenumber = true
set.cursorline = false
set.showcmd = true
set.textwidth = 100
set.wrap = false
set.termguicolors = true
set.autoread = true
set.shortmess:append("I")
set.updatetime = 100
g.mapleader = " "

set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.autoindent = true

set.incsearch = true
set.hlsearch = true
set.ignorecase = true
set.smartcase = true
set.showmatch = true

set.wildmenu = true
set.wildignore:append("*.swp,*~,._*,*.pyc,__pycache__")
set.wildignore:append("*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem")
set.wildignore:append("*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz")
set.completeopt = "menu,menuone,noselect"

set.swapfile = false
set.signcolumn = "yes"

set.splitbelow = true
set.splitright = true
set.hidden = true
g.netrw_fastbrowse = 0
g.netrw_browsex_viewer = "firefox"

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
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
