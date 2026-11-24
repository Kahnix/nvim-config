-- Sticky header showing the enclosing function/class/scope while scrolling.
-- Runtime control: `:TSContext enable|disable|toggle`.
-- `[C` is the jump binding rather than the plugin's suggested `[c`, which
-- gitsigns already uses for previous hunk.
return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		keys = {
			{ "<leader>tc", "<cmd>TSContext toggle<cr>", desc = "[T]oggle treesitter [C]ontext" },
			{
				"[C",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "Jump to the enclosing context",
			},
		},
		opts = {
			-- Bound the header, keeping the innermost enclosing scopes, so
			-- deeply nested code can not eat the window.
			max_lines = 3,
			-- Draw a line between the header and the file itself. Also means
			-- the header stays hidden until there are 2 lines above the cursor.
			separator = "-",
		},
	},
}
