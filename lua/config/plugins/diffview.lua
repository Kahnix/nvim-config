-- Side-by-side diffs, file history and merge views for git.
-- Loaded on demand through the commands below and the `<leader>d` keymaps.
-- See `:help diffview`, `:help diffview.defaults`, and press `g?` in a view.

--- The branch a "what does this branch change" diff should be based on: the
--- remote's default branch when it is known, then the usual local names.
---@return string|nil
local function default_branch()
	for _, ref in ipairs({ "origin/HEAD", "origin/main", "origin/master", "main", "master" }) do
		vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", ref .. "^{commit}" })
		if vim.v.shell_error == 0 then
			return ref
		end
	end
end

-- Trace the history of the visual selection. `:DiffviewFileHistory` takes a
-- line range and infers the file from it. See `:help :DiffviewFileHistory`.
local function file_history_range()
	local first, last = vim.fn.line("."), vim.fn.line("v")
	vim.cmd(("%d,%dDiffviewFileHistory"):format(math.min(first, last), math.max(first, last)))
end

return {
	{
		"dlyongemallo/diffview-plus.nvim",
		-- The fork keeps the upstream module name, which lazy can not derive
		-- from the repository name.
		main = "diffview",
		cmd = {
			"DiffviewOpen",
			"DiffviewToggle",
			"DiffviewClose",
			"DiffviewFileHistory",
			"DiffviewFocusFiles",
			"DiffviewToggleFiles",
			"DiffviewRefresh",
			"DiffviewDiffFiles",
			"DiffviewLog",
		},
		keys = {
			{ "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "[D]iffview [O]pen changes against index" },
			{ "<leader>dt", "<cmd>DiffviewToggle<cr>", desc = "[D]iffview [T]oggle" },
			{
				"<leader>dm",
				function()
					local base = default_branch()
					if not base then
						vim.notify("diffview: no default branch to diff against", vim.log.levels.WARN)
						return
					end
					vim.cmd(("DiffviewOpen %s...HEAD"):format(base))
				end,
				desc = "[D]iffview [M]erge base against default branch",
			},
			{ "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "[D]iffview [F]ile history" },
			{ "<leader>df", mode = "x", file_history_range, desc = "[D]iffview [F]ile history of selection" },
			{ "<leader>dF", "<cmd>DiffviewFileHistory<cr>", desc = "[D]iffview [F]ull repository history" },
			{ "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "[D]iffview [Q]uit" },
		},
		opts = {
			-- Highlight the changed words instead of whole changed lines.
			enhanced_diff_hl = true,
			use_icons = vim.g.have_nerd_font,
			keymaps = {
				-- The panels have no default binding for closing the view, and
				-- `q` is what every other panel in this config uses.
				file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
				file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
			},
		},
	},
}
