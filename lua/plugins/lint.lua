return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			go = { "golangcilint" },
			markdown = { "markdownlint" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function(args)
				-- Skip read-only buffers such as LSP hover floats, which are markdown too.
				if not vim.bo[args.buf].modifiable then
					return
				end

				-- golangci-lint performs package-level analysis, so running it on
				-- every InsertLeave would make normal Go editing unnecessarily slow.
				if vim.bo[args.buf].filetype == "go" and args.event ~= "BufWritePost" then
					return
				end

				lint.try_lint()
			end,
		})
	end,
}
