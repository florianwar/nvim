return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    lazy = false,
    priority = 1000,
    init = function(_)
      require('nvim-treesitter.query_predicates') -- ensure queries are initialized for other plugins
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      {
        'chrisgrieser/nvim-various-textobjs',
        opts = { keymaps = { useDefaults = true } },
      },
    },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { ']f', desc = 'Move to next [F]unction start' },
      { ']b', desc = 'Move to next [B]lock start' },
      { ']C', DESC = 'Move to next [C]lass start' },
      { ']B', desc = 'Move to next [B]lock end' },
      { ']F', desc = 'Move to next [F]unction end' },
      { ']C', desc = 'Move to next [C]lass end' },
      { '[f', desc = 'Move to previous [F]unction start' },
      { '[b', desc = 'Move to previous [B]lock start' },
      { '[c', desc = 'Move to previous [c]lass start' },
      { '[B', desc = 'Move to previous [B]lock end' },
      { '[F', desc = 'Move to previous [F]unction end' },
      { '[C', desc = 'Move to previous [C]lass end' },
      { '<bs>', desc = 'Decrement Selection', mode = 'x' },
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'angular',
        'bash',
        'c',
        'csv',
        'diff',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'scss',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']b'] = '@block.outer',
            [']c'] = '@class.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']B'] = '@block.outer',
            [']C'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[b'] = '@block.outer',
            ['[c'] = '@class.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[B'] = '@block.outer',
            ['[C'] = '@class.outer',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  -- Show Context for cursor
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter' },
    enabled = false,
    event = 'VeryLazy',
    opts = { enable = 'true', mode = 'cursor', max_lines = 4 },
  },
  -- Autoclose <tags></tags>
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter' },
    event = 'VeryLazy',
    opts = {},
  },
  -- Choose the right comment sting depending on treesitter context
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  --- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      scope = { enabled = true, show_start = false },
    },
  },
  -- Split / Join nodes
  {
    'wansmer/treesj',
    keys = {
      { 'J', '<cmd>TSJToggle<cr>', silent = false, noremap = true, desc = 'Split / Join nodes' },
    },
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
      max_join_length = 120,
    },
  },
  {
    'chrisgrieser/nvim-spider',
    opts = {
      skipInsignificantPunctuation = false,
    },
    keys = {
      {
        'e',
        mode = { 'n', 'o', 'x' },
        function()
          require('spider').motion('e')
        end,
        desc = 'Spider-e',
      },
      {
        'w',
        mode = { 'n', 'o', 'x' },
        function()
          require('spider').motion('w')
        end,
        desc = 'Spider-w',
      },
      {
        'b',
        mode = { 'n', 'o', 'x' },
        function()
          require('spider').motion('b')
        end,
        desc = 'Spider-b',
      },
    },
  },
  {
    'aaronik/treewalker.nvim',
    dependencies = { 'anuvyklack/hydra.nvim' },
    event = 'VeryLazy',
    config = function(_, opts)
      -- since hydra blocks the eventloop we need to disable the highlight
      require('treewalker').setup({ highlight = false })

      require('hydra')({
        name = 'Treewalker',
        config = {
          hint = false,
        },
        mode = 'n',
        body = '<c-f>',
        heads = {
          { 'h', '<cmd>Treewalker Left<cr>', { desc = 'Move node left' } },
          { 'j', '<cmd>Treewalker Down<cr>', { desc = 'Move node down' } },
          { 'k', '<cmd>Treewalker Up<cr>', { desc = 'Move node up' } },
          { 'l', '<cmd>Treewalker Right<cr>', { desc = 'Move node right' } },
          { 'H', '<cmd>TSTextobjectSwapPrevious @parameter.inner<CR>', { desc = 'Swap parameter ' } },
          { 'L', '<cmd>TSTextobjectSwapNext @parameter.inner<CR>', { desc = 'Swap parameter' } },
          { 'J', '<cmd>Treewalker SwapDown<cr>', { desc = 'Swap node down' } },
          { 'K', '<cmd>Treewalker SwapUp<cr>', { desc = 'Swap node up' } },
          { 'J', '<cmd>Treewalker SwapDown<cr>', { desc = 'Swap node down' } },
          { 'K', '<cmd>Treewalker SwapUp<cr>', { desc = 'Swap node up' } },
        },
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
