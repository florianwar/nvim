---@module 'snacks'
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    enabled = true,
    ---@type snacks.Config
    opts = {
      dim = {
        filter = function()
          return false
        end,
      },
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      images = { enabled = true },
      indent = {
        enabled = false,
        chunk = { enabled = false },
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        level = vim.log.levels.INFO,
      },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = false },
      scratch = {
        enabled = true,
        ft = 'markdown',
      },
      styles = {
        notification = {
          relative = 'editor',
          wo = { wrap = true }, -- Wrap notifications
        },
      },
    },
    keys = {
      {
        '<leader>z',
        function()
          Snacks.zen()
        end,
        desc = 'Toggle Zen Mode',
      },
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>S',
        function()
          Snacks.scratch.select()
        end,
        desc = 'Select Scratch Buffer',
      },
      {
        '<leader>tm',
        function()
          Snacks.notifier.show_history()
        end,
        desc = '[M]essages',
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = '[B]rowse',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = '[B]lame Line',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit [F]ile History',
      },
      {
        '<leader>gG',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazy[G]it',
      },
      {
        '<leader>gL',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Lazygit Log (cwd)',
      },

      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
        end,
      })
    end,
  },
}
