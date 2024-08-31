return {
  'florianwar/i18nvim',
  depends = {
    'hrsh7th/nvim-cmp',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    languages = { 'de', 'gb' },
    translation_source_patterns = {
      '**/i18n/*.json',
    },
  },
}
