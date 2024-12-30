return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    name = 'catppuccin',
    opts = {
      flavour = 'macchiato',
      transparent_background = true,
      no_italic = false,
      no_bold = false,
      no_underline = false,
      integrations = {
        cmp = true,
        flash = true,
        harpoon = true,
        leap = true,
        lsp_trouble = true,
        render_markdown = true,
        gitsigns = true,
        grug_far = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          inlay_hints = {
            background = true,
          },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        ufo = true,
        which_key = true,
      },
    },
  },
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = { -- set to setup table
    },
  },
}
