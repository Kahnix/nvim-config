-- Per-project nixd settings (used by lua/plugins/lsp.lua).
--
-- nixd only offers option completion (programs.git.settings.<C-Space>) for option sets it is told
-- about. The set differs per repository, so it is computed from the project root when the server
-- starts instead of being hardcoded to one flake. Outputs are discovered by evaluating the flake,
-- not by reading flake.nix, so flake-parts/import-tree layouts work too:
--
--   * nixpkgs        the flake's own `nixpkgs` input, else <nixpkgs> from NIX_PATH
--   * nixos          first nixosConfigurations.* in the flake
--   * nix-darwin     first darwinConfigurations.*
--   * home-manager   the Home Manager options of that system (Darwin preferred on a Mac),
--                    else first homeConfigurations.*
--
-- Option sets for outputs the flake lacks evaluate to { }. Projects without a flake get only the
-- nixpkgs entry; nixd falls back to its nixos defaults for options.
local M = {}

local function nix_string(s)
	return '"' .. s:gsub('[\\"$]', "\\%0") .. '"'
end

---@param root string|nil project root directory
function M.settings(root)
	local settings = { nixd = { formatting = { command = { "nixfmt" } } } }

	if not root or not vim.uv.fs_stat(root .. "/flake.nix") then
		settings.nixd.nixpkgs = { expr = "import <nixpkgs> { }" }
		return settings
	end

	local is_darwin = vim.uv.os_uname().sysname == "Darwin"
	-- Shared Nix bindings; each expr below is evaluated by nixd with this prefix.
	local prelude = ([[
let
  flake = builtins.getFlake %s;
  first = output:
    let configs = flake.${output} or { };
    in if configs == { } then null else configs.${builtins.head (builtins.attrNames configs)};
  nixos = first "nixosConfigurations";
  darwin = first "darwinConfigurations";
  home = first "homeConfigurations";
  system = if %s && darwin != null then darwin else if nixos != null then nixos else darwin;
in
]]):format(nix_string(root), tostring(is_darwin))

	settings.nixd.nixpkgs = { expr = prelude .. "import (flake.inputs.nixpkgs or <nixpkgs>) { }" }
	settings.nixd.options = {
		nixos = { expr = prelude .. "if nixos == null then { } else nixos.options" },
		["nix-darwin"] = { expr = prelude .. "if darwin == null then { } else darwin.options" },
		["home-manager"] = {
			expr = prelude
				.. "if system != null && system.options ? home-manager"
				.. " then system.options.home-manager.users.type.getSubOptions [ ]"
				.. " else if home != null then home.options else { }",
		},
	}
	return settings
end

return M
