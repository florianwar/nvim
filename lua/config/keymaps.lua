local map = vim.keymap.set

-- better Redo
map('n', 'U', '<C-r>', { desc = 'Redo', noremap = true })

-- use jk/kj to escape
map({ 'i', 'c' }, 'jk', '<ESC>')
map({ 'i', 'c' }, 'kj', '<ESC>')

-- Move to window using the <ctrl> hjkl keys -> Handled by Kitty-navigator
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Resize window using arrow keys
map('n', '<Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

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

-- Remap German keyboard Umlauts to smth more useful
map({ 'i', 'v', 'n' }, 'ö', '{')
map({ 'i', 'v', 'n' }, 'Ö', '[')
map({ 'i', 'v', 'n' }, 'ä', '}')
map({ 'i', 'v', 'n' }, 'Ä', ']')
map({ 'i', 'v', 'n' }, 'ü', '\\')
map({ 'i', 'v', 'n' }, 'ü', '|')
map('i', '<C-ö>', 'ö', { noremap = true })
map('i', '<C-S-ö>', 'Ö', { noremap = true })
map('i', '<C-ä>', 'ä', { noremap = true })
map('i', '<C-S-ä>', 'Ä', { noremap = true })
map('i', '<C-ü>', 'ü', { noremap = true })
map('i', '<C-S-ü>', 'Ü', { noremap = true })

-- clear highlight with escape
map('n', '<esc>', '<cmd>noh<CR>')

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

-- save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = '[S]ave File' })

-- exit with leader-q
map('n', '<leader>q', '<cmd>qa<cr>', { desc = '[Q]uit' })
