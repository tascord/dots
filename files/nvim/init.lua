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
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldcolumn = '0'
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldenable = false
vim.o.foldnestmax = 4
vim.o.whichwrap = '[,],<,>'

local vim = vim
local Plug = vim.fn['plug#']

-- plugins
vim.call('plug#begin')

Plug('nvim-tree/nvim-tree.lua')                       -- file tree
Plug('junegunn/fzf.vim')                              -- fuzzy finder
Plug('feline-nvim/feline.nvim')                       -- statusline
Plug('nvim-telescope/telescope.nvim')                 -- telescope
Plug('tpope/vim-fugitive')                            -- git
Plug('tpope/vim-commentary')                          -- comments
Plug('luochen1990/rainbow')                           -- rainbow brackets
Plug('airblade/vim-gitgutter')                        -- gitgutter
Plug('AlphaTechnolog/pywal.nvim', {['as'] = 'pywal'}) -- pywal
Plug('nvim-lua/plenary.nvim')                         -- plenary
Plug('hrsh7th/nvim-cmp') 
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lua')
Plug('hrsh7th/cmp-nvim-lsp-signature-help')
Plug('hrsh7th/cmp-vsnip')            
Plug('hrsh7th/cmp-path')                            
Plug('hrsh7th/cmp-buffer')                            
Plug('hrsh7th/vim-vsnip')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')
Plug('simrat39/rust-tools.nvim')
Plug('folke/trouble.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('lewis6991/gitsigns.nvim')
Plug('romgrk/barbar.nvim')

Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}) -- treesitter

-- Rust
Plug('rust-lang/rust.vim')

vim.call('plug#end')

require("nvim-tree").setup()
require('pywal').setup()
require('feline').setup()
require('telescope').setup()
require('mason').setup()
require('mason-lspconfig').setup()

local rt = require('rust-tools')
rt.setup({
  server = {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<C-.>", rt.hover_actions.hover_actions, { buffer = bufnr })
      end
    }
})

require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true }, 
}

-- keymaps

-- Open Tree (Ctrl+b)
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Open Git (Ctrl+g)
vim.api.nvim_set_keymap('n', '<C-g>', ':Git<CR>', { noremap = true, silent = true })

-- Open Telescope (Ctrl+p)
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Open Find Across Files with Telescope (Ctrl+Shift+F)
vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope live_grep<CR>', { noremap = true, silent = true })

-- Open Terminal in panel to right (Ctrl+`)
vim.api.nvim_set_keymap('n', '<C-`>', ':vsplit term://fish<CR>', { noremap = true, silent = true })

-- Close Current Panel (Ctrl+w)
vim.api.nvim_set_keymap('n', '<C-w>', ':close<CR>', { noremap = true, silent = true })

-- Move to next panel (Ctrl+Right)
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- Move to previous panel (Ctrl+Left)
vim.api.nvim_set_keymap('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })

-- Set terminal to normal mode (Esc)
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Fold block (Ctrl+])
vim.api.nvim_set_keymap('n', '<C-]>', 'za', { noremap = true, silent = true })

-- Unfold block (Ctrl+[)
vim.api.nvim_set_keymap('n', '<C-[>', 'zA', { noremap = true, silent = true })

-- Cycle tabs
vim.api.nvim_set_keymap('n', '<C-Tab>', '<Cmd>BufferNext<Cr>', { noremap = true, silent = true })

-- Close tab
vim.api.nvim_set_keymap('n', '<C-w>', '<Cmd>BufferClose<Cr>', { noremap = true, silent = true })

-- Automatically use insert mode in the terminal
vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
  pattern = {"term://"},
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

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

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

local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
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
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
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

