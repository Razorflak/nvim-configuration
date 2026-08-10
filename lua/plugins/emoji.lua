return {
	"allaman/emoji.nvim",
	version = "1.0.0",
	ft = "markdown",
	opts = {
		-- default is false, also needed for blink.cmp integration!
		enable_cmp_integration = false,
		-- optional if your plugin installation directory
		-- is not vim.fn.stdpath("data") .. "/lazy/
		plugin_path = vim.fn.expand("$HOME/plugins/"),
	},
	config = function(_, opts)
		require("emoji").setup(opts)
		vim.keymap.set("n", "<leader>em", require("emoji").insert, { desc = "[EM]oji" })
	end,
}
