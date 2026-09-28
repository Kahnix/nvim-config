-- GitHub pull requests, issues and discussions as editable buffers, backed by
-- the authenticated `gh` CLI (run `:checkhealth octo` to verify the setup).
-- Loaded on demand through `:Octo` and the `<leader>g` keymaps.
-- See `:help octo`, `:help octo-commands`, and press `g?` in an octo buffer.
return {
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>gp", "<cmd>Octo pr list<cr>", desc = "[G]itHub: list [P]ull requests, <C-o> checks one out" },
			{
				"<leader>gP",
				function()
					vim.ui.input({ prompt = "Checkout PR number: " }, function(input)
						if input == nil or input == "" then
							return
						end
						local number = tonumber(input)
						if not number then
							vim.notify(("not a PR number: %s"):format(input), vim.log.levels.WARN)
							return
						end
						-- Same as `gh pr checkout <number>` in the current repository.
						require("octo.utils").checkout_pr(number)
					end)
				end,
				desc = "[G]itHub: [P]ull request checkout by number",
			},
			{ "<leader>gi", "<cmd>Octo issue list<cr>", desc = "[G]itHub: list [I]ssues" },
		},
		opts = {
			picker = "telescope",
			-- Bare `:Octo` opens a command picker instead of asking for a
			-- subcommand.
			enable_builtin = true,
		},
	},
}
