return {
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      require('which-key').add({
        { '<leader>m', group = '[M]ulticursor' },
      })

      local mc = require('multicursor-nvim')

      mc.setup()

      vim.keymap.set({ 'n', 'v' }, '<leader>mj', function()
        mc.addCursor('j')
      end, { desc = 'Add below' })
      vim.keymap.set({ 'n', 'v' }, '<leader>mk', function()
        mc.addCursor('k')
      end, { desc = 'Add above' })

      -- Add a cursor and jump to the next word under cursor.
      vim.keymap.set({ 'n', 'v' }, '<leader>ma', function()
        mc.addCursor('*')
      end, { desc = 'Add for next word' })

      -- Jump to the next word under cursor but do not add a cursor.
      vim.keymap.set({ 'n', 'v' }, '<leader>mN', function()
        mc.skipCursor('N')
      end, { desc = 'Skip to prev word' })

      vim.keymap.set({ 'n', 'v' }, '<leader>mn', function()
        mc.skipCursor('n')
      end, { desc = 'Skip to next word' })

      -- Rotate the main cursor.
      vim.keymap.set({ 'n', 'v' }, '<leader>mh', mc.nextCursor, { desc = 'previous cursor' })
      vim.keymap.set({ 'n', 'v' }, '<leader>ml', mc.prevCursor, { desc = 'next cursor' })

      -- Delete the main cursor.
      vim.keymap.set({ 'n', 'v' }, '<leader>md', mc.deleteCursor, { desc = 'delete cursor' })

      vim.keymap.set({ 'n', 'v' }, '<leader>mm', function()
        if mc.cursorsEnabled() then
          -- Stop other cursors from moving.
          -- This allows you to reposition the main cursor.
          mc.disableCursors()
        else
          mc.addCursor()
        end
      end, { desc = 'move main cursor only' })

      vim.keymap.set('n', '<leader>mq', '<c-c>', { silent = true, desc = 'end clue state' })

      -- Align cursor columns.
      vim.keymap.set('n', '<leader>mA', mc.alignCursors, { desc = 'Align column' })

      vim.keymap.set('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default behavior.
          vim.cmd('noh')
        end
      end)

      vim.keymap.set('n', '<c-leftmouse>', mc.handleMouse)

      -- Split visual selections by regex.
      vim.keymap.set('x', 'S', mc.splitCursors)

      -- Append/insert for each line of visual selections.
      vim.keymap.set('v', 'I', mc.insertVisual)
      vim.keymap.set('v', 'A', mc.appendVisual)

      -- match new cursors within visual selections by regex.
      vim.keymap.set('v', 'M', mc.matchCursors)

      vim.keymap.set('x', '<leader>t', function()
        mc.transposeCursors(1)
      end)
      vim.keymap.set('x', '<leader>T', function()
        mc.transposeCursors(-1)
      end)
      -- Rotate visual selection contents.

      -- Customize how cursors look.
      vim.api.nvim_set_hl(0, 'MultiCursorCursor', { link = 'Cursor' })
      vim.api.nvim_set_hl(0, 'MultiCursorVisual', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    end,
  },
}
