function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	---@diagnostic disable-next-line: param-type-mismatch
	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

return {
	"nvim-telescope/telescope.nvim",
	lazy = true,
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim", "xiyaowong/telescope-emoji.nvim" },
	config = function()
		require("telescope").setup({})
		require("telescope").load_extension("emoji")
	end,
	keys = {
		{
			"<leader>ff",
			":lua require('telescope.builtin').find_files({ hidden = true })<CR>",
			mode = "n",
			noremap = true,
			silent = true,
		},
		{
			"<leader>fi",
			function()
				require("telescope.builtin").git_files()
			end,
			mode = "n",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep({
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end,
			mode = "n",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			mode = "n",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			mode = "n",
		},
		{
			"<leader>ft",
			function()
				require("telescope.builtin").registers()
			end,
			mode = "n",
		},
		{
			"<leader>fv",
			function()
				local text = vim.getVisualSelection()
				require("telescope.builtin").grep_string({
					search = text,
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end,
			mode = "v",
		},
		{
			"<leader>fr",
			function()
				local action_state = require("telescope.actions.state")
				local search_string = action_state.get_current_line()
				if search_string == "" then
					return
				end
				vim.cmd("CtrlSF " .. vim.fn.fnameescape(search_string))
			end,
			mode = "n",
		},
	},
}
