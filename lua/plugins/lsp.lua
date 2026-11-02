-- Mason installs every language server and tool, so this config works on a
-- machine with no Nix: `:MasonInstall` and the list below are the only source.
-- nixd is not in the mason registry, so Nix files use nixd when it is on PATH
-- (this repo's hosts) and nil_ls otherwise.
local has_nixd = vim.fn.executable("nixd") == 1

return {
  {
    "mason.nvim",
    opts = {
      -- nixfmt and statix have no darwin-arm64 build in mason (statix is source
      -- only); on Nix hosts both are on PATH, elsewhere install them yourself.
      ensure_installed = {
        "stylua",
        "rust-analyzer",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- LSP-only folds leave non-LSP buffers (markdown, json, docs) unfolded.
      -- Treesitter folds cover every parsed file and fall back to indent.
      opts.folds = { enabled = false }

      -- `lang.nix` enables nil_ls; only keep it where nixd is unavailable.
      opts.servers.nil_ls = { enabled = not has_nixd }
      if has_nixd then
        -- lua/config/nixd.lua derives the flake/home-manager option sets per
        -- project root.
        opts.servers.nixd = {
          root_markers = { "flake.nix", ".git" },
          on_init = function(client)
            client.settings = require("config.nixd").settings(client.root_dir)
            client:notify("workspace/didChangeConfiguration", { settings = client.settings })
          end,
        }
      end

      -- Rust is owned by rustaceanvim (`lang.rust`). TypeScript is LazyVim's
      -- default vtsls, installed by mason.
      return opts
    end,
  },
}
