return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    name = 'catppuccin',
    --- @module 'catppuccin'
    --- @type CatppuccinOptions
    opts = {
      flavour = 'mocha',
      float = {
        transparent = true,
        solid = false,
      },
      transparent_background = true,
      no_italic = false,
      kitty = true,
      no_bold = false,
      no_underline = false,
      integrations = {
        cmp = true,
        blink_cmp = true,
        flash = true,
        dadbod_ui = true,
        diffview = true,
        neogit = true,
        harpoon = true,
        leap = true,
        lsp_trouble = false,
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
    opts = {},
  },
}
