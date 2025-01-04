return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- 'hrsh7th/cmp-nvim-lsp',
      'saghen/blink.cmp',
      { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
      { 'yioneko/nvim-vtsls' },
      { 'dmmulroy/ts-error-translator.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          map('gd', '<cmd>Glance definitions<cr>', '[G]oto [D]efinition')
          map('gr', '<cmd>Glance references<cr>', '[G]oto [R]eferences')
          map('gD', '<cmd>Glance type_definitions<cr>', '[G]oto Type [D]efinition')
          map('gI', '<cmd>Glance implementations<cr>', '[G]oto [I]mplementations')

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
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
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

          vim.diagnostic.enable()
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      local servers = {
        vtsls = {
          -- see: https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
          handlers = {
            ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
              require('ts-error-translator').translate_diagnostics(err, result, ctx, config)
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
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
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    'dnlhc/glance.nvim',
    cmd = { 'Glance' },
    event = 'LspAttach',
    opts = {
      height = 25,
      border = {
        enable = true,
      },
      use_trouble_qf = true,
      hooks = {
        before_open = function(results, open, jump, method)
          local uri = vim.uri_from_bufnr(0)
          if #results == 1 then
            local target_uri = results[1].uri or results[1].targetUri

            if target_uri == uri then
              jump(results[1])
            else
              open(results)
            end
          else
            open(results)
          end
        end,
      },
    },
  },
  {
    'VidocqH/lsp-lens.nvim',
    event = 'LspAttach',
    opts = {
      enable = true,
      sections = {
        definition = false,
        references = function(count)
          return '󰌹 Ref: ' .. count
        end,
        implements = function(count)
          return '󰡱 Imp: ' .. count
        end,
        git_authors = false,
      },
    },
    keys = {
      { '<leader>te', '<cmd>LspLensToggle<cr>', desc = '[T]oggle Lsp L[e]ns' },
    },
  },
  {
    'Wansmer/symbol-usage.nvim',
    enable = false,
    event = function()
      if vim.fn.has('nvim-0.10') == 1 then
        return 'LspAttach'
      else
        return 'BufRead'
      end
    end,
    opts = {
      vt_position = 'end_of_line',
      text_format = function(symbol)
        if symbol.references then
          local usage = symbol.references <= 1 and 'usage' or 'usages'
          local num = symbol.references == 0 and 'no' or symbol.references
          return string.format(' 󰌹 %s %s', num, usage)
        else
          return ''
        end
      end,
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}luvit-meta/library', words = { 'vim%.uv' } },
        { path = '../globals.lua' },
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
        }

        return {
          timeout_ms = 1000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          callback = function()
            vim.diagnostic.enable()
          end,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        svelte = { 'prettierd', stop_after_first = true },
        htmlangular = { 'prettier', stop_after_first = true },
        javascript = { 'prettier', stop_after_first = true },
        typescript = { 'prettier', stop_after_first = true },
        javascriptreact = { 'prettier', stop_after_first = true },
        typescriptreact = { 'prettier', stop_after_first = true },
        json = { 'fixjson' },
        graphql = { 'prettier', stop_after_first = true },
        markdown = { 'prettier', stop_after_first = true },
        bash = { 'beautysh' },
        -- yaml = { 'yamlfmt' },
        toml = { 'taplo' },
        css = { 'prettier', stop_after_first = true },
        scss = { 'prettier', stop_after_first = true },
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
