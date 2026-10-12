-- lualine theme for dark-cavern. lualine re-runs this file on every ColorScheme event,
-- so the middle section follows :TransparentToggle.
local c = require("dark-cavern.palette")

local mid = vim.g.transparent ~= false and "None" or c.chrome

local function mode(color)
	return {
		a = { fg = c.bg, bg = color, gui = "bold" },
		b = { fg = color, bg = c.stone_mid },
		c = { fg = c.muted_gray, bg = mid },
		y = { fg = c.muted_gray, bg = c.stone_mid },
		z = { fg = c.bg, bg = color, gui = "bold" },
	}
end

return {
	normal = mode(c.crystal_blue),
	insert = mode(c.mineral_green),
	visual = mode(c.amber),
	replace = mode(c.error_red),
	command = mode(c.vein_blue),
	terminal = mode(c.teal),
	inactive = {
		a = { fg = c.dim_gray, bg = c.limestone_dark },
		b = { fg = c.dim_gray, bg = c.limestone_dark },
		c = { fg = c.dim_gray, bg = mid },
	},
}
