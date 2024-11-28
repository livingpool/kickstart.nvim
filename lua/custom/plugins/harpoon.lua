-- ThePrimeagen: harpoon
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  -- Basic telescope configuration (using telescope as UI)
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}

    -- Basic keymaps
    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Harpoon [A]dd' })
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon toggle quick menu' })

    vim.keymap.set('n', '<C-h>', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon select 1' })
    vim.keymap.set('n', '<C-t>', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon select 2' })
    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon select 3' })
    vim.keymap.set('n', '<C-s>', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon select 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end)
  end,
}
