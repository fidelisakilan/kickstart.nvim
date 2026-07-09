-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>')
vim.keymap.set('n', '<leader>ge', '<Cmd>Neotree git_status<CR>')

require('neo-tree').setup {
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    hijack_netrw_behavior = 'open_current',
    -- filtered_items = {
    --   visible = true,
    -- },
  },
  window = {
    position = 'float',
    mappings = {
      ['l'] = 'open',
      ['h'] = 'close_node',
      ['<space>'] = 'none',
      ['P'] = { 'toggle_preview', config = { use_float = false } },
    },
  },
}
