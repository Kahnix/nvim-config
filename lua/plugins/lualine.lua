-- Bubble-style statusline. Section colors come from lua/lualine/themes/<colorscheme>.lua, which
-- lualine picks up via `theme = "auto"`; component colors follow the colorscheme's highlight groups.
local nf = vim.g.have_nerd_font

local function lsp_clients()
	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		names[#names + 1] = client.name
	end
	return table.concat(names, " ")
end

-- showmode is off, so surface macro recording here instead.
local function macro_recording()
	local reg = vim.fn.reg_recording()
	return reg ~= "" and "recording @" .. reg or ""
end

local function gitsigns_diff()
	local status = vim.b.gitsigns_status_dict
	if status then
		return { added = status.added, modified = status.changed, removed = status.removed }
	end
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function fg(group)
			return function()
				return { fg = Snacks.util.color(group) }
			end
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = true,
				icons_enabled = nf,
				component_separators = "",
				section_separators = nf and { left = "", right = "" } or "",
				disabled_filetypes = { statusline = { "ministarter" } },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icon = "",
						separator = nf and { left = "", right = "" } or nil,
						padding = { left = 0, right = 1 },
					},
				},
				lualine_b = {
					{ "branch", icon = "" },
					{
						"diff",
						source = gitsigns_diff,
						symbols = nf and { added = " ", modified = " ", removed = " " } or nil,
					},
				},
				lualine_c = {
					{ "filetype", icon_only = true, padding = { left = 2, right = 0 } },
					{
						"filename",
						path = 1,
						symbols = {
							modified = "●",
							readonly = nf and "" or "[RO]",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
						color = fg("Normal"),
					},
					{
						"diagnostics",
						symbols = nf and { error = "󰅚 ", warn = "󰀪 ", info = "󰋽 ", hint = "󰌶 " } or nil,
					},
				},
				lualine_x = {
					{ macro_recording, color = fg("DiagnosticError") },
					{ "searchcount", color = fg("Special") },
					{ lsp_clients, icon = "", color = fg("Comment") },
				},
				lualine_y = { "progress" },
				lualine_z = {
					{
						"location",
						icon = "",
						separator = nf and { left = "", right = "" } or nil,
						padding = { left = 1, right = 0 },
					},
				},
			},
			extensions = { "neo-tree", "lazy", "mason", "quickfix", "man" },
		})

		-- reg_recording() is still set during RecordingLeave; refresh once it has cleared.
		vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
			group = vim.api.nvim_create_augroup("lualine-recording", { clear = true }),
			callback = function()
				vim.schedule(require("lualine").refresh)
			end,
		})
	end,
}
