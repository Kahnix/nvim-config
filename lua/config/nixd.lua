-- Per-project nixd settings.
--
-- nixd only offers option completion (programs.git.settings.<C-Space>) for option sets it is told
-- about. The set differs per repository, so it is computed from the project root when the server
-- starts instead of being hardcoded to one flake:
--
--   * nixpkgs        the flake's own `nixpkgs` input, else <nixpkgs> from NIX_PATH
--   * nixos          first nixosConfigurations.* in the flake, if it defines any
--   * nix-darwin     first darwinConfigurations.*, if any
--   * home-manager   the Home Manager options of that system, else first homeConfigurations.*
--
-- Projects with a flake that defines none of these (devShell-only flakes) or no flake at all just get
-- the nixpkgs entry; nixd falls back to its nixos defaults for options.
local M = {}

local function nix_string(s)
	return '"' .. s:gsub("[\\\"$]", "\\%0") .. '"'
end

local function read(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local text = f:read("*a")
	f:close()
	return text
end

---@param root string|nil project root directory
function M.settings(root)
	local flake_text = root and read(root .. "/flake.nix")
	local settings = { nixd = { formatting = { command = { "nixfmt" } } } }

	if not flake_text then
		settings.nixd.nixpkgs = { expr = "import <nixpkgs> { }" }
		return settings
	end

	local flake = "(builtins.getFlake " .. nix_string(root) .. ")"
	-- `or <nixpkgs>` is only evaluated when the flake has no nixpkgs input.
	settings.nixd.nixpkgs = { expr = "import (" .. flake .. ".inputs.nixpkgs or <nixpkgs>) { }" }

	-- Picks the first configuration of an output; hostnames are not guessed.
	local function first(output)
		return "(let c = " .. flake .. "." .. output .. "; in c.${builtins.head (builtins.attrNames c)})"
	end

	local options = {}
	local system
	if flake_text:find("nixosConfigurations", 1, true) then
		system = first("nixosConfigurations")
		options["nixos"] = { expr = system .. ".options" }
	end
	if flake_text:find("darwinConfigurations", 1, true) then
		local darwin = first("darwinConfigurations")
		options["nix-darwin"] = { expr = darwin .. ".options" }
		-- On a Mac the Darwin system is the one whose home-manager.users the files are evaluated in.
		if not system or vim.uv.os_uname().sysname == "Darwin" then
			system = darwin
		end
	end

	if flake_text:find("home-manager", 1, true) then
		if system then
			options["home-manager"] = {
				expr = system .. ".options.home-manager.users.type.getSubOptions [ ]",
			}
		elseif flake_text:find("homeConfigurations", 1, true) then
			options["home-manager"] = { expr = first("homeConfigurations") .. ".options" }
		end
	end

	if next(options) then
		settings.nixd.options = options
	end
	return settings
end

return M
