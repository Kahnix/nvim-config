-- lualine theme for darkmatter. lualine re-runs this file on every ColorScheme event,
-- so the middle section follows :TransparentToggle.
local c = require("darkmatter.palette")

local mid = vim.g.transparent ~= false and "None" or c.chrome

local function mode(color)
	return {
		a = { fg = c.bg, bg = color, gui = "bold" },
		b = { fg = color, bg = c.surface_high },
		c = { fg = c.text_muted, bg = mid },
		y = { fg = c.text_muted, bg = c.surface_high },
		z = { fg = c.bg, bg = color, gui = "bold" },
	}
end

return {
	normal = mode(c.accent),
	insert = mode(c.info),
	visual = mode(c.accent_soft),
	replace = mode(c.error),
	command = mode(c.text_keyword),
	terminal = mode(c.base0C),
	inactive = {
		a = { fg = c.text_dim, bg = c.surface },
		b = { fg = c.text_dim, bg = c.surface },
		c = { fg = c.text_dim, bg = mid },
	},
}
