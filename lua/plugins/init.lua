return {
	-- Packer can manage itself
	{
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	},

	"christoomey/vim-tmux-navigator",
	{
		"theprimeagen/refactoring.nvim",
		lazy = true,
		cmd = { "Refactor", "RefactorExtract", "RefactorInline" }, -- Liste des commandes spécifiques
	},
	{ "mbbill/undotree" },
	{
		"tpope/vim-fugitive",
		lazy = true,
		cmd = { "Git", "Gstatus", "Gcommit", "Gpush", "Gpull" }, -- Liste des commandes qui déclenchent le chargement
	},
	"nvim-treesitter/nvim-treesitter-context",
	{
		"danymat/neogen",
		config = true,
		lazy = false,
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
	},
}
