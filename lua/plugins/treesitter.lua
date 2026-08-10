local languages = {
	"lua",
	"typescript",
	"javascript",
	"svelte",
	"html",
	"css",
	"json",
	"rust",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			require("nvim-treesitter").install(languages)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("razorflak-treesitter", { clear = true }),
				pattern = {
					"lua",
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
					"svelte",
					"html",
					"css",
					"json",
					"rust",
				},
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
	},
}
