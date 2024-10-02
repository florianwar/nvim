return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    config = function()
      print(require('persistence').setup({}))

      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'PersistenceSavePre',
        callback = function()
          local delete_fts = { 'neo-tree' }
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.tbl_contains(delete_fts, vim.bo[buf].filetype) then
              vim.cmd('silent! bd ' .. buf)
            end
          end
        end,
      })
    end,
  },
}
