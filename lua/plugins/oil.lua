return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				use_default_keymaps = false,
				default_file_explorer = true,
				watch_for_changes = true,
				delete_to_trash = true,
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-v>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-i>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-r>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				view_options = {
					show_hidden = true,
				},
				skip_confirm_for_simple_edits = true,
				git = {
					-- Return true to automatically git add/mv/rm files
					add = function(path)
						return false
					end,
					mv = function(src_path, dest_path)
						return true
					end,
					rm = function(path)
						return true
					end,
				},
			})

			-- Open parent directory in floating window
			vim.keymap.set("n", "<space>-", require("oil").toggle_float)
		end,
	},
}
