-- Type-check the whole project with its own tsc: the LSP only ever sees open buffers.
return {
	"dmmulroy/tsc.nvim",
	cmd = { "TSC", "TSCStop", "TSCOpen", "TSCClose" },
	keys = { { "<leader>ct", "<cmd>TSC<CR>", desc = "[C]heck [T]ypes with tsc" } },
	opts = {
		auto_open_qflist = true,
		auto_focus_qflist = false,
		-- tsc names the missing symbol; the friendlier rewrite drops it from the message.
		pretty_errors = false,
		flags = {
			noEmit = true,
			-- The plugin's own search walks up past the repository, so a project without a tsconfig
			-- of its own resolves to whatever config sits above it: a stray ~/Documents/tsconfig.json
			-- covers 2004 .ts files across 11 local repositories, and those errors are what you get
			-- back. Stop the search at the repository root instead.
			project = function()
				local from = vim.fn.expand("%:p:h")
				if from == "" then
					from = vim.fn.getcwd()
				end
				local root = vim.fs.root(from, { ".git" }) or from
				local found = vim.fs.find({ "tsconfig.app.json", "tsconfig.json" }, {
					upward = true,
					path = from,
					stop = vim.fs.dirname(root),
				})[1]
				-- Nothing to build in this repository: name its root so tsc reports TS5081 for the
				-- workspace instead of checking whatever project sits above it. Returning nil would
				-- make the plugin drop the flag and let tsc fall back to the cwd.
				return found or root
			end,
		},
	},
}
