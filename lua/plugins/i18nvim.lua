return {
  'florianwar/i18nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'grapp-dev/nui-components.nvim',
  },
  opts = {
    languages = { 'de', 'gb' },
    translation_source_patterns = {
      '**/i18n/*.json',
    },
  },
}
