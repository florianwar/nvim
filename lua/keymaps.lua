local map = vim.keymap.set

-- better Redo
map('n', 'U', '<C-r>', { desc = 'Redo', noremap = true })

-- use jk/kj to escape
map({ 'i', 'c' }, 'jk', '<ESC>')

-- Move to window using the <ctrl> hjkl keys -> Handled by Kitty-navigator
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

map('n', ']t', '<cmd>tabnext<cr>', { desc = 'Next [T]ab' })
map('n', '[t', '<cmd>tabprevious<cr>', { desc = 'Previous [T]ab' })
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next Quickfix' })
map('n', '[q', '<cmd>cprevious<cr>', { desc = 'Previous [Q]uickfix' })

-- Resize window using arrow keys
map('n', '<Up>', '<cmd>resize +5<cr>', { desc = 'Increase Window Height' })
map('n', '<Down>', '<cmd>resize -5<cr>', { desc = 'Decrease Window Height' })
map('n', '<Left>', '<cmd>vertical resize -15<cr>', { desc = 'Decrease Window Width' })
map('n', '<Right>', '<cmd>vertical resize +15<cr>', { desc = 'Increase Window Width' })

-- Move Lines
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up', silent = true })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down', silent = true })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up', silent = true })
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down', silent = true })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up', silent = true })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down', silent = true })

-- keep movements in the middle -> Handled by mini-animate
-- map('n', '<c-d>', '<c-d>zz', { desc = 'Scroll Down' })
-- map('n', '<c-u>', '<c-u>zz', { desc = 'Scroll Up' })
-- map('n', 'n', 'nzzzv', { desc = 'Jump to Next' })
-- map('n', 'N', 'Nzzzv', { desc = 'Jump to Previous' })

map('n', '<leader><tab>', '<c-^>', { desc = 'Toggle last Buffers' })

-- clear highlight with escape
map('n', '<esc>', '<cmd>noh<CR>')

map('n', '<C-w>t', '<C-w>T', { desc = 'Move to new [T]ab' })
-- black hole delete and change
map({ 'n', 'x' }, 'c', [["_c]])
map('n', 'cc', [["_cc]])
map('n', 'C', [["_C]])
map({ 'n', 'x' }, 'd', [["_d]])
map('n', 'dd', [["_dd]])
map({ 'n', 'x' }, 'D', [["_D]])
map({ 'n', 'x' }, 'x', [["_x]])
map({ 'n', 'x' }, 'X', [["_X]])

-- cut with "m"
map({ 'n', 'x' }, 'm', 'd', { noremap = true })
map('n', 'mm', 'dd', { noremap = true })
map({ 'n', 'x' }, 'M', 'D', { noremap = true })

-- Jump to beginning and end of line
map({ 'n', 'o', 'x' }, 'H', '^', { desc = 'Jump to beginning of line' })
map({ 'n', 'o', 'x' }, 'L', 'g_', { desc = 'Jump to end of line' })

-- better indenting
map('n', '<', '<<')
map('v', '<', '<gv')
map('n', '>', '>>')
map('v', '>', '>gv')

--Replace highlighted text
map('v', 'r', '"hy:%s/<C-r>h//g<left><left>')

-- Execute macro over visual region.
map('x', '@', function()
  return ':norm @' .. vim.fn.getcharstr() .. '<cr>'
end, { expr = true })

-- save with ctrl-s
map({ 'n', 'i' }, '<c-s>', '<cmd>w<cr><esc>', { desc = '[S]ave File' })

-- exit with leader-q
map('n', '<leader>q', '<cmd>wqa<cr>', { desc = '[Q]uit' })
