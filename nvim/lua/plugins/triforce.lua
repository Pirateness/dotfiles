return {
	"gisketch/triforce.nvim",
	dependencies = { "nvzone/volt" },
	keys = {
		{
			"<leader>xp",
			function()
				require("triforce").show_profile()
			end,
		},
	},
	opts = {},
}
