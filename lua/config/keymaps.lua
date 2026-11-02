-- Keymaps are automatically loaded on the VeryLazy event.
-- LazyVim already maps <Esc> (clear hlsearch), <C-hjkl> (window nav) and the
-- <leader>s / <leader>c / <leader>u groups; only the extras live here.

vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save buffer" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
