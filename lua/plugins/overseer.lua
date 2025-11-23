return {
  {
    'stevearc/overseer.nvim',
    keys = {
      {
        '<leader>to',
        '<cmd>OverseerOpen<cr>',
        desc = '[O]verseer',
      },
      {
        '<leader>co',
        '<cmd>OverseerRun<cr>',
        desc = '[O]verseer',
      },
    },
    opts = {
      task_list = {
        min_height = 15,
      },
    },
    config = function(_, opts)
      local overseer = require('overseer')
      overseer.setup(opts)

      overseer.register_template({
        name = 'eslint',
        description = 'Run ESLint',
        builder = function()
          --- @type overseer.TaskDefinition
          return {
            cmd = 'npm',
            args = { 'exec', '--', 'eslint' },
            components = {
              { 'unique' },
              { 'on_exit_set_status' },
              { 'on_output_parse', problem_matcher = '$eslint-stylish' },
              { 'on_result_diagnostics_quickfix', set_empty_results = true },
              { 'on_complete_notify' },
            },
          }
        end,
      })

      -- local parser_lib = require('overseer.parser.lib')

      overseer.register_template({
        name = 'ng serve',
        description = 'Run angular in dev mode',
        builder = function(params)
          --- @type overseer.TaskDefinition
          return {
            cmd = 'ng',
            args = { 'serve' },
            components = {
              { 'unique' },
              { 'on_exit_set_status' },
              -- {
              --   'on_output_parse',
              --   parser = {
              --     diagnostics = parser_lib.watcher_output('Build at:', 'Failed to compile.', {
              --       'extract',
              --       'Error: (.+):(%d+):(%d+) %- (.+)',
              --       'filename',
              --       'lnum',
              --       'col',
              --       'text',
              --     }, {}),
              --   },
              -- },
              { 'on_result_notify' },
              { 'on_result_diagnostics_quickfix', set_empty_results = true },
            },
          }
        end,
      })
    end,
  },
}
