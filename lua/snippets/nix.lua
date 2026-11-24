local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
	s("flake", {
		t({ "{", '  description = "' }),
		i(1, "Description"),
		t({
			'";',
			"",
			"  inputs = {",
			'    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";',
			"  };",
			"",
			"  outputs = { self, nixpkgs, ... }:",
			"    {",
		}),
		i(0),
		t({ "", "    };", "}" }),
	}),
	s("description", {
		t('description = "'),
		i(1, "Description"),
		t('";'),
	}),
	s("inputs", {
		t({ "inputs = {", "  " }),
		i(1),
		t({ "", "};" }),
	}),
	s("outputs", {
		t("outputs = { "),
		i(1, "self, ..."),
		t({ " }:", "  {", "    " }),
		i(0),
		t({ "", "  };" }),
	}),
}
