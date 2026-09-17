local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Neovim by default queries the background of the terminal, and can cause bugs when the background of the terminal
-- doesn't match the colorscheme of the current theme. When I'm sharing code I often switch between light/dark theme,
-- so we use to keep the background as "dark" permanently (this doesn't affect switching to light-mode, it just
-- resolves the bug)
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		if vim.v.option_new ~= "dark" then
			vim.opt.background = "dark"
		end
	end,
})

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup persistent undo
vim.opt.undofile = true

-- Make Cursor Stay Centered
vim.o.scrolloff = 999

-- Setup Relative Line Numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Customise Tab Sizing
local tabSize = 4
vim.opt.shiftwidth = tabSize
vim.opt.tabstop = tabSize
vim.opt.softtabstop = tabSize

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
	enabled = function()
		return not vim.tbl_contains({ "glsl", "markdown" }, vim.bo.filetype)
	end,
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
		"basedpyright",
		"glsl_analyzer",
		"qmlls",
		"stylua",
		"gopls",
		"buf_ls",
	},
	automatic_enable = {
		exclude = { "denols", "ts_ls", "rust_analyzer" },
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
	single_file_support = false,
})
vim.lsp.enable({ "denols", "ts_ls" })

vim.lsp.config("buf-lsp", {
	cmd = { "buf", "lsp", "serve" },
	filetypes = { "proto" },
	root_markers = { "buf.yaml", ".git" },
})

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

-- Enable Treesitter Highlighting
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- End of LSP Setup

-- Refactoring Setup
require("refactoring").setup()

-- Diagnostics Setup
vim.keymap.set("", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })

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
require("gitsigns").setup()

-- Setup Theme Manager
require("themery").setup({
	themes = {
		"catppuccin",
		"kanagawa",
		"nightfox",
		"oxocarbon",
		"jb",
		"dayfox",
		"carbonfox",
		"duskfox",
		"kanso",
		"burzum",
		"bathory",
		"dark-funeral",
		"darkthrone",
		"emperor",
		"gorgoroth",
		"immortal",
	}, -- Your list of installed colorschemes.
	livePreview = true, -- Apply theme while picking. Default to true.
})

require('kanso').setup({
	background = {
		dark = "zen",
	}
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
vim.opt.cmdheight = 0
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
local git_blame = require("gitblame")
require("lualine").setup({
	sections = {
		lualine_c = {
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{
				"filename",
				path = function()
					local file = vim.fn.expand("%:p")
					if vim.fn.filereadable(file) == 1 then
						return 1
					else
						return 1
					end
				end,
				symbols = { modified = "  ", readonly = "", unnamed = "" },
			},
			-- This is broken atm, removing until fixed
			-- { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
		},
	},
})

-- Setup Format on Save
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
-- })

-- Setup nvim-notify (Progress Notifcations)
require("notify").setup({
	background_colour = "#000000",
})
vim.notify = require("notify")

-- Make neovim background transparent
local function set_transparent_highlights()
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
	vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
end

set_transparent_highlights()

-- Reapply any time the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("TransparentFloats", { clear = true }),
	callback = set_transparent_highlights,
})

-- I can't remember what exactly these are for, but I'm sure at some point I'll need them again so leaving them in temporarily
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#9399B2", bg = "none" })
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#9399B2", bg = "none" })

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
		max_width = 80,
	})
end)

-- Telescope Setup
require("telescope").setup({
	defaults = {
		file_ignore_patterns = {
			"%.pb%.go$", -- Ignores Go Protobuf generated files
			"%.pb%.cc$", -- Ignores C++ Protobuf generated files
			"%.pb%.h$", -- Ignores C++ Protobuf headers
			"_pb2%.py$", -- Ignores Python Protobuf generated files
			"%.pb%.ts$", -- Ignores TypeScript Protobuf generated files
		},
	},
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
-- vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

-- Setup todo-comments (Note: I only use this for highlighting the todo comments, for searching I prefer just grepping the comments in Telescope)
require("todo-comments").setup()

-- Animations Setup
require("mini.animate").setup()

-- GENERAL KEYBINDS --

-- Show diagnostics for the current line
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float(nil, { focusable = true, scope = "line", max_width = 80 })
end, { desc = "Show line diagnostics" })

-- Go to Definition LSP Override
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Telescope: go to definition" })

-- Show undotree
vim.keymap.set("n", "<leader><F5>", function()
	vim.cmd.UndotreeToggle()
	vim.cmd.UndotreeFocus()
end)

-- BLAME!!!
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<CR>", {
	desc = "Git blame",
})

-- Setup Undotree Split Width
vim.g.undotree_SplitWidth = math.floor(vim.o.columns * 0.2)
