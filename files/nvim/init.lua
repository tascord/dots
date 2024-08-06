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

local vim = vim
local Plug = vim.fn['plug#']

-- plugins
vim.call('plug#begin')

Plug('nvim-tree/nvim-tree.lua')                       -- file tree
Plug('junegunn/fzf.vim')                              -- fuzzy finder
Plug('feline-nvim/feline.nvim')                       -- statusline
Plug('github/copilot.vim')                            -- copilot
Plug('nvim-telescope/telescope.nvim')                 -- telescope
Plug('tpope/vim-fugitive')                            -- git
Plug('tpope/vim-commentary')                          -- comments
Plug('luochen1990/rainbow')                           -- rainbow brackets
Plug('neovim/nvim-lspconfig')                         -- lsp
Plug('airblade/vim-gitgutter')                        -- gitgutter
Plug('AlphaTechnolog/pywal.nvim', {['as'] = 'pywal'}) -- pywal
Plug('nvim-lua/plenary.nvim')                         -- plenary

vim.call('plug#end')

require("nvim-tree").setup()
require('pywal').setup()
require('feline').setup()
require('telescope').setup()

-- keymaps

-- Open Tree (Ctrl+b)
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Open Git (Ctrl+g)
vim.api.nvim_set_keymap('n', '<C-g>', ':Git<CR>', { noremap = true, silent = true })

-- Open Telescope (Ctrl+p)
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Open Terminal in panel to right (Ctrl+`)
vim.api.nvim_set_keymap('n', '<C-`>', ':vsplit term://fish<CR>', { noremap = true, silent = true })

-- Close Current Panel (Ctrl+w)
vim.api.nvim_set_keymap('n', '<C-w>', ':close<CR>', { noremap = true, silent = true })

-- Move to next panel (Ctrl+Right)
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- Move to previous panel (Ctrl+Left)
vim.api.nvim_set_keymap('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })
