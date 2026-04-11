local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = false },
})

-- Blink.cmp Setup
require("blink.cmp").setup({
	-- Disable Blink on Markdown and GLSL files (Blink.cmp currently has an unresolved bug affecting glsl files)
	enabled = function() return not vim.tbl_contains({ "glsl", "markdown" }, vim.bo.filetype) end,
	keymap = { preset = "super-tab" },
	sources = {
		default = { "lsp", "path", "buffer" },
		providers = {},
	},
	completion = {
		keyword = { range = "full" },
		trigger = {
			show_on_blocked_trigger_characters = { " ", "\n", "\t", "$", ":" },
		},
		--ghost_text = { enabled = true },
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
			window = {
				border = "rounded",
				winblend = 0,
			},
		},
		menu = {
			draw = { treesitter = { "lsp" } },
			border = "rounded",
			winblend = 0,
		},
	},
	signature = {
		enabled = true,
		window = {
			border = "rounded",
			winblend = 0,
		},
	},
})

-- LSP & Autocomplete Setup
require("mason").setup()
require("mason-lspconfig").setup({
	-- Always add language servers below so they are consistently installed across platforms, as adding them via
	-- Mason does not store them in the config in any way.
	-- NOTE: Anything other than language servers (e.g. Prettierd) will not be auto-installed
	ensure_installed = {
		"lua_ls",
		"ts_ls",
		"denols",
		"svelte",
		"jsonls",
		"html",
		"cssls",
		"clangd",
		"rust_analyzer",
		"pyright",
		"glsl_analyzer"
	},
	automatic_enable = {
		exclude = { "denols", "ts_ls" },
	},
})

-- mdsvex (Markdown in Svelte) does not have LSP support currently - in the meantime we simply associate .svx files as .md files
-- (or alternatively .svelte files - but I've chosen to go with .md for the moment)
vim.filetype.add({ extension = { svx = "markdown" } })

-- We manually setup the Deno and ts_ls language servers as they will conflict with each other with the default
-- mason-lspconfig settings. To do this we exclude them from being automatically enabled above and then set them
-- up via lspconfig
vim.lsp.config("denols", {
	root_markers = { "deno.json", "deno.jsonc" },
})
vim.lsp.config("ts_ls", {
	root_markers = { "package.json" },
	single_file_support = false
})
vim.lsp.enable({ "denols", "ts_ls" })

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}
-- End of LSP Setup

-- Diagnostics Setup
vim.keymap.set(
	"",
	"<Leader>l",
	require("lsp_lines").toggle,
	{ desc = "Toggle lsp_lines" }
)

vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
--
-- UFO Config

-- auto-session setup
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Tag Auto-Close Setup
require("nvim-ts-autotag").setup()

-- Character Auto-Close Setup
require("nvim-autopairs").setup()

-- Treesitter context setup
require("treesitter-context").setup({
	enable = true,
})

-- Setup Gitsigns
require('gitsigns').setup()

-- Setup Relative Line Numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Setup Theme Manager
require("themery").setup({
	themes = { "catppuccin", "kanagawa", "nightfox", "oxocarbon", "burzum", "bathory", "dark-funeral", "darkthrone", "emperor", "gorgoroth", "immortal" }, -- Your list of installed colorschemes.
	livePreview = true,                                                                                                                                 -- Apply theme while picking. Default to true.
})

-- Setup Aerial
require("aerial").setup({
	layout = {
		max_width = { 40, 0.4 },
		min_width = 30,
	},
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
	end,
})
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- Setup Lualine (bottom status bar)
require("lualine").setup()

-- Setup Format on Save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Setup nvim-notify (Progress Notifcations)
require("notify").setup({
	background_colour = "#000000"
})
vim.notify = require("notify")

-- Customise Tab Sizing
local tabSize = 4
vim.opt.shiftwidth = tabSize
vim.opt.tabstop = tabSize
vim.opt.softtabstop = tabSize

-- Make neovim background transparent
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#9399B2", bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#9399B2", bg = "none" })
-- Additional Transparency
vim.diagnostic.config({
	float = {
		border = "rounded", -- or "single", "double", "shadow", etc.
	},
})

-- Add border to LSP hover
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({
		border = "rounded",
	})
end)

-- Telescope Setup
require("telescope").setup({
	extensions = {
		aerial = {
			-- Set the width of the first two columns (the second
			-- is relevant only when show_columns is set to 'both')
			col1_width = 4,
			col2_width = 30,
			-- How to format the symbols
			format_symbol = function(symbol_path, filetype)
				if filetype == "json" or filetype == "yaml" then
					return table.concat(symbol_path, ".")
				else
					return symbol_path[#symbol_path]
				end
			end,
			-- Available modes: symbols, lines, both
			show_columns = "both",
		},
	},
})

-- Telescope Keybinds
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fo", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fn", ":Telescope notify<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

-- Setup todo-comments (Note: I only use this for highlighting the todo comments, for searching I prefer just grepping the comments in Telescope)
require("todo-comments").setup()

-- Animations Setup
require("mini.animate").setup()

-- GENERAL KEYBINDS --

-- Show diagnostics for the current line
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float(nil, { focusable = false, scope = "line" })
end, { desc = "Show line diagnostics" })

-- Go to Definition LSP Override
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Telescope: go to definition" })

-- Make Cursor Stay Centered
vim.o.scrolloff = 999
