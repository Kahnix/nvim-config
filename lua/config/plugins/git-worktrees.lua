-- Create, switch between, and delete git worktrees from a Snacks picker.
-- Loaded on demand through the commands below and the `<leader>w` keymaps.
-- In-picker keys are not configurable: `<CR>` switch/create, `<C-x>` delete,
-- `<M-x>` delete branch too, `<M-n>` fork, `<M-g>` cycle local/remote/all,
-- `<C-o>` branch info, `g?` help.
return {
	{
		"awerebea/git-worktrees.nvim",
		-- Snacks needs no setup, but it must be on the runtimepath: the picker
		-- is resolved through the `Snacks` global it defines.
		dependencies = { "folke/snacks.nvim" },
		cmd = { "GitWorktreeTotal", "GitWorktreeAdd", "GitWorktreeManage", "GitBranchManage" },
		keys = {
			{
				"<leader>ww",
				function()
					require("git-worktrees").worktrees()
				end,
				desc = "[W]orktree: switch, create or delete a worktree",
			},
			{
				"<leader>wa",
				function()
					require("git-worktrees").worktrees_add()
				end,
				desc = "[W]orktree: [A]dd one for a branch without one",
			},
			{
				"<leader>wm",
				function()
					require("git-worktrees").worktrees_manage()
				end,
				desc = "[W]orktree: [M]anage the existing worktrees",
			},
			{
				"<leader>wb",
				function()
					require("git-worktrees").branches()
				end,
				desc = "[W]orktree: manage [B]ranches, no worktrees involved",
			},
		},
		opts = {
			-- Keymaps are declared in `keys` above; registering the built-in
			-- `<leader>gw*` ones as well would leave the winner up to load order.
			enable_default_keymaps = false,
		},
	},
}
