-- dark-cavern: port of Tern's "dark-cavern" theme (~/.local/opt/tern/tern builtin).
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "dark-cavern"

local c = {
	-- Tern theme vars
	cave_black = "#0E0F12",
	limestone_dark = "#14181D",
	stone_mid = "#1D2229",
	slab_gray = "#232A33",
	stalactite = "#2F3945",
	crystal_blue = "#5FB2D8",
	vein_blue = "#87C6E6",
	mineral_green = "#6FB86A",
	amber = "#D9A441",
	error_red = "#E06C75",
	muted_gray = "#A5ADBA",
	dim_gray = "#6B7381",
	-- Tern terminal section
	bg = "#0B0D10",
	fg = "#C9D1DB",
	chrome = "#08090B",
	purple = "#B88AD8",
	teal = "#56C2B8",
	bright_red = "#EF9097",
	bright_green = "#94D090",
	bright_yellow = "#ECC46E",
	bright_purple = "#D2AEEA",
	bright_teal = "#86DCD2",
	white = "#E2E7EE",
	-- Tern tool backgrounds (used for diffs)
	green_bg = "#131B16",
	red_bg = "#221416",
	custom_bg = "#1A1F26",
	none = "NONE",
}

-- Terminal buffers use Tern's exact ANSI palette.
local ansi = {
	c.stalactite, c.error_red, c.mineral_green, c.amber, c.crystal_blue, c.purple, c.teal, c.muted_gray,
	c.dim_gray, c.bright_red, c.bright_green, c.bright_yellow, c.vein_blue, c.bright_purple, c.bright_teal, c.white,
}
for i, color in ipairs(ansi) do
	vim.g["terminal_color_" .. (i - 1)] = color
end

local groups = {
	-- Editor UI
	Normal = { fg = c.fg, bg = c.bg },
	NormalNC = { link = "Normal" },
	NormalFloat = { fg = c.fg, bg = c.limestone_dark },
	FloatBorder = { fg = c.stalactite, bg = c.limestone_dark },
	FloatTitle = { fg = c.vein_blue, bg = c.limestone_dark, bold = true },
	FloatFooter = { fg = c.dim_gray, bg = c.limestone_dark },
	WinSeparator = { fg = c.stalactite },
	VertSplit = { link = "WinSeparator" },
	Cursor = { fg = c.bg, bg = c.fg },
	lCursor = { link = "Cursor" },
	CursorIM = { link = "Cursor" },
	TermCursor = { link = "Cursor" },
	CursorLine = { bg = c.limestone_dark },
	CursorColumn = { link = "CursorLine" },
	ColorColumn = { bg = c.limestone_dark },
	CursorLineNr = { fg = c.amber, bold = true },
	LineNr = { fg = c.stalactite },
	LineNrAbove = { link = "LineNr" },
	LineNrBelow = { link = "LineNr" },
	SignColumn = { bg = c.none },
	FoldColumn = { fg = c.stalactite },
	Folded = { fg = c.muted_gray, bg = c.limestone_dark },
	EndOfBuffer = { fg = c.bg },
	NonText = { fg = c.stalactite },
	Whitespace = { fg = c.slab_gray },
	SpecialKey = { fg = c.stalactite },
	Conceal = { fg = c.dim_gray },
	Visual = { bg = c.slab_gray },
	VisualNOS = { link = "Visual" },
	Search = { fg = c.bg, bg = c.amber },
	IncSearch = { fg = c.bg, bg = c.bright_yellow },
	CurSearch = { link = "IncSearch" },
	Substitute = { fg = c.bg, bg = c.error_red },
	MatchParen = { fg = c.amber, bg = c.stalactite, bold = true },
	Pmenu = { fg = c.fg, bg = c.limestone_dark },
	PmenuSel = { bg = c.stone_mid, bold = true },
	PmenuKind = { fg = c.crystal_blue, bg = c.limestone_dark },
	PmenuKindSel = { fg = c.crystal_blue, bg = c.stone_mid },
	PmenuExtra = { fg = c.dim_gray, bg = c.limestone_dark },
	PmenuExtraSel = { fg = c.dim_gray, bg = c.stone_mid },
	PmenuSbar = { bg = c.limestone_dark },
	PmenuThumb = { bg = c.stalactite },
	PmenuMatch = { fg = c.vein_blue, bold = true },
	PmenuMatchSel = { fg = c.vein_blue, bg = c.stone_mid, bold = true },
	StatusLine = { fg = c.muted_gray, bg = c.chrome },
	StatusLineNC = { fg = c.dim_gray, bg = c.chrome },
	TabLine = { fg = c.dim_gray, bg = c.chrome },
	TabLineFill = { bg = c.chrome },
	TabLineSel = { fg = c.fg, bg = c.stone_mid, bold = true },
	WinBar = { fg = c.muted_gray, bold = true },
	WinBarNC = { fg = c.dim_gray },
	Title = { fg = c.amber, bold = true },
	Directory = { fg = c.crystal_blue },
	ModeMsg = { fg = c.crystal_blue, bold = true },
	MoreMsg = { fg = c.mineral_green },
	Question = { fg = c.crystal_blue },
	MsgArea = { fg = c.fg },
	ErrorMsg = { fg = c.error_red },
	WarningMsg = { fg = c.amber },
	QuickFixLine = { bg = c.stone_mid, bold = true },
	WildMenu = { link = "PmenuSel" },
	SpellBad = { sp = c.error_red, undercurl = true },
	SpellCap = { sp = c.amber, undercurl = true },
	SpellLocal = { sp = c.teal, undercurl = true },
	SpellRare = { sp = c.purple, undercurl = true },

	-- Diff (Tern tool success/error backgrounds)
	DiffAdd = { bg = c.green_bg },
	DiffDelete = { fg = c.error_red, bg = c.red_bg },
	DiffChange = { bg = c.limestone_dark },
	DiffText = { bg = c.slab_gray, bold = true },
	Added = { fg = c.mineral_green },
	Changed = { fg = c.amber },
	Removed = { fg = c.error_red },
	diffAdded = { link = "Added" },
	diffRemoved = { link = "Removed" },
	diffChanged = { link = "Changed" },
	diffFile = { fg = c.crystal_blue, bold = true },
	diffLine = { fg = c.dim_gray },

	-- Syntax (Tern syntax* mapping)
	Comment = { fg = c.dim_gray, italic = true },
	Constant = { fg = c.amber },
	String = { fg = c.mineral_green },
	Character = { fg = c.mineral_green },
	Number = { fg = c.amber },
	Boolean = { fg = c.amber },
	Float = { fg = c.amber },
	Identifier = { fg = c.fg },
	Function = { fg = c.amber },
	Statement = { fg = c.crystal_blue },
	Conditional = { fg = c.crystal_blue },
	Repeat = { fg = c.crystal_blue },
	Label = { fg = c.crystal_blue },
	Operator = { fg = c.muted_gray },
	Keyword = { fg = c.crystal_blue },
	Exception = { fg = c.crystal_blue },
	PreProc = { fg = c.purple },
	Include = { fg = c.crystal_blue },
	Define = { fg = c.purple },
	Macro = { fg = c.purple },
	PreCondit = { fg = c.purple },
	Type = { fg = c.crystal_blue },
	StorageClass = { fg = c.crystal_blue },
	Structure = { fg = c.crystal_blue },
	Typedef = { fg = c.crystal_blue },
	Special = { fg = c.teal },
	SpecialChar = { fg = c.teal },
	Tag = { fg = c.crystal_blue },
	Delimiter = { fg = c.muted_gray },
	SpecialComment = { fg = c.muted_gray, italic = true },
	Debug = { fg = c.error_red },
	Underlined = { underline = true },
	Ignore = { fg = c.dim_gray },
	Error = { fg = c.error_red },
	Todo = { fg = c.bg, bg = c.amber, bold = true },

	-- Treesitter
	["@variable"] = { fg = c.fg },
	["@variable.builtin"] = { fg = c.purple, italic = true },
	["@variable.parameter"] = { fg = c.vein_blue },
	["@variable.member"] = { fg = c.vein_blue },
	["@property"] = { fg = c.vein_blue },
	["@constant"] = { fg = c.amber },
	["@constant.builtin"] = { fg = c.amber, italic = true },
	["@constant.macro"] = { fg = c.purple },
	["@module"] = { fg = c.teal },
	["@label"] = { fg = c.crystal_blue },
	["@string"] = { link = "String" },
	["@string.escape"] = { fg = c.teal },
	["@string.regexp"] = { fg = c.teal },
	["@string.special"] = { fg = c.teal },
	["@string.special.url"] = { fg = c.crystal_blue, underline = true },
	["@character"] = { link = "Character" },
	["@number"] = { link = "Number" },
	["@boolean"] = { link = "Boolean" },
	["@type"] = { link = "Type" },
	["@type.builtin"] = { fg = c.crystal_blue, italic = true },
	["@attribute"] = { fg = c.purple },
	["@function"] = { link = "Function" },
	["@function.builtin"] = { fg = c.amber, italic = true },
	["@function.macro"] = { fg = c.purple },
	["@function.method"] = { link = "Function" },
	["@constructor"] = { fg = c.crystal_blue },
	["@operator"] = { link = "Operator" },
	["@keyword"] = { link = "Keyword" },
	["@keyword.return"] = { fg = c.crystal_blue, italic = true },
	["@keyword.exception"] = { fg = c.error_red },
	["@punctuation"] = { fg = c.muted_gray },
	["@punctuation.special"] = { fg = c.teal },
	["@comment"] = { link = "Comment" },
	["@comment.error"] = { fg = c.bg, bg = c.error_red, bold = true },
	["@comment.warning"] = { fg = c.bg, bg = c.amber, bold = true },
	["@comment.todo"] = { fg = c.bg, bg = c.crystal_blue, bold = true },
	["@comment.note"] = { fg = c.bg, bg = c.mineral_green, bold = true },
	["@tag"] = { fg = c.crystal_blue },
	["@tag.attribute"] = { fg = c.vein_blue },
	["@tag.delimiter"] = { fg = c.muted_gray },
	["@diff.plus"] = { link = "Added" },
	["@diff.minus"] = { link = "Removed" },
	["@diff.delta"] = { link = "Changed" },

	-- Markup (Tern md* mapping)
	["@markup.heading"] = { fg = c.amber, bold = true },
	["@markup.strong"] = { bold = true },
	["@markup.italic"] = { italic = true },
	["@markup.strikethrough"] = { strikethrough = true },
	["@markup.underline"] = { underline = true },
	["@markup.quote"] = { fg = c.muted_gray, italic = true },
	["@markup.link"] = { fg = c.crystal_blue },
	["@markup.link.label"] = { fg = c.crystal_blue },
	["@markup.link.url"] = { fg = c.dim_gray, underline = true },
	["@markup.raw"] = { fg = c.vein_blue },
	["@markup.raw.block"] = { fg = c.crystal_blue },
	["@markup.list"] = { fg = c.amber },
	["@markup.list.checked"] = { fg = c.mineral_green },
	["@markup.list.unchecked"] = { fg = c.dim_gray },

	-- LSP
	["@lsp.type.namespace"] = { link = "@module" },
	["@lsp.type.parameter"] = { link = "@variable.parameter" },
	["@lsp.type.property"] = { link = "@property" },
	["@lsp.type.enumMember"] = { link = "@constant" },
	["@lsp.typemod.variable.readonly"] = { link = "@constant" },
	["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
	LspReferenceText = { bg = c.stone_mid },
	LspReferenceRead = { bg = c.stone_mid },
	LspReferenceWrite = { bg = c.stone_mid, underline = true },
	LspSignatureActiveParameter = { fg = c.amber, bold = true },
	LspInlayHint = { fg = c.dim_gray, bg = c.limestone_dark, italic = true },
	LspCodeLens = { fg = c.dim_gray },

	-- Diagnostics
	DiagnosticError = { fg = c.error_red },
	DiagnosticWarn = { fg = c.amber },
	DiagnosticInfo = { fg = c.crystal_blue },
	DiagnosticHint = { fg = c.teal },
	DiagnosticOk = { fg = c.mineral_green },
	DiagnosticUnderlineError = { sp = c.error_red, undercurl = true },
	DiagnosticUnderlineWarn = { sp = c.amber, undercurl = true },
	DiagnosticUnderlineInfo = { sp = c.crystal_blue, undercurl = true },
	DiagnosticUnderlineHint = { sp = c.teal, undercurl = true },
	DiagnosticUnderlineOk = { sp = c.mineral_green, undercurl = true },
	DiagnosticVirtualTextError = { fg = c.error_red, bg = c.red_bg },
	DiagnosticVirtualTextWarn = { fg = c.amber, bg = c.limestone_dark },
	DiagnosticVirtualTextInfo = { fg = c.crystal_blue, bg = c.limestone_dark },
	DiagnosticVirtualTextHint = { fg = c.teal, bg = c.limestone_dark },
	DiagnosticUnnecessary = { fg = c.dim_gray },
	DiagnosticDeprecated = { strikethrough = true },

	-- gitsigns
	GitSignsAdd = { fg = c.mineral_green },
	GitSignsChange = { fg = c.amber },
	GitSignsDelete = { fg = c.error_red },
	GitSignsCurrentLineBlame = { fg = c.dim_gray, italic = true },

	-- Telescope
	TelescopeNormal = { link = "NormalFloat" },
	TelescopeBorder = { link = "FloatBorder" },
	TelescopeTitle = { fg = c.bg, bg = c.crystal_blue, bold = true },
	TelescopePromptTitle = { fg = c.bg, bg = c.amber, bold = true },
	TelescopePromptPrefix = { fg = c.crystal_blue },
	TelescopeSelection = { bg = c.stone_mid },
	TelescopeSelectionCaret = { fg = c.amber, bg = c.stone_mid },
	TelescopeMatching = { fg = c.vein_blue, bold = true },
	TelescopeMultiSelection = { fg = c.amber },

	-- neo-tree
	NeoTreeNormal = { fg = c.fg, bg = c.chrome },
	NeoTreeNormalNC = { link = "NeoTreeNormal" },
	NeoTreeEndOfBuffer = { fg = c.chrome, bg = c.chrome },
	NeoTreeWinSeparator = { fg = c.stalactite, bg = c.bg },
	NeoTreeRootName = { fg = c.amber, bold = true },
	NeoTreeDirectoryName = { fg = c.fg },
	NeoTreeDirectoryIcon = { fg = c.crystal_blue },
	NeoTreeFileName = { fg = c.fg },
	NeoTreeIndentMarker = { fg = c.stalactite },
	NeoTreeCursorLine = { bg = c.stone_mid },
	NeoTreeGitAdded = { fg = c.mineral_green },
	NeoTreeGitModified = { fg = c.amber },
	NeoTreeGitDeleted = { fg = c.error_red },
	NeoTreeGitUntracked = { fg = c.vein_blue },
	NeoTreeGitConflict = { fg = c.error_red, bold = true },
	NeoTreeGitIgnored = { fg = c.dim_gray },
	NeoTreeDimText = { fg = c.dim_gray },
	NeoTreeTitleBar = { fg = c.bg, bg = c.crystal_blue, bold = true },

	-- blink.cmp
	BlinkCmpMenu = { link = "Pmenu" },
	BlinkCmpMenuBorder = { link = "FloatBorder" },
	BlinkCmpMenuSelection = { link = "PmenuSel" },
	BlinkCmpLabelMatch = { fg = c.vein_blue, bold = true },
	BlinkCmpLabelDeprecated = { fg = c.dim_gray, strikethrough = true },
	BlinkCmpLabelDetail = { fg = c.dim_gray },
	BlinkCmpLabelDescription = { fg = c.dim_gray },
	BlinkCmpKind = { fg = c.crystal_blue },
	BlinkCmpSource = { fg = c.dim_gray },
	BlinkCmpGhostText = { fg = c.dim_gray, italic = true },
	BlinkCmpDoc = { link = "NormalFloat" },
	BlinkCmpDocBorder = { link = "FloatBorder" },
	BlinkCmpSignatureHelp = { link = "NormalFloat" },
	BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
	BlinkCmpSignatureHelpActiveParameter = { link = "LspSignatureActiveParameter" },

	-- which-key
	WhichKey = { fg = c.amber },
	WhichKeyGroup = { fg = c.crystal_blue },
	WhichKeyDesc = { fg = c.fg },
	WhichKeySeparator = { fg = c.dim_gray },
	WhichKeyValue = { fg = c.dim_gray },
	WhichKeyNormal = { link = "NormalFloat" },
	WhichKeyBorder = { link = "FloatBorder" },

	-- indent-blankline
	IblIndent = { fg = c.slab_gray, nocombine = true },
	IblWhitespace = { fg = c.slab_gray, nocombine = true },
	IblScope = { fg = c.stalactite, nocombine = true },

	-- treesitter-context
	TreesitterContext = { bg = c.limestone_dark },
	TreesitterContextLineNumber = { fg = c.dim_gray, bg = c.limestone_dark },
	TreesitterContextBottom = { sp = c.stalactite, underline = true },

	-- mini.statusline (Tern statusLine* mapping)
	MiniStatuslineModeNormal = { fg = c.bg, bg = c.crystal_blue, bold = true },
	MiniStatuslineModeInsert = { fg = c.bg, bg = c.mineral_green, bold = true },
	MiniStatuslineModeVisual = { fg = c.bg, bg = c.amber, bold = true },
	MiniStatuslineModeReplace = { fg = c.bg, bg = c.error_red, bold = true },
	MiniStatuslineModeCommand = { fg = c.bg, bg = c.vein_blue, bold = true },
	MiniStatuslineModeOther = { fg = c.bg, bg = c.teal, bold = true },
	MiniStatuslineDevinfo = { fg = c.muted_gray, bg = c.stone_mid },
	MiniStatuslineFilename = { fg = c.crystal_blue, bg = c.chrome },
	MiniStatuslineFileinfo = { fg = c.muted_gray, bg = c.stone_mid },
	MiniStatuslineInactive = { fg = c.dim_gray, bg = c.chrome },

	-- mini.starter
	MiniStarterHeader = { fg = c.crystal_blue, bold = true },
	MiniStarterFooter = { fg = c.dim_gray, italic = true },
	MiniStarterSection = { fg = c.amber, bold = true },
	MiniStarterItem = { fg = c.fg },
	MiniStarterItemBullet = { fg = c.stalactite },
	MiniStarterItemPrefix = { fg = c.amber, bold = true },
	MiniStarterQuery = { fg = c.vein_blue, bold = true },
	MiniStarterCurrent = { bg = c.stone_mid },

	-- mini.surround / misc mini
	MiniSurround = { link = "IncSearch" },

	-- todo-comments
	TodoBgTODO = { link = "@comment.todo" },
	TodoBgFIX = { link = "@comment.error" },
	TodoBgWARN = { link = "@comment.warning" },
	TodoBgNOTE = { link = "@comment.note" },
	TodoBgHACK = { link = "@comment.warning" },
	TodoBgPERF = { fg = c.bg, bg = c.purple, bold = true },
	TodoBgTEST = { fg = c.bg, bg = c.teal, bold = true },
	TodoFgTODO = { fg = c.crystal_blue },
	TodoFgFIX = { fg = c.error_red },
	TodoFgWARN = { fg = c.amber },
	TodoFgNOTE = { fg = c.mineral_green },
	TodoFgHACK = { fg = c.amber },
	TodoFgPERF = { fg = c.purple },
	TodoFgTEST = { fg = c.teal },

	-- fidget
	FidgetTitle = { fg = c.crystal_blue, bold = true },
	FidgetTask = { fg = c.dim_gray },

	-- lazy.nvim / mason
	LazyNormal = { link = "NormalFloat" },
	LazyButton = { fg = c.muted_gray, bg = c.stone_mid },
	LazyButtonActive = { fg = c.bg, bg = c.crystal_blue, bold = true },
	LazyH1 = { fg = c.bg, bg = c.amber, bold = true },
	LazySpecial = { fg = c.crystal_blue },
	MasonNormal = { link = "NormalFloat" },
	MasonHeader = { fg = c.bg, bg = c.amber, bold = true },
	MasonHighlight = { fg = c.crystal_blue },
	MasonHighlightBlockBold = { fg = c.bg, bg = c.crystal_blue, bold = true },
	MasonMuted = { fg = c.dim_gray },

	-- snacks
	SnacksNormal = { link = "NormalFloat" },
	SnacksWinBar = { link = "FloatTitle" },
	SnacksBackdrop = { bg = c.chrome },
}

for name, spec in pairs(groups) do
	vim.api.nvim_set_hl(0, name, spec)
end

-- Transparency: let the terminal (Tern) background show through. Toggle with :TransparentToggle.
-- Popup menus stay opaque for readability.
if vim.g.transparent ~= false then
	for _, name in ipairs({
		"Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle", "FloatFooter",
		"SignColumn", "FoldColumn", "EndOfBuffer", "LineNr", "CursorLineNr",
		"StatusLine", "StatusLineNC", "TabLine", "TabLineFill",
		"MiniStatuslineFilename", "MiniStatuslineInactive",
		"NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer", "NeoTreeWinSeparator",
		"TreesitterContext", "TreesitterContextLineNumber", "SnacksBackdrop",
	}) do
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		hl.bg = nil
		hl.ctermbg = nil
		vim.api.nvim_set_hl(0, name, hl)
	end
end

vim.api.nvim_create_user_command("TransparentToggle", function()
	vim.g.transparent = vim.g.transparent == false
	vim.cmd.colorscheme("dark-cavern")
end, { force = true, desc = "Toggle transparent background" })
