-- Appsec helpers with zero extra plugins: telescope sink grep, semgrep -> quickfix, ASan build.
local sinks = table.concat({
	-- C
	[[\b(strcpy|strcat|sprintf|vsprintf|gets|scanf|sscanf|memcpy|memmove|strncpy|strncat|alloca|system|popen|exec[lv]p?e?|printf|realloc)\s*\(]],
	-- Go
	[[\b(exec\.Command|template\.HTML|sql\.Open|unsafe\.|InsecureSkipVerify)|\.(Query|Exec)\(]],
	-- Rust
	[[\bunsafe\b|\.unwrap\(\)|transmute|from_raw_parts]],
	-- JS/TS
	[[\b(eval|innerHTML|outerHTML|dangerouslySetInnerHTML|child_process)\b|document\.write|new Function]],
}, "|")

local function semgrep()
	if vim.fn.executable("semgrep") == 0 then
		vim.notify("semgrep not found (install via :Mason)", vim.log.levels.ERROR)
		return
	end
	vim.notify("semgrep running...")
	vim.system(
		{ "semgrep", "scan", "--config", "p/security-audit", "--metrics=off", "--quiet", "--emacs", "." },
		{ text = true },
		vim.schedule_wrap(function(res)
			vim.fn.setqflist({}, " ", {
				title = "semgrep p/security-audit",
				lines = vim.split(res.stdout or "", "\n", { trimempty = true }),
				efm = "%f:%l:%c:%m",
			})
			vim.cmd("copen")
		end)
	)
end

local function asan_build()
	if vim.fn.filereadable("Makefile") == 0 then
		vim.notify("No Makefile in cwd", vim.log.levels.WARN)
		return
	end
	local old = vim.o.makeprg
	vim.cmd("compiler gcc")
	vim.o.makeprg =
		"make CFLAGS='-g -O0 -fsanitize=address,undefined -fno-omit-frame-pointer' LDFLAGS='-fsanitize=address,undefined'"
	vim.cmd("make!")
	vim.o.makeprg = old
	vim.cmd("copen")
end

return {
	{
		"nvim-lua/plenary.nvim",
		lazy = true,
		keys = {
			{
				"<leader>ag",
				function()
					require("telescope.builtin").grep_string({
						search = sinks,
						use_regex = true,
						prompt_title = "Dangerous sinks (C/Go/Rust/JS)",
					})
				end,
				desc = "[A]udit: [G]rep dangerous sinks",
			},
			{ "<leader>as", semgrep, desc = "[A]udit: [S]emgrep -> quickfix" },
			{ "<leader>aa", asan_build, desc = "[A]udit: [A]San/UBSan build -> quickfix" },
			{ "<leader>aq", vim.diagnostic.setqflist, desc = "[A]udit: diagnostics -> [Q]uickfix" },
		},
	},
}
