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
      { 'yioneko/nvim-vtsls' },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          local telescope = require('telescope.builtin')

          map('gd', function()
            telescope.lsp_definitions() --{ jump_type = 'never' })
          end, '[G]oto [D]efinition')
          map('gr', function()
            telescope.lsp_references({ jump_type = 'never' })
          end, '[G]oto [R]eferences')
          map('gD', function()
            telescope.lsp_type_definitions() --{ jump_type = 'never' })
          end, '[G]oto Type [D]efinition')

          map('<leader>fs', telescope.lsp_document_symbols, 'Document [S]ymbols')
          map('<leader>fS', telescope.lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols')

          map('<leader>cr', vim.lsp.buf.rename, '[R]ename (Symbol)')
          map('<leader>ca', vim.lsp.buf.code_action, '[A]ction')

          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>k', vim.lsp.buf.signature_help, 'Signature Help')

          -- diagnostics
          map('<leader>cd', vim.diagnostic.open_float, '[D]iagnostic')
          map(']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')
          map('[d', vim.diagnostic.goto_prev, 'Prev [D]iagnostic')
          map(']e', function()
            vim.diagnostic.goto_next({ severity = 'ERROR' })
          end, 'Next [E]rror')
          map('[e', function()
            vim.diagnostic.goto_prev({ severity = 'ERROR' })
          end, 'Prev [E]rror')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Toggle InlayHints
          if client and client.server_capabilities.inlayHintProvider then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end

          -- Diagnostics
          vim.diagnostic.config({
            signs = {
              text = {
                [vim.diagnostic.severity.HINT] = ' ',
                [vim.diagnostic.severity.INFO] = ' ',
                [vim.diagnostic.severity.WARN] = ' ',
                [vim.diagnostic.severity.ERROR] = ' ',
              },
              numhl = {
                [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
                [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
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
        vtsls = {
          -- see: https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
              tsserver = {
                globalPlugins = {
                  {
                    name = '@angular/language-server',
                    location = require('mason-registry').get_package('angular-language-server'):get_install_path()
                      .. '/node_modules/@angular/language-server',
                    enableForWorkspaceTypeScriptVersions = false,
                  },
                },
              },
            },
            typescript = {
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                ariableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
        lua_ls = {
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

      require('lspconfig.configs').vtsls = require('vtsls').lspconfig

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            --HACK: disable rename for angularls due duplicate with ts
            if server_name == 'angularls' then
              server.capabilities.renameProvider = false
            end
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
        '<leader>cff',
        function()
          require('conform').format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end,
        mode = { 'n', 'v' },
        desc = '[F]ile or range [F]ormat',
      },
    },
    opts = {
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true, json = true, yaml = true, markdown = true }
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
  -- Commands for VSCode LSP
  {
    'yioneko/nvim-vtsls',
    event = 'BufReadPre',
    keys = {
      { '<leader>cio', '<cmd>VtsExec organize_imports<cr>', desc = '[I]mports [O]rganize' },
      { '<leader>cia', '<cmd>VtsExec add_missing_imports<cr>', desc = '[I]mports [A]dd missing' },
      { '<leader>cf', '<cmd>VtsExec fix_all<cr>', desc = '[F]ix All' },
      { '<leader>csr', '<cmd>VtsExec restart_tsserver<cr>', desc = '[S]erver [R]estart' },
      { '<leader>csl', '<cmd>VtsExec open_tsserver_log<cr>', desc = '[S]erver [L]ogs' },
      { '<leader>cfr', '<cmd>VtsExec file_references<cr>', desc = '[F]ile [R]eferences' },
    },
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
        desc = '[C]ompile Typescript',
      },
    },
    opts = {
      auto_open_qflist = true,
      use_trouble_qflist = true,
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
    keys = {
      {
        '<leader>ce',
        function()
          require('better-ts-errors').toggle()
        end,
        desc = 'Typescript [E]rrors',
      },
    },
    opts = {
      keymaps = {
        toggle = nil,
      },
    },
  },
}
