return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',
      { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
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
            virtual_text = true,
            float = {
              show_header = true,
              source = true,
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
        jsonls = {},
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = 'auto' },
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
        'eslint_d',
        'prettier',
        'prettierd',
        --
        'fixjson', -- json
        'jq', -- json
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
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
  -- Formatting with LSPs
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      format_on_save = function(bufnr)
        local disable_filetypes = {
          c = true,
          cpp = true,
          json = false,
          yaml = true,
          markdown = true,
        }

        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        svelte = { 'prettierd', stop_after_first = true },
        htmlangular = { 'prettierd', stop_after_first = true },
        javascript = { 'prettierd', stop_after_first = true },
        typescript = { 'prettier' }, -- eslint_d causes timeout issues, handle with precommit hook for now
        javascriptreact = { 'prettierd', stop_after_first = true },
        typescriptreact = { 'prettierd', stop_after_first = true },
        json = { 'fixjson' },
        graphql = { 'prettierd', stop_after_first = true },
        markdown = { 'prettierd', stop_after_first = true },
        bash = { 'beautysh' },
        yaml = { 'yamlfmt' },
        toml = { 'taplo' },
        css = { 'prettierd', stop_after_first = true },
        scss = { 'prettierd', stop_after_first = true },
        sh = { { 'shellcheck' } },
      },
    },
  },
  -- Commands for VSCode LSP
  {
    'yioneko/nvim-vtsls',
    event = 'BufReadPre',
    keys = function()
      require('which-key').add({

        { '<leader>ci', name = '[I]mports' },
        { '<leader>cf', name = '[F]ix and [F]ile' },
        { '<leader>cs', name = '[S]erver' },
      })

      return {
        { '<leader>cio', '<cmd>VtsExec organize_imports<cr>', desc = '[O]rganize' },
        { '<leader>cia', '<cmd>VtsExec add_missing_imports<cr>', desc = '[A]dd missing' },
        { '<leader>cfa', '<cmd>VtsExec fix_all<cr>', desc = '[F]ix [A]ll' },
        { '<leader>csr', '<cmd>VtsExec restart_tsserver<cr>', desc = '[S]erver [R]estart' },
        { '<leader>csl', '<cmd>VtsExec open_tsserver_log<cr>', desc = '[S]erver [L]ogs' },
        { '<leader>cfr', '<cmd>VtsExec file_references<cr>', desc = '[F]ile [R]eferences' },
      }
    end,
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
  {
    '2nthony/sortjson.nvim',
    cmd = {
      'SortJSONByAlphaNum',
      'SortJSONByAlphaNumReverse',
      'SortJSONByKeyLength',
      'SortJSONByKeyLengthReverse',
    },
    config = true,
  },
}
