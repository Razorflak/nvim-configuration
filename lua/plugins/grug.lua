return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			keymaps = {
				replace = { n = "<leader>rr" },
				qflist = { n = "<leader>rq" },
				syncLocations = { n = "<leader>rs" },
				syncLine = { n = "<leader>rl" },
				close = { n = "<leader>rc" },
				historyOpen = { n = "<leader>rt" },
				historyAdd = { n = "<leader>ra" },
				refresh = { n = "<leader>rf" },
				openLocation = { n = "<leader>ro" },
				openNextLocation = { n = "<down>" },
				openPrevLocation = { n = "<up>" },
				gotoLocation = { n = "<enter>" },
				pickHistoryEntry = { n = "<enter>" },
				abort = { n = "<leader>rb" },
				help = { n = "g?" },
				toggleShowCommand = { n = "<leader>rp" },
				swapEngine = { n = "<leader>re" },
			},
		})
	end,
}
