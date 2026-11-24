vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- [[ Options ]]
vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = false -- lualine shows it
vim.schedule(function()
	vim.o.clipboard = "unnamedplus" -- deferred: the clipboard provider is slow to start
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

-- [[ Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	virtual_text = { source = "if_many", spacing = 2 },
})

-- [[ lazy.nvim ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Transparent background for every colorscheme: the terminal's own background shows through.
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("config-transparent", { clear = true }),
	callback = function()
		for _, name in ipairs({
			"Normal",
			"NormalNC",
			"NormalFloat",
			"FloatBorder",
			"SignColumn",
			"FoldColumn",
			"EndOfBuffer",
			"LineNr",
			"CursorLineNr",
			"StatusLine",
			"StatusLineNC",
			"TabLine",
			"TabLineFill",
			"NeoTreeNormal",
			"NeoTreeNormalNC",
			"NeoTreeEndOfBuffer",
		}) do
			-- Only the background is dropped; the rest of the group stays as the colorscheme set it.
			local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			hl.bg = nil
			vim.api.nvim_set_hl(0, name, hl)
		end
	end,
})

require("lazy").setup({
	{ "NMAC427/guess-indent.nvim", opts = {} },

	{
		"D0nw0r/dark2026.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("dark2026")
		end,
	},
	-- Still available through `:colorscheme darkmatter`; lazy.nvim loads it on demand.
	{ "stevedylandev/darkmatter-nvim", lazy = true },

	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			preset = "helix",
			delay = 0,
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>a", group = "[A]udit" },
				{ "<leader>b", group = "De[b]ug" },
				{ "<leader>d", group = "[D]iffview" },
				{ "<leader>w", group = "[W]orktree" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>g", group = "[G]itHub" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>o", group = "[O]bsidian", mode = { "n", "v" } },
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			local map = vim.keymap.set
			map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			map("n", "<leader>sf", function()
				builtin.find_files({ hidden = true, file_ignore_patterns = { "^%.git/" } })
			end, { desc = "[S]earch [F]iles (incl. hidden)" })
			map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			map("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			map("n", "<leader>s/", function()
				builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
			end, { desc = "[S]earch [/] in Open Files" })
			map("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		-- Give language servers access to code embedded in another filetype.
		-- This lets vtsls understand JavaScript inside an HTML <script> tag.
		"jmbuhr/otter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = "html",
		config = function()
			local otter = require("otter")
			otter.setup({})

			local function activate_javascript(bufnr)
				vim.api.nvim_buf_call(bufnr, function()
					otter.activate({ "javascript" })
				end)
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("config-otter-html", { clear = true }),
				pattern = "html",
				callback = function(event)
					activate_javascript(event.buf)
				end,
			})

			-- The FileType event that loaded this plugin has already happened.
			activate_javascript(0)
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			-- Only used by mason-tool-installer to translate lspconfig names to Mason packages.
			-- Its setup() is never called, so it does not auto-enable whatever Mason has installed.
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			-- Loading blink.cmp first lets it add its completion capabilities to vim.lsp.config("*")
			-- before any server starts.
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true }),
				callback = function(event)
					local function map(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					local telescope = require("telescope.builtin")

					-- Hover docs in a bordered float; render-markdown.nvim renders the markdown.
					map("K", function()
						vim.lsp.buf.hover({ border = "rounded", max_width = 90, max_height = 30 })
					end, "Hover Documentation")
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- Apply a quickfix for any diagnostic on the current line, wherever the cursor is.
					-- The range spans the whole line, so diagnostics anchored past the last character
					-- (nixd's "expected ;") are reachable too. A single fix applies without a menu.
					map("grf", function()
						local row = vim.api.nvim_win_get_cursor(0)[1]
						local last = math.max(#vim.api.nvim_get_current_line() - 1, 0)
						vim.lsp.buf.code_action({
							range = { start = { row, 0 }, ["end"] = { row, last } },
							context = { only = { "quickfix" } },
							apply = true,
						})
					end, "[F]ix line (quickfix)")

					map("grr", telescope.lsp_references, "[G]oto [R]eferences")
					map("gri", telescope.lsp_implementations, "[G]oto [I]mplementation")
					map("grd", telescope.lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("grt", telescope.lsp_type_definitions, "[G]oto [T]ype Definition")
					map("gO", telescope.lsp_document_symbols, "Open Document Symbols")
					map("gW", telescope.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					-- snacks.words highlights the references; these jump between them.
					if client:supports_method("textDocument/documentHighlight", event.buf) then
						map("]]", function()
							Snacks.words.jump(vim.v.count1)
						end, "Next reference")
						map("[[", function()
							Snacks.words.jump(-vim.v.count1)
						end, "Previous reference")
					end

					if client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Merged over nvim-lspconfig's defaults from its lsp/<name>.lua files.
			local servers = {
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
				},
				gopls = {},
				html = {},
				rust_analyzer = {},
				vtsls = {},
				lua_ls = {
					settings = { Lua = { completion = { callSnippet = "Replace" } } },
				},
			}

			-- Not installed by Mason: nixd comes from Nix, oxlint from the project.
			local external = {
				-- Settings (nixpkgs + NixOS/nix-darwin/Home Manager option sets for option completion)
				-- are derived per project; see lua/config/nixd.lua.
				nixd = {
					root_markers = { "flake.nix", ".git" },
					on_init = function(client)
						client.settings = require("config.nixd").settings(client.root_dir)
						client:notify("workspace/didChangeConfiguration", { settings = client.settings })
					end,
				},
				oxlint = {},
			}

			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, {
				"stylua",
				"prettier",
				"goimports",
				"gofumpt",
				"codelldb",
				"markdownlint",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, config in pairs(vim.tbl_extend("error", servers, external)) do
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- C/C++ have no single house style, so don't reformat them on save.
				if vim.bo[bufnr].filetype == "c" or vim.bo[bufnr].filetype == "cpp" then
					return nil
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters = {
				-- Only run when the project has a config for them.
				biome = { require_cwd = true },
				prettier = { require_cwd = true },
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "biome", "oxfmt", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "oxfmt", "prettier", stop_after_first = true },
				typescript = { "biome", "oxfmt", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "oxfmt", "prettier", stop_after_first = true },
				json = { "biome", "oxfmt", "prettier", stop_after_first = true },
				jsonc = { "biome", "oxfmt", "prettier", stop_after_first = true },
				go = { "goimports", "gofumpt" },
				nix = { "nixfmt" },
			},
		},
	},

	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				-- Regex support in snippets.
				build = vim.fn.executable("make") == 1 and "make install_jsregexp" or nil,
				config = function()
					require("luasnip.loaders.from_lua").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
					})
				end,
			},
			"folke/lazydev.nvim",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			keywords = { VULN = { color = "error", alt = { "SINK", "AUDIT" } } },
		},
	},

	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()

			local starter = require("mini.starter")
			starter.setup({
				evaluate_single = true,
				header = table.concat({
					"███╗   ██╗██╗   ██╗██╗███╗   ███╗",
					"████╗  ██║██║   ██║██║████╗ ████║",
					"██╔██╗ ██║██║   ██║██║██╔████╔██║",
					"██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
					"██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
					"╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
				}, "\n"),
				items = {
					{ name = "Find files", action = "Telescope find_files", section = "Actions" },
					{ name = "Recent files", action = "Telescope oldfiles", section = "Actions" },
					{ name = "Search text", action = "Telescope live_grep", section = "Actions" },
					{
						name = "Edit config",
						action = "edit " .. vim.fn.fnameescape(vim.fn.stdpath("config") .. "/init.lua"),
						section = "Actions",
					},
					{ name = "Manage plugins", action = "Lazy", section = "Actions" },
					{ name = "Quit", action = "qa", section = "Actions" },
				},
				footer = "Kahnix · Neovim",
				content_hooks = {
					starter.gen_hook.adding_bullet("› "),
					starter.gen_hook.aligning("center", "center"),
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			local ensure_installed = {
				"bash",
				"c",
				"cpp",
				"go",
				"rust",
				"typescript",
				"tsx",
				"json",
				"yaml",
				"make",
				"dockerfile",
				"css",
				"diff",
				"html",
				"javascript",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"nix",
				"query",
				"vim",
				"vimdoc",
			}
			local indent_disabled = { ruby = true, javascript = true, typescript = true }
			local installing = {}
			local available = {}

			for _, lang in ipairs(treesitter.get_available()) do
				available[lang] = true
			end

			-- Start highlighting (and indent) for a buffer, installing its parser first if needed.
			local function start(bufnr)
				if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
					return
				end

				local filetype = vim.bo[bufnr].filetype
				local lang = vim.treesitter.language.get_lang(filetype)
				if not lang then
					return
				end

				if vim.list_contains(treesitter.get_installed("parsers"), lang) then
					local ok = pcall(vim.treesitter.start, bufnr, lang)
					if ok and not indent_disabled[filetype] then
						vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
					return
				end

				if installing[lang] or not available[lang] then
					return
				end

				installing[lang] = true
				treesitter.install(lang):await(function(err, installed)
					installing[lang] = nil
					if not err and installed then
						vim.schedule(function()
							start(bufnr)
						end)
					end
				end)
			end

			for _, lang in ipairs(ensure_installed) do
				installing[lang] = true
			end
			treesitter.install(ensure_installed):await(function(err, installed)
				for _, lang in ipairs(ensure_installed) do
					installing[lang] = nil
				end
				if not err and installed then
					vim.schedule(function()
						for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
							start(bufnr)
						end
					end)
				end
			end)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("config-treesitter", { clear = true }),
				callback = function(event)
					start(event.buf)
				end,
			})
		end,
	},

	{ import = "plugins" },
})
