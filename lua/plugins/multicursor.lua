-- Multi-cursor. LazyVim ships none; vim-visual-multi is the mature option.
-- <C-n> selects the word under the cursor and adds the next occurrence,
-- <C-Down>/<C-Up> add a cursor above/below, <C-q> skips an occurrence.
return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
      }
    end,
  },
}
