local map = vim.keymap.set

-- Redo
map('n', 'U', '<C-r>', { desc = 'Redo', noremap = true })

-- use jk/kj to escape
map({ 'i', 'c' }, 'jk', '<ESC>')

-- Move Lines
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down', silent = true })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up', silent = true })
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down', silent = true })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up', silent = true })

-- keep movements in the middle -> Handled by mini-animate
-- map('n', '<c-d>', '<c-d>zz', { desc = 'Scroll Down' })
-- map('n', '<c-u>', '<c-u>zz', { desc = 'Scroll Up' })
-- map('n', 'n', 'nzzzv', { desc = 'Jump to Next' })
-- map('n', 'N', 'Nzzzv', { desc = 'Jump to Previous' })

map('n', '<leader><tab>', '<c-^>', { desc = 'Toggle last Buffers' })

-- clear highlight with escape -> Clashes with multicursor, handled there
-- map('n', '<esc>', '<cmd>noh<CR>')

-- black hole delete and change
map({ 'n', 'x' }, 'c', [["_c]])
map('n', 'cc', [["_cc]])
map('n', 'C', [["_C]])
map({ 'n', 'x' }, 'd', [["_d]])
map('n', 'dd', [["_dd]])
map({ 'n', 'x' }, 'D', [["_D]])
map({ 'n', 'x' }, 'x', [["_x]])
map({ 'n', 'x' }, 'X', [["_X]])

map('n', '[t', '<cmd>tabprev<cr>', { desc = 'Previous Tab' })
map('n', ']t', '<cmd>tabnext<cr>', { desc = 'Next Tab' })

-- cut with "m"
map({ 'n', 'x' }, 'm', 'd', { noremap = true })
map('n', 'mm', 'dd', { noremap = true })
map({ 'n', 'x' }, 'M', 'D', { noremap = true })

-- Jump to beginning and end of line
map({ 'n', 'o', 'x' }, 'H', '^', { desc = 'Jump to beginning of line' })
map({ 'n', 'o', 'x' }, 'L', 'g_', { desc = 'Jump to end of line' })
map('c', '<C-a>', '<C-b>', { desc = 'Start Of Line' })
map('i', '<C-a>', '<Home>', { desc = 'Start Of Line' })
map('i', '<C-e>', '<End>', { desc = 'End Of Line' })

-- Select all text
map('n', '<C-e>', 'gg<S-V>G', { desc = 'Select all Text', silent = true, noremap = true })

-- better indenting
map('n', '<', '<<')
map('v', '<', '<gv')
map('n', '>', '>>')
map('v', '>', '>gv')

-- Search visually selected text
map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]], { desc = 'Search Selected Text', silent = true })
map('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]], { desc = 'Search Selected Text (Backwards)', silent = true })

--Replace highlighted text
map('v', 'r', '"hy:%s/<C-r>h//g<left><left>')

-- Execute macro over visual region.
map('x', '@', function()
  return ':norm @' .. vim.fn.getcharstr() .. '<cr>'
end, { expr = true })

map('n', '<leader>tX', '<cmd>!chmod +x %<cr>', { desc = 'Make file e[X]ecutable' })

-- save with ctrl-s
map({ 'n', 'i' }, '<c-s>', '<cmd>w<cr><esc>', { desc = '[S]ave File' })

-- exit with leader-q
map('n', '<leader>q', '<cmd>wqa<cr>', { desc = '[Q]uit' })
