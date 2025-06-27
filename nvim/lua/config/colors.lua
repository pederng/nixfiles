local fn = vim.fn
local cmd = vim.cmd

cmd("filetype plugin indent on")
cmd("syntax enable")

local default_theme = "base16-oceanicnext"

local function get_tinty_theme()
	local theme_name = vim.fn.system("tinty current &> /dev/null && tinty current")

	if vim.v.shell_error ~= 0 then
		return default_theme
	else
		return vim.trim(theme_name)
	end
end

local function handle_focus_gained()
	local new_theme_name = get_tinty_theme()
	local current_theme_name = vim.g.colors_name

	if current_theme_name ~= new_theme_name then
		vim.cmd("colorscheme " .. new_theme_name)
	end
end

local function apply_theme()
	vim.o.termguicolors = true
	vim.g.tinted_colorspace = 256
	local current_theme_name = get_tinty_theme()

	vim.cmd("colorscheme " .. current_theme_name)

	vim.api.nvim_create_autocmd("FocusGained", {
		callback = handle_focus_gained,
	})
end

apply_theme()

-- local M = require("base16-colorscheme")
-- local hi = M.highlight
-- hi.LineNr = { guifg = M.colors.base03, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.SignColumn = { guifg = M.colors.base03, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.GitGutterAdd = { guifg = M.colors.base0B, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.GitGutterChange = { guifg = M.colors.base0D, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.GitGutterDelete = { guifg = M.colors.base08, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.GitGutterChangeDelete = { guifg = M.colors.base0E, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.NormalFloat = { guifg = M.colors.base05, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.FloatBorder = { guifg = M.colors.base05, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.DiagnosticError = { guifg = M.colors.base0E, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.DiagnosticWarn = { guifg = M.colors.base08, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.DiagnosticInfo = { guifg = M.colors.base05, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.DiagnosticHint = { guifg = M.colors.base0C, guibg = M.colors.base01, gui = nil, guisp = nil }
-- hi.CmpItemAbbrDeprecated = { guifg = M.colors.base03, guibg = nil, gui = "strikethrough", guisp = nil }
-- hi.CmpItemAbbrMatch = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemAbbrMatchFuzzy = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemKindVariable = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemKindInterface = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemKindText = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemAbbrKindFunction = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemAbbrKindMethod = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemAbbrKindKeyword = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemKindProperty = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil }
-- hi.CmpItemKindUnit = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil }
--
-- hi.Operator = { guifg = M.colors.base0E, guibg = nil, gui = "none", guisp = nil }
--
-- hi.TelescopeBorder = { guifg = M.colors.base03, guibg = nil, gui = "none", guisp = nil }
-- hi.TelescopePromptBorder = { guifg = M.colors.base03, guibg = nil, gui = "none", guisp = nil }
-- hi.TelescopeResultsBorder = { guifg = M.colors.base03, guibg = nil, gui = "none", guisp = nil }
-- hi.TelescopePreviewBorder = { guifg = M.colors.base03, guibg = nil, gui = "none", guisp = nil }
