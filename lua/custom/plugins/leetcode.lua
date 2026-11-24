return {
  'kawre/leetcode.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    lang = 'typescript',
    picker = { provider = 'telescope' },
    plugins = { non_standalone = true },
  },
  keys = {
    { '<leader>ll', '<cmd>Leet<cr>', desc = 'LeetCode dashboard' },
    { '<leader>lp', '<cmd>Leet list<cr>', desc = 'LeetCode problems' },
    { '<leader>ld', '<cmd>Leet daily<cr>', desc = 'LeetCode daily problem' },
    { '<leader>lr', '<cmd>Leet run<cr>', desc = 'LeetCode run tests' },
    { '<leader>ls', '<cmd>Leet submit<cr>', desc = 'LeetCode submit' },
  },
}
