-- Colorscheme comes from the Stylix base16 palette (see modules/home/dev.nix),
-- so nvim matches helix/ghostty/lazygit. hosts without Stylix fall back to
-- LazyVim's default theme.
return {
  { "nvim-mini/mini.nvim", lazy = false },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        if not pcall(require, "palette") then
          vim.cmd.colorscheme("tokyonight")
          return
        end

        -- mini.base16 applies the palette immediately and deliberately leaves
        -- g:colors_name unset; there is no `:colorscheme mini-base16`.
        require("mini.base16").setup({ palette = require("palette") })

        -- Transparent background, matching the terminal and helix config.
        for _, name in ipairs({
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
        }) do
          vim.api.nvim_set_hl(0, name, { bg = "NONE" })
        end
      end,
    },
  },
}
