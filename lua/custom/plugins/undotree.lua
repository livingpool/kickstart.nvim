-- Undotree
-- https://github.com/mbbill/undotree

return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'UndotreeToggle' })
  end,
}
