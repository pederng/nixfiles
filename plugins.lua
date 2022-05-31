local keymap = vim.keymap.set
local cmd = vim.cmd
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- General Utils
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-unimpaired' }
  use { 'tpope/vim-speeddating' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-rsi' }
  use { 'ntpeters/vim-better-whitespace' }
  use { 'vim-scripts/ReplaceWithRegister' }
  use { 'christoomey/vim-system-copy' }
  use { 'christoomey/vim-tmux-navigator' }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-lua/plenary.nvim' }
  use { 'karb94/neoscroll.nvim' }

  -- Text objects
  use { 'kana/vim-textobj-user' }
  use { 'kana/vim-textobj-indent' }
  use { 'kana/vim-textobj-line' }
  use { 'kana/vim-textobj-entire' }
  use { 'michaeljsmith/vim-indent-object' }
  use { 'bps/vim-textobj-python' }

  -- Searching
  use { 'nvim-telescope/telescope.nvim' }

  -- LSP
  use { 'neovim/nvim-lspconfig' }
  use { 'folke/lsp-colors.nvim', branch = 'main' }
  use { 'hrsh7th/cmp-nvim-lsp', branch = 'main' }
  use { 'hrsh7th/cmp-buffer', branch = 'main' }
  use { 'hrsh7th/cmp-path', branch = 'main' }
  use { 'hrsh7th/cmp-cmdline', branch = 'main' }
  use { 'hrsh7th/nvim-cmp', branch = 'main' }
  use { 'jose-elias-alvarez/null-ls.nvim', branch = 'main' }
  use { 'onsails/lspkind.nvim' }
  use { 'ray-x/lsp_signature.nvim' }

  -- DB
  use { 'tpope/vim-dadbod' }

  -- File system
  use { 'tpope/vim-vinegar' }

  -- Git
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-rhubarb' }
  use { 'pwntester/octo.nvim' }
  use { 'lewis6991/gitsigns.nvim', branch = 'main' }

  -- Other langs
  use { 'sheerun/vim-polyglot' }
  use { 'nathangrigg/vim-beancount' }
  use { 'jjo/vim-cue' }
  use { 'ellisonleao/glow.nvim', branch = 'main' }

  -- Visuals
  use { 'folke/trouble.nvim', branch = 'main' }
  use { "folke/todo-comments.nvim", config = function()
    require("todo-comments").setup {}
  end
  }
  use { 'romgrk/nvim-treesitter-context' }
  use { 'nvim-lualine/lualine.nvim' }
  use { 'akinsho/bufferline.nvim', tag = '*' }
  use { 'RRethy/nvim-base16' }
  use { 'folke/tokyonight.nvim' }
  use { 'lewis6991/hover.nvim',
    config = function()
      require('hover').setup {
        init = function() require('hover.providers.lsp') end,
        preview_opts = { border = nil },
        title = true
      }
    end
  }

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)

local actions = require("telescope.actions")
require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      }
    }
  }
}
require('neoscroll').setup()
require('lualine').setup({})
require('trouble').setup({ mode = "document_diagnostics" })
require("bufferline").setup { options = { diagnostics = 'nvim_lsp' } }

local silent = { silent = true }
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', silent)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', silent)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'd<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', silent)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'r<C-]>', '<cmd>lua vim.lsp.buf.references()<CR>', silent)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-y>', '<cmd>lua vim.lsp.buf.hover()<CR>', silent)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', silent)
  require('lsp_signature').on_attach()
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = { 'pyright', 'ansiblels', 'bashls', 'dockerls', 'zk', 'sqls', 'rnix' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require 'lspconfig'.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
local cmp = require 'cmp'

local lspkind = require('lspkind')
cmp.setup({
  formatting = {
    format = lspkind.cmp_format(),
  },
  mapping = {
    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
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
  null_ls.builtins.diagnostics.pylint,
  null_ls.builtins.diagnostics.hadolint,
  null_ls.builtins.diagnostics.ansiblelint,
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.diagnostics.sqlfluff.with({
    extra_args = { "--dialect", "postgres" }
  }),
  null_ls.builtins.formatting.black,
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
      vim.lsp.util.apply_text_edits(res, bufnr, 'utf-8')
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
        end
      })
    end
  end,
})

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      keymap(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', function() gs.blame_line { full = true } end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>gd', gs.diffthis)
    map('n', '<leader>gD', function() gs.diffthis('~') end)
    map('n', '<leader>gd', gs.toggle_deleted)
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
