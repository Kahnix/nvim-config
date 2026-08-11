return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>lg',
      function()
        if vim.api.nvim_buf_get_name(0) == '' or vim.bo.buftype ~= '' then
          vim.cmd 'LazyGit'
        else
          vim.cmd 'LazyGitCurrentFile'
        end
      end,
      desc = 'Open [L]azy[G]it',
    },
  },
}
