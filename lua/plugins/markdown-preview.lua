-- Render Markdown, including Mermaid diagrams, in the default browser.
return {
	"iamcco/markdown-preview.nvim",
	ft = "markdown",
	cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
	build = "cd app && npm install",
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Toggle [M]arkdown [P]review" },
	},
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_theme = "dark"
	end,
}
