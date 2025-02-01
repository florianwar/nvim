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
      { 'nvim-telescope/telescope-frecency.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      local telescope = require('telescope')

      local path_display = function(_, path)
        local filename = require('telescope.utils').path_tail(path)
        local location = require('plenary.strings').truncate(path, #path - #filename, '')
        local pathToDisplay = require('telescope.utils').transform_path({ path_display = { 'truncate' } }, location)
        path = string.format('%s %s ', filename, pathToDisplay)

        local highlights = {
          { { 0, #filename }, 'Field' },
          { { #filename, #path }, 'Comment' },
        }

        return path, highlights
      end

      local lsp_picker = function(type)
        return {
          initial_mode = 'normal',
          sorting_strategy = 'ascending',
          layout_strategy = 'vertical',
          results_title = type or 'Results',
          prompt_title = false,
          layout_config = {
            width = 0.9,
            height = 0.9,
            prompt_position = 'top',
            preview_height = 0.75,
            mirror = true,
          },
        }
      end

      telescope.setup({
        defaults = {
          path_display = path_display,
          mappings = {
            i = {
              ['<esc>'] = require('telescope.actions').close,
              ['<c-q>'] = require('trouble.sources.telescope').open,
              ['<c-t>'] = require('telescope.actions').select_tab,
              ['<c-v>'] = require('telescope.actions').select_horizontal,
              ['<c-x>'] = require('telescope.actions').select_vertical,
              ['<c-u>'] = require('telescope.actions').preview_scrolling_up,
              ['<c-d>'] = require('telescope.actions').preview_scrolling_down,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
            },
            n = { ['<c-q>'] = require('trouble.sources.telescope').open }, -- ['<C-q>'] = require('telescope.actions').close,
          },
        },
        pickers = {
          find_files = {
            hidden = false,
          },
          live_grep = {
            hidden = false,
          },
          buffers = {
            sort_lastused = true,
            mappings = {
              i = {
                ['<c-d>'] = require('telescope.actions').delete_buffer,
              },
              n = {
                ['<c-d>'] = require('telescope.actions').delete_buffer,
              },
            },
          },
          lsp_definitions = lsp_picker('Definitions'),
          lsp_references = lsp_picker('References'),
          lsp_type_definitions = lsp_picker('Type Definitions'),
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
      pcall(telescope.load_extension, 'frecency')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
      vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind [T]elescope builtins' })
      vim.keymap.set('n', '<leader>fe', '<cmd>Telescope emoji<cr>', { desc = '[F]ind [E]moji' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
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
