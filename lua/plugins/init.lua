return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				styles = {
					transparency = true, -- active la transparence native
				},
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
	{ "christoomey/vim-tmux-navigator", event = "VeryLazy" },
	{
		"theprimeagen/refactoring.nvim",
		lazy = true,
		cmd = { "Refactor", "RefactorExtract", "RefactorInline" }, -- Liste des commandes spécifiques
	},
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" } },
	},
	{
		"danymat/neogen",
		cmd = "Neogen",
		opts = {},
	},
}
