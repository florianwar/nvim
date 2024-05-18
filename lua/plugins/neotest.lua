return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'folke/trouble.nvim',
      'nvim-neotest/neotest-plenary',
    },
    opts = function()
      return {
        adapters = {
          require('neotest-plenary'),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            require('trouble').open({ mode = 'quickfix', focus = false })
          end,
        },
      }
    end,
    keys = {
      {
        '<leader>nt',
        function()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        desc = '[N]eotest Run File',
      },
      {
        '<leader>nT',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = 'Run All Test Files',
      },
      {
        '<leader>nr',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run Nearest',
      },
      {
        '<leader>nl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run Last',
      },
      {
        '<leader>ns',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle Summary',
      },
      {
        '<leader>no',
        function()
          require('neotest').output.open({ enter = true, auto_close = true })
        end,
        desc = 'Show Output',
      },
      {
        '<leader>nO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Toggle Output Panel',
      },
      {
        '<leader>nS',
        function()
          require('neotest').run.stop()
        end,
        desc = 'Stop',
      },
    },
  },
}
