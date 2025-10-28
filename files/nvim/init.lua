-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- config
vim.o.number = true
vim.o.wrap = false
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.showmode = false
vim.o.mouse = 'a'
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldcolumn = '0'
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldenable = false
vim.o.foldnestmax = 4
vim.o.whichwrap = '[,],<,>,h,l'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup()
    end
  },

  -- Fuzzy finder (Telescope replaces fzf.vim)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup()
    end
  },

  -- Statusline (lualine is more modern than feline)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto'
        }
      })
    end
  },

  -- Git
  { 'tpope/vim-fugitive' },
  
  -- Comments (Comment.nvim is more feature-rich)
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  -- Rainbow brackets
  { 'luochen1990/rainbow' },

  -- Git signs (gitsigns replaces gitgutter - already in your config!)
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Pywal
  { 'AlphaTechnolog/pywal.nvim', name = 'pywal',
    config = function()
      require('pywal').setup()
    end
  },

  -- Completion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-vsnip' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/vim-vsnip' },

  -- LSP
  { 'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  { 'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup()
    end
  },
  { 'neovim/nvim-lspconfig' },

  -- Rust
  { 'simrat39/rust-tools.nvim',
    config = function()
      local rt = require('rust-tools')
      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<C-.>", rt.hover_actions.hover_actions, { buffer = bufnr })
          end
        }
      })
    end
  },
  { 'rust-lang/rust.vim' },

  -- Diagnostics
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Bufferline (better alternative to barbar)
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true
            }
          }
        }
      })
    end
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "lua", "rust", "toml" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      }
    end
  },

  -- Toggleterm for bottom terminal
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end
  },
})

-- LSP Keymaps (VSCode-like)
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Code actions (Ctrl+. and Ctrl+Space)
  vim.keymap.set('n', '<C-.>', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<C-Space>', vim.lsp.buf.code_action, opts)
  
  -- Rename (F2)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
  
  -- Go to definition (F12)
  vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, opts)
  
  -- Go to declaration (Ctrl+F12)
  vim.keymap.set('n', '<C-F12>', vim.lsp.buf.declaration, opts)
  
  -- Show hover (K)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  
  -- Go to implementation (Ctrl+I)
  vim.keymap.set('n', '<C-i>', vim.lsp.buf.implementation, opts)
  
  -- Show signature help
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  
  -- Find references (Shift+F12)
  vim.keymap.set('n', '<S-F12>', vim.lsp.buf.references, opts)
  
  -- Format document (Shift+Alt+F)
  vim.keymap.set('n', '<S-A-f>', function() vim.lsp.buf.format({ async = true }) end, opts)
  
  -- Show diagnostics in floating window
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  
  -- Go to next/previous diagnostic
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

-- Update rust-tools to use the on_attach
local rt = require('rust-tools')
rt.setup({
  server = {
    on_attach = on_attach,
  }
})

-- Setup LSP servers with vim.lsp.config (nvim 0.11+)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- You can add more LSP servers here using vim.lsp.config
-- Example for other LSP servers:
-- vim.lsp.config('pyright', {
--   cmd = { 'pyright-langserver', '--stdio' },
--   filetypes = { 'python' },
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })
-- vim.lsp.enable('pyright')

-- keymaps

-- Open Tree (Ctrl+b)
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Open Git (Ctrl+g)
vim.keymap.set('n', '<C-g>', ':Git<CR>', { noremap = true, silent = true })

-- Open Telescope (Ctrl+p)
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Open Find Across Files with Telescope (Ctrl+f)
vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', { noremap = true, silent = true })

-- Command palette (Ctrl+Shift+p) - opens Telescope commands
vim.keymap.set('n', '<C-S-p>', ':Telescope commands<CR>', { noremap = true, silent = true })

-- Quick command runner (Ctrl+Shift+r) - opens minimal height terminal that expands
vim.keymap.set('n', '<C-S-r>', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local mini_term = Terminal:new({
    direction = "horizontal",
    size = 3,
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
      
      -- Monitor terminal output and adjust size
      vim.api.nvim_create_autocmd("TermOpen", {
        buffer = term.bufnr,
        callback = function()
          local chan = vim.api.nvim_buf_get_var(term.bufnr, 'terminal_job_id')
          
          -- Auto-resize based on content
          local timer = vim.loop.new_timer()
          timer:start(100, 100, vim.schedule_wrap(function()
            if not vim.api.nvim_buf_is_valid(term.bufnr) then
              timer:stop()
              return
            end
            
            local lines = vim.api.nvim_buf_get_lines(term.bufnr, 0, -1, false)
            local non_empty = 0
            for _, line in ipairs(lines) do
              if line:match("%S") then
                non_empty = non_empty + 1
              end
            end
            
            local new_size = math.max(3, math.min(non_empty + 1, 20))
            if term:is_open() and vim.api.nvim_win_is_valid(term.window) then
              vim.api.nvim_win_set_height(term.window, new_size)
            end
          end))
        end,
      })
      
      -- Handle exit status
      vim.api.nvim_create_autocmd("TermClose", {
        buffer = term.bufnr,
        callback = function()
          local exit_code = vim.v.event.status
          if exit_code == 0 then
            vim.defer_fn(function()
              if term:is_open() then
                term:close()
              end
            end, 500)
          end
        end,
      })
    end,
  })
  mini_term:toggle()
end, { noremap = true, silent = true })

-- Toggle bottom terminal (Ctrl+`)
vim.keymap.set('n', '<C-`>', ':ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-`>', '<Cmd>ToggleTerm<CR>', { noremap = true, silent = true })

-- Open vertical terminal (Ctrl+Shift+`)
vim.keymap.set('n', '<C-S-`>', ':ToggleTerm direction=vertical size=80<CR>', { noremap = true, silent = true })

-- Close Current Panel (Ctrl+w)
vim.keymap.set('n', '<C-w>', ':close<CR>', { noremap = true, silent = true })

-- Move to next panel (Ctrl+Right)
vim.keymap.set('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- Move to previous panel (Ctrl+Left)
vim.keymap.set('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })

-- Move up/down panels
vim.keymap.set('n', '<C-Up>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { noremap = true, silent = true })

-- Set terminal to normal mode (Esc)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Fold block (Ctrl+])
vim.keymap.set('n', '<C-]>', 'za', { noremap = true, silent = true })

-- Unfold block (Ctrl+[)
vim.keymap.set('n', '<C-[>', 'zA', { noremap = true, silent = true })

-- Cycle tabs (using bufferline)
vim.keymap.set('n', '<C-Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- Close tab (using bufferline) - Note: conflicts with close panel above
vim.keymap.set('n', '<leader>w', ':bdelete<CR>', { noremap = true, silent = true })

-- Save file (Ctrl+s)
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })

-- Automatically use insert mode in the terminal
vim.api.nvim_create_autocmd({"TermOpen"}, {
  pattern = {"*"},
  command = "startinsert"
})

-- LSP Diagnostics Options Setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.cmd([[
  set signcolumn=yes
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

-- Completion setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  }),
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'nvim_lsp_signature_help'},
    { name = 'nvim_lua', keyword_length = 2},
    { name = 'buffer', keyword_length = 2 },
    { name = 'vsnip', keyword_length = 2 },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        vsnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
