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
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim", "xiyaowong/telescope-emoji.nvim" },
	config = function()
		require("telescope").setup({})
		require("telescope").load_extension("emoji")
		local builtin = require("telescope.builtin")
		-- vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.api.nvim_set_keymap(
			"n",
			"<leader>ff",
			":lua require('telescope.builtin').find_files({ hidden = true })<CR>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set("n", "<leader>fi", builtin.git_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>ft", builtin.registers, {})
		-- Permet de basculer de la recherche de la sélection visuel à une recherche sur telescope
		vim.keymap.set("v", "<leader>fv", function()
			local text = vim.getVisualSelection()
			builtin.grep_string({ search = text })
		end)
		-- En mode search, bascule la recherche sur CtrlSF pour remplacer
		vim.keymap.set("n", "<leader>fr", function()
			local action_state = require("telescope.actions.state")
			local search_string = action_state.get_current_line()
			if search_string == "" then
				return
			end
			vim.cmd("CtrlSF " .. vim.fn.fnameescape(search_string))
		end)
	end,
}
