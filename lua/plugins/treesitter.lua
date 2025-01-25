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
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
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
        'kotlin',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'scala',
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
          enable = false,
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
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
      skipInsignificantPunctuation = true,
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
    event = 'VeryLazy',
    keys = {
      { '<leader>wk', '<cmd>Treewalker Up<cr>', desc = 'Up' },
      { '<leader>wj', '<cmd>Treewalker Down<cr>', desc = 'Down' },
      { '<leader>wh', '<cmd>Treewalker Left<cr>', desc = 'Left' },
      { '<leader>wl', '<cmd>Treewalker Right<cr>', desc = 'Right' },
      { '<leader>wK', '<cmd>Treewalker SwapUp<cr>', desc = 'Swap Up' },
      { '<leader>wJ', '<cmd>Treewalker SwapDown<cr>', desc = 'Swap Down' },
      { '<leader>wH', '<cmd>Treewalker SwapLeft<cr>', desc = 'Swap Left' },
      { '<leader>wL', '<cmd>Treewalker SwapRight<cr>', desc = 'SwapRight' },
    },
    opts = {},
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
