return {
	"folke/zen-mode.nvim",
	keys = {
		{
			"<leader>zm",
			function()
				require("zen-mode").toggle()
			end,
		},
	},
	opts = {
		window = {
			width = 80,
			options = {
				signcolumn = "no",
			},
		},
	},
}
