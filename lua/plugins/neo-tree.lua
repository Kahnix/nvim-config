return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	keys = {
		{
			"\\",
			function()
				if vim.bo.filetype == "ministarter" then
					require("neo-tree.command").execute({ source = "filesystem", dir = vim.fn.getcwd() })
					return
				end

				vim.cmd("Neotree reveal")
			end,
			desc = "NeoTree reveal",
			silent = true,
		},
	},
	opts = {
		filesystem = {
			window = {
				mappings = {
					["\\"] = "close_window",
				},
			},
		},
	},
}
