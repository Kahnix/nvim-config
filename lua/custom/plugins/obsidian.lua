local vault = vim.fn.expand '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes'

-- Creates DSA/Solutions/<id>. <title>.md from the "Leetcode Problem" template
-- for the problem open in the current leetcode.nvim tab.
local function leetcode_note()
  local ok, utils = pcall(require, 'leetcode.utils')
  local question = ok and utils.curr_question()
  if not question then
    return
  end
  local q = question.q
  local title = (q.frontend_id .. '. ' .. q.title):gsub('[/\\:]', '-')
  local note = require('obsidian.note').create {
    id = title,
    verbatim = true,
    dir = 'DSA/Solutions',
    template = 'Leetcode Problem',
  }
  note:write()
  note:open { sync = true }
end

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  cmd = 'Obsidian',
  event = {
    'BufReadPre ' .. vault .. '/*.md',
    'BufNewFile ' .. vault .. '/*.md',
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  init = function()
    -- Obsidian's link/checkbox rendering needs conceal; set before the plugin's check.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
  keys = {
    { '<leader>on', '<cmd>Obsidian new<cr>', desc = '[O]bsidian [N]ew note' },
    { '<leader>oN', '<cmd>Obsidian new_from_template<cr>', desc = '[O]bsidian [N]ew from template' },
    { '<leader>oo', '<cmd>Obsidian quick_switch<cr>', desc = '[O]bsidian [O]pen note' },
    { '<leader>os', '<cmd>Obsidian search<cr>', desc = '[O]bsidian [S]earch' },
    { '<leader>ot', '<cmd>Obsidian today<cr>', desc = '[O]bsidian [T]oday' },
    { '<leader>oy', '<cmd>Obsidian yesterday<cr>', desc = '[O]bsidian [Y]esterday' },
    { '<leader>od', '<cmd>Obsidian dailies<cr>', desc = '[O]bsidian [D]ailies' },
    { '<leader>ob', '<cmd>Obsidian backlinks<cr>', desc = '[O]bsidian [B]acklinks' },
    { '<leader>oT', '<cmd>Obsidian tags<cr>', desc = '[O]bsidian [T]ags' },
    { '<leader>oi', '<cmd>Obsidian template<cr>', desc = '[O]bsidian [I]nsert template' },
    { '<leader>or', '<cmd>Obsidian rename<cr>', desc = '[O]bsidian [R]ename note' },
    { '<leader>op', '<cmd>Obsidian paste_img<cr>', desc = '[O]bsidian [P]aste image' },
    { '<leader>oL', leetcode_note, desc = '[O]bsidian [L]eetcode note' },
    { '<leader>ol', ':Obsidian link<cr>', mode = 'v', desc = '[O]bsidian [L]ink selection' },
    { '<leader>oe', ':Obsidian extract_note<cr>', mode = 'v', desc = '[O]bsidian [E]xtract to note' },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = { { name = 'notes', path = vault } },
    picker = { name = 'telescope.nvim' },
    -- Existing notes have no frontmatter; don't inject any on save.
    frontmatter = { enabled = false },
    -- Keep the typed title as the filename, like the Obsidian app.
    note_id_func = function(title)
      if title and title ~= '' then
        return (title:gsub('[\\:*?"<>|#^%[%]]', '-'))
      end
      return os.date '%Y%m%d%H%M%S'
    end,
    templates = { folder = 'Templates' },
    daily_notes = {
      folder = 'Journal/Daily',
      date_format = 'YYYY/MM/YYYY-MM-DD',
      template = 'Daily',
      default_tags = {},
      workdays_only = false,
    },
  },
}
