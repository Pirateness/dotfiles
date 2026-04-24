return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		require("nvim-treesitter")
			.install({
				"lua",
				"typescript",
				"javascript",
				"svelte",
				"html",
				"css",
				"json",
				"c",
				"cpp",
				"rust",
				"python",
				"glsl",
				"markdown",
				"markdown_inline",
				"bash",
				"regex",
				"qmljs",
			})
			:wait(300000)
	end,
}
