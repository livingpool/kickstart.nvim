-- Lightweight yet powerful formatter plugin for Neovim
-- https://github.com/stevearc/conform.nvim

return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = {}
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      c = { 'my_formatter' },
      cpp = { 'my_formatter' },
      lua = { 'stylua' },
      sh = { 'shfmt' },
      -- Conform can also run multiple formatters sequentially
      go = { 'goimports', 'gofmt' },
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      template = { 'prettierd', 'prettier', stop_after_first = true },
    },
    formatters = {
      prettierd = {
        env = {
          PRETTIERD_DEFAULT_CONFIG = vim.fn.expand '~/.config/nvim/.prettierrc',
        },
      },
      prettier = {
        append_args = { '--tab-width', '2' },
      },
      my_formatter = {
        command = 'clang-format',
        args = '--style="{BasedOnStyle: llvm, IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty, ColumnLimit: 120}"',
      },
      shfmt = {
        prepend_args = { '-i', '4' },
      },
    },
  },
}
