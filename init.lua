-- Minimal Neovim config — hacker green-on-black theme

-- Basic editor options
vim.opt.number = true            -- show absolute line numbers
vim.opt.cursorline = true        -- highlight current line
vim.opt.wrap = false             -- disable line wrap
vim.opt.expandtab = true         -- use spaces instead of tabs
vim.opt.shiftwidth = 4           -- indent width
vim.opt.tabstop = 4              -- tab width
vim.opt.termguicolors = true     -- enable truecolor support

-- Dark background preference
vim.o.background = "dark"

-- Hacker green-on-black highlights
vim.cmd([[
highlight Normal       guibg=#000000 guifg=#00FF00 ctermbg=0 ctermfg=10
highlight LineNr       guibg=#000000 guifg=#00FF00 ctermbg=0 ctermfg=10
highlight CursorLine   guibg=#001100
highlight StatusLine   guibg=#000000 guifg=#00FF00
highlight Visual       guibg=#005500 guifg=#00FF00
highlight Comment      guifg=#00CC66 ctermfg=10
]])

-- Optional: leader key and quick save mapping
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

-- Optional: embedded terminal shortcut
vim.api.nvim_set_keymap('n', '<leader>t', ':split | terminal<CR>', { noremap = true, silent = true })