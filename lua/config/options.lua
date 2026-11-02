-- Personal overrides on top of LazyVim defaults.
-- See the LazyVim docs for the defaults before adding anything here.

vim.opt.scrolloff = 10

-- `:q` with unsaved changes asks instead of failing.
vim.o.confirm = true

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
