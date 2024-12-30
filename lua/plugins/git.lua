return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    keys = function()
      local plugin = require('gitsigns')
      return {
        {
          ']h',
          function()
            plugin.nav_hunk('next')
          end,
          desc = 'Next Hunk',
        },
        {
          '[h',
          function()
            plugin.nav_hunk('prev')
          end,
          desc = 'Previous Hunk',
        },
        { '<leader>ghs', plugin.stage_hunk, desc = '[G]it [H]unk [S]tage' },
        { '<leader>ghu', plugin.undo_stage_hunk, desc = '[G]it [H]unk [U]nstage' },
        { '<leader>ghp', plugin.preview_hunk, desc = '[G]it [H]unk [P]review' },
        { '<leader>tb', plugin.toggle_current_line_blame, desc = '[T]oggle Git [B]lame (inline)' },
        {
          '<leader>gb',
          function()
            plugin.blame_line({ full = true })
          end,
          desc = '[G]it [B]lame',
        },
      }
    end,
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      stjjjatus_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'lewis6991/gitsigns.nvim',
    },
    opts = {
      keymaps = {
        view = {
          { 'n', 'q', '<cmd>set hidden<cr><cmd>DiffviewClose<cr><cmd>set nohidden<cr>' },
        },
        file_panel = {
          { 'n', 'q', '<cmd>set hidden<cr><cmd>DiffviewClose<cr><cmd>set nohidden<cr>' },
        },
        file_history_panel = {
          { 'n', 'q', '<cmd>set hidden<cr><cmd>DiffviewClose<cr><cmd>set nohidden<cr>' },
        },
      },
      view = {
        default = {
          layout = 'diff2_horizontal',
          disable_diagnostics = false,
          winbar_info = false,
        },
        merge_tool = {
          layout = 'diff3_mixed',
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = 'diff2_horizontal',
          disable_diagnostics = false,
          winbar_info = false,
        },
      },
    },
    keys = {
      { '<leader>gD', '<cmd>DiffviewFileHistory<CR>', desc = '[G]it [D]iff Repo' },
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff File' },
      {
        '<leader>gl',
        function()
          local current_line = vim.fn.line('.')
          local file = vim.fn.expand('%')
          -- DiffviewFileHistory --follow -L{current_line},{current_line}:{file}
          local cmd = string.format('DiffviewFileHistory --follow -L%s,%s:%s', current_line, current_line, file)
          vim.cmd(cmd)
        end,
        desc = '[G]it [L]ine',
      },
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    lazy = false,
    keys = {
      { '<leader>gg', '<cmd>Neogit<CR>', desc = '[G]it neo[G]it' },
    },
    config = true,
  },
}
