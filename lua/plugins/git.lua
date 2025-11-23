return {
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'lewis6991/gitsigns.nvim',
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
    opts = {
      graph_style = 'kitty',
      git_services = {
        ['fhh-infra.de'] = {
          pull_request = 'https://gitlab.int.fhh-infra.de/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}',
          commit = 'https://gitlab.int.fhh-infra.de/${owner}/${repository}/-/commit/${oid}',
          tree = 'https://gitlab.int.fhh-infra.de/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads',
        },
      },
    },
  },
}
