return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',
      { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename (Symbol)')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gK', vim.lsp.buf.signature_help, 'Signature Help')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Highlight References under cursor
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('my-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              desc = 'Highlight LSP references on cursor hold',
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              desc = 'Clear LSP references highlight on cursor move',
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- Toggle InlayHints
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end

          -- Diagnostics
          if client and client.server_capabilities.diagnosticProvider and vim.diagnostic then
            print('Setting up LSP Diagnostics')
            vim.diagnostic.config({
              signs = {
                text = {
                  [vim.diagnostic.severity.HINT] = ' ',
                  [vim.diagnostic.severity.INFO] = ' ',
                  [vim.diagnostic.severity.WARN] = ' ',
                  [vim.diagnostic.severity.ERROR] = ' ',
                },
              },
              float = {
                show_header = true,
                source = 'always',
                border = 'rounded',
                max_width = 120,
                max_height = 40,
                focusable = true,
              },
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('my-lsp-detach', { clear = true }),
        callback = function(event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'my-lsp-highlight', buffer = event.buf })
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        angularls = {},
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'none',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'none',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
          completions = {
            completeFunctionCalls = true,
          },
        },
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        'stylua',
        'prettierd',
        'prettier',
        --
        'shellcheck', -- sh
        'beautysh', -- bash
        'yamlfmt', -- yaml
        'taplo', -- toml
      })

      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
      })

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },
  -- Formatting with LSPs
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end,
        mode = { 'n', 'v' },
        desc = '[C]ode [F]ormat file or range',
      },
    },
    opts = {
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        svelte = { { 'prettierd', 'prettier' } },
        javascript = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        graphql = { { 'prettierd', 'prettier' } },
        markdown = { { 'prettierd', 'prettier' } },
        bash = { 'beautysh' },
        yaml = { 'yamlfmt' },
        toml = { 'taplo' },
        css = { { 'prettierd', 'prettier' } },
        scss = { { 'prettierd', 'prettier' } },
        sh = { { 'shellcheck' } },
      },
    },
  },
  -- Better Typescript support
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    keys = {
      { '<leader>cio', '<cmd>TSToolsOrganizeImports<cr>', desc = '[C]ode [I]mports [O]rganize' },
      { '<leader>cia', '<cmd>TSToolsAddMissingImports<cr>', desc = '[C]ode [I]mports [A]dd missing' },
      { '<leader>cf', '<cmd>TSToolsFixAll<cr>', desc = '[C]ode [F]ix All' },
    },
    opts = {},
  },
  -- Check whole project for Typescript errors
  {
    'dmmulroy/tsc.nvim',
    keys = {
      {
        '<leader>cc',
        function()
          require('tsc').run()
        end,
        desc = '[C]ode [C]ompile Typescript',
      },
    },
    opts = {
      auto_open_qflist = false,
    },
  },
  -- Support for package.json dependency management
  {
    'vuki656/package-info.nvim',
    event = 'BufRead package.json',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
  -- Angular LSP support
  {
    'joeveiga/ng.nvim',
    event = 'LspAttach',
    keys = function(plugin)
      return {
        { 'gat', plugin.goto_template_for_component, desc = '[G]oto [A]ngular [T]emplate', silent = true },
      }
    end,
    opts = {},
    config = function()
      local ng = require('ng')
      vim.keymap.set(
        'n',
        'gac',
        ng.goto_component_with_template_file,
        { desc = 'Angular: Goto Component', noremap = true, silent = true }
      )
      vim.keymap.set(
        'n',
        'gaT',
        ng.get_template_tcb,
        { desc = 'Angular: Compile Template', noremap = true, silent = true }
      )
    end,
  },
  {
    'OlegGulevskyy/better-ts-errors.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = {
      keymaps = {
        toggle = '<leader>ce',
      },
    },
  },
}
