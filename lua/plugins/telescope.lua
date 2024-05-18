return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'debugloop/telescope-undo.nvim' },
      { 'xiyaowong/telescope-emoji.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          path_display = function(_, path)
            local filename = require('telescope.utils').path_tail(path)
            local location = require('plenary.strings').truncate(path, #path - #filename, '')
            local pathToDisplay = require('telescope.utils').transform_path({ path_display = { 'truncate' } }, location)
            path = string.format('%s %s ', filename, pathToDisplay)

            local highlights = {
              { { 0, #filename }, 'Field' },
              { { #filename, #path }, 'Comment' },
            }

            return path, highlights
          end,

          mappings = {
            i = {
              ['<esc>'] = require('telescope.actions').close,
              ['<c-t>'] = require('trouble.sources.telescope').open,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
            },
            n = { ['<c-t>'] = require('trouble.sources.telescope').open }, -- ['<C-q>'] = require('telescope.actions').close,
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          lsp_definitions = {
            initial_mode = 'normal',
            sorting_strategy = 'ascending',
            layout_strategy = 'vertical',
            results_title = false,
            layout_config = {
              width = 0.8,
              height = 0.8,
              prompt_position = 'top',
              mirror = true,
            },
          },
          lsp_references = {
            initial_mode = 'normal',
            sorting_strategy = 'ascending',
            layout_strategy = 'vertical',
            results_title = false,
            layout_config = {
              width = 0.8,
              height = 0.8,
              prompt_position = 'top',
              mirror = true,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'emoji')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
      vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind [T]elescope builtins' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set(
        'n',
        '<leader>fm',
        telescope.extensions.notify.notify,
        { desc = '[F]ind [M]essages (Notifications)' }
      )
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })

      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[F]ind [N]eovim files' })
      vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[ ] Find Files' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })
    end,
  },
}
