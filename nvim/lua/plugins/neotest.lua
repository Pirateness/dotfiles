return {
	{
		"nvim-neotest/neotest",
		keys = {
			{
				"<leader>t",
				function()
					local neotest = require("neotest")
					neotest.run.run(vim.fn.expand("%"))
					neotest.summary.open()
				end,
				desc = "Run nearest test",
			},
			{
				"q",
				function()
					local summary = require("neotest").summary
					summary.close()
				end,
				desc = "Close Neotest summary",
			},
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			{
				"fredrikaverpil/neotest-golang",
				version = "*", -- Optional, but recommended; track releases
				build = function()
					vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
				end,
			},
		},
		config = function()
			local config = {
				runner = "gotestsum", -- Optional, but recommended
			}
			require("neotest").setup({
				adapters = {
					require("neotest-golang")(config),
					require("rustaceanvim.neotest"),
				},
			})
		end,
	},
}
