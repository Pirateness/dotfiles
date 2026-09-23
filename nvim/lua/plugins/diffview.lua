return {
	"sindrets/diffview.nvim",
	vim.keymap.set("v", "<leader>gh", ":DiffviewFileHistory<CR>", {
		desc = "Git file history for selection",
	}),
	vim.keymap.set("n", "<leader>dv", function()
		if require("diffview.lib").get_current_view() then
			vim.cmd("DiffviewClose")
		else
			vim.cmd("DiffviewOpen")
		end
	end, {
		desc = "Toggle Git file history",
	}),
	vim.keymap.set("n", "<leader>gh", function()
		if require("diffview.lib").get_current_view() then
			vim.cmd("DiffviewClose")
		else
			vim.cmd("DiffviewFileHistory")
		end
	end, {
		desc = "Toggle Git file history",
	}),
}
