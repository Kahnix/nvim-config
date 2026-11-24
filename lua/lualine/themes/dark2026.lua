-- lualine theme for dark2026, picked up by `theme = "auto"`. The colorscheme keeps its palette
-- local, so the colors are copied from D0nw0r/dark2026.nvim's colors/dark2026.lua.
local c = {
	bg = "#121314",
	surface = "#242526",
	fg_dim = "#8c8c8c",
	fg_muted = "#555555",
	accent = "#3994bc",
	type = "#4EC9B0",
	func = "#D2A8FF",
	keyword = "#FF7B72",
	param = "#FFA657",
}

local function mode(color)
	return {
		a = { fg = c.bg, bg = color, gui = "bold" },
		b = { fg = color, bg = c.surface },
		c = { fg = c.fg_dim, bg = "None" }, -- transparent, like the editor background
		y = { fg = c.fg_dim, bg = c.surface },
		z = { fg = c.bg, bg = color, gui = "bold" },
	}
end

return {
	normal = mode(c.accent),
	insert = mode(c.type),
	visual = mode(c.func),
	replace = mode(c.keyword),
	command = mode(c.param),
	terminal = mode(c.type),
	inactive = {
		a = { fg = c.fg_muted, bg = c.surface },
		b = { fg = c.fg_muted, bg = c.surface },
		c = { fg = c.fg_muted, bg = "None" },
	},
}
