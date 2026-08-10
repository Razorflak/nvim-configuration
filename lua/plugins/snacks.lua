return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		picker = {
			enabled = true,
			ui_select = true,
			layout = { preset = "telescope" },
		},
		lazygit = { enabled = true },
	},
	keys = {
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ hidden = true })
			end,
			desc = "Find files",
		},
		{
			"<leader>fi",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Git files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep({ hidden = true })
			end,
			desc = "Live grep",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help tags",
		},
		{
			"<leader>ft",
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>fv",
			function()
				Snacks.picker.grep_word()
			end,
			mode = "x",
			desc = "Grep visual selection",
		},
		{
			"<leader>fr",
			function()
				local search = vim.fn.input("Search: ")
				if search ~= "" then
					require("grug-far").open({ prefills = { search = search } })
				end
			end,
			desc = "Search and replace",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
	},
}
