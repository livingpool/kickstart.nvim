-- nvim-metals is a Lua plugin built to provide a better experience while using Metals, the Scala Language Server, with Neovim's built-in LSP support
-- https://github.com/scalameta/nvim-metals?tab=readme-ov-file

return {
  'scalameta/nvim-metals',
  ft = { 'scala', 'sbt', 'java' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'j-hui/fidget.nvim',
      opt = {},
    },
    {
      'mfussenegger/nvim-dap',
      config = function(self, opts)
        -- Debug settings if you're using nvim-dap
        local dap = require 'dap'

        dap.configurations.scala = {
          {
            type = 'scala',
            request = 'launch',
            name = 'RunOrTest',
            metals = {
              runType = 'runOrTestFile',
              --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
          },
          {
            type = 'scala',
            request = 'launch',
            name = 'Test Target',
            metals = {
              runType = 'testTarget',
            },
          },
        }
      end,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>cW", function () require('metals').hover_worksheet() end, desc = "Metals Worksheet" },
    { "<leader>cM", function () require('telescope').extensions.metals.commands() end, desc = "Telescope Metals Commands" },
  },
  init = function()
    local metals_config = require('metals').bare_config()

    -- Example of settings
    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
      testUserInterface = 'Test Explorer',
      javaHome = '/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home',
    }

    -- *READ THIS*
    -- I *highly* recommend setting statusBarProvider to either "off" or "on"
    --
    -- "off" will enable LSP progress notifications by Metals and you'll need
    -- to ensure you have a plugin like fidget.nvim installed to handle them.
    --
    -- "on" will enable the custom Metals status extension and you *have* to have
    -- a have settings to capture this in your statusline or else you'll not see
    -- any messages from metals. There is more info in the help docs about this
    metals_config.init_options.statusBarProvider = 'off'

    -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
    metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()

    metals_config.on_attach = function(client, bufnr)
      require('metals').setup_dap()

      -- LSP mappings
      -- vim.keymap.set('n', 'gD', vim.lsp.buf.definition)
      -- vim.keymap.set('n', 'K', vim.lsp.buf.hover)
      -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
      -- vim.keymap.set('n', 'gr', vim.lsp.buf.references)
      -- vim.keymap.set('n', 'gds', vim.lsp.buf.document_symbol)
      -- vim.keymap.set('n', 'gws', vim.lsp.buf.workspace_symbol)
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run)
      -- vim.keymap.set('n', '<leader>sh', vim.lsp.buf.signature_help)
      -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
      -- vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
      -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

      vim.keymap.set('n', '<leader>ws', function()
        require('metals').hover_worksheet()
      end)

      -- all workspace diagnostics
      vim.keymap.set('n', '<leader>aa', vim.diagnostic.setqflist)

      -- all workspace errors
      vim.keymap.set('n', '<leader>ae', function()
        vim.diagnostic.setqflist { severity = vim.diagnostic.severity.E }
      end)

      -- all workspace warnings
      vim.keymap.set('n', '<leader>aw', function()
        vim.diagnostic.setqflist { severity = vim.diagnostic.severity.W }
      end)

      -- buffer diagnostics only
      vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist)

      vim.keymap.set('n', '[c', function()
        vim.diagnostic.goto_prev { wrap = false }
      end)

      vim.keymap.set('n', ']c', function()
        vim.diagnostic.goto_next { wrap = false }
      end)

      -- Example vim.keymap.setpings for usage with nvim-dap. If you don't use that, you can
      -- skip these
      vim.keymap.set('n', '<leader>dc', function()
        require('dap').continue()
      end)

      vim.keymap.set('n', '<leader>dr', function()
        require('dap').repl.toggle()
      end)

      vim.keymap.set('n', '<leader>dK', function()
        require('dap.ui.widgets').hover()
      end)

      vim.keymap.set('n', '<leader>dt', function()
        require('dap').toggle_breakpoint()
      end)

      vim.keymap.set('n', '<leader>dso', function()
        require('dap').step_over()
      end)

      vim.keymap.set('n', '<leader>dsi', function()
        require('dap').step_into()
      end)

      vim.keymap.set('n', '<leader>dl', function()
        require('dap').run_last()
      end)
    end

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = self.ft,
      callback = function()
        require('metals').initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
