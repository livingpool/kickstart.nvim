-- fugitive.vim. Premier Vim plugin for Git. Or premier Git plugin for Vim?
-- https://github.com/tpope/vim-fugitive

return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
  end,
}
