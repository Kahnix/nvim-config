-- Renders markdown in-buffer: headings, code blocks, tables, callouts.
-- LSP hover floats are markdown buffers too, so `K` docs get the same treatment
-- (the built-in `buftype = nofile` override tunes padding/signs for floats).
-- obsidian.nvim detects this plugin and hands its UI over to it.
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    heading = { sign = false, width = 'block', left_pad = 1, right_pad = 1 },
    code = { sign = false, width = 'block', left_pad = 1, right_pad = 1 },
  },
}
