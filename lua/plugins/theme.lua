-- Kanagawa Dragon, from the plugin itself: it ships its own palette and
-- plugin integrations (snacks, noice, trouble, bufferline, lualine), so this
-- works on any machine without Nix or a generated palette file.
-- modules/system/theme.nix points Stylix at the same base16 scheme, so the
-- terminal, helix and nvim stay on one palette.
local transparent = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "SignColumn",
  "FoldColumn",
  "EndOfBuffer",
  "LineNr",
  "CursorLineNr",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "SnacksNormal",
  "SnacksNormalNC",
  "SnacksWinBar",
}

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "dragon",
      -- kanagawa's own flag only drops `Normal`'s background; clear the rest of
      -- the chrome too so the terminal shows through, as in hx.
      transparent = true,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.cmd.colorscheme("kanagawa-dragon")
        for _, name in ipairs(transparent) do
          -- nvim_set_hl replaces the whole group, so keep fg and only drop bg.
          if vim.fn.hlexists(name) == 1 then
            local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
            hl.bg = nil
            vim.api.nvim_set_hl(0, name, hl)
          end
        end
      end,
    },
  },
}
