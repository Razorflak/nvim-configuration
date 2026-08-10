local obsidian_notes = _G.LocalConfig and _G.LocalConfig.obsidian_path
if not obsidian_notes or obsidian_notes == "" then
	return {}
end

obsidian_notes = vim.fs.normalize(vim.fn.expand(obsidian_notes))

-- 🔍 Rechercher un fichier dans les notes
vim.keymap.set("n", "<leader>nfs", function()
	Snacks.picker.files({ cwd = obsidian_notes, hidden = true, ignored = true })
end)

-- 🔎 Faire une recherche texte dans les notes
vim.keymap.set("n", "<leader>nfg", function()
	Snacks.picker.grep({ cwd = obsidian_notes, hidden = true })
end)

return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		"folke/snacks.nvim",
		"saghen/blink.cmp",
	},
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "work",
				path = obsidian_notes .. "/work",
				overrides = {
					notes_subdir = "inbox",
				},
			},
		},
		picker = {
			name = "snacks.picker",
			-- Optional, configure key mappings for the picker. These are the defaults.
			-- Not all pickers support all mappings.
			note_mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
			tag_mappings = {
				-- Add tag(s) to current note.
				tag_note = "<C-x>",
				-- Insert a tag at the current location.
				insert_tag = "<C-l>",
			},
		},
		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "notes/dailies",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "YYYYMMDD",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "MMMM D, YYYY",
			-- Optional, default tags to add to each new daily note created.
			default_tags = { "daily-notes" },
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = "daily.md",
		},
		templates = {
			folder = "templates",
			date_format = "YYYY-MM-DD",
			time_format = "HH:mm",
			substitutions = {
				toto = function()
					return os.date("%Y%m%d", os.time() - 86400) .. ".md"
				end,
				yesterdaynote = function()
					return os.date("%Y%m%d", os.time() - 86400)
				end,
				tomorrownote = function()
					return os.date("%Y%m%d", os.time() + 86400)
				end,
			},
		},

		frontmatter = { enabled = false },
		ui = {
			enable = true, -- set to false to disable all additional syntax features
			update_debounce = 200, -- update delay after a text change (in milliseconds)
			max_file_length = 5000, -- disable UI features for files with more than this many lines
			-- Use bullet marks for non-checkbox lists.
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			-- Replace the above with this if you don't have a patched font:
			-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			block_ids = { hl_group = "ObsidianBlockID" },
			hl_groups = {
				-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
				ObsidianTodo = { bold = true, fg = "#f78c6c" },
				ObsidianDone = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde = { bold = true, fg = "#ff5370" },
				ObsidianImportant = { bold = true, fg = "#d73128" },
				ObsidianBullet = { bold = true, fg = "#89ddff" },
				ObsidianRefText = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag = { italic = true, fg = "#89ddff" },
				ObsidianBlockID = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},
	},
	config = function(_, opts)
		require("obsidian").setup(opts)

		local function set_mappings(buffer)
			local map_opts = { buffer = buffer, silent = true }
			local function map(lhs, rhs, desc, extra)
				vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", map_opts, extra or {}, { desc = desc }))
			end

			map("<CR>", require("obsidian.actions").smart_action, "Obsidian smart action", { expr = true })
			map("<leader>nff", "<cmd>Obsidian search<cr>", "Search notes")
			map("<leader>nn", "<cmd>Obsidian new_from_template<cr>", "New note from template")
			map("<leader>nft", "<cmd>Obsidian tags<cr>", "Obsidian tags")
			map("<leader>nt", "<cmd>Obsidian template<cr>", "Insert Obsidian template")
			map("<leader>nk", function()
				local current_file = vim.api.nvim_buf_get_name(buffer)
				local target = obsidian_notes .. "/work/tomove/" .. vim.fs.basename(current_file)
				if vim.fn.rename(current_file, target) == 0 then
					vim.api.nvim_buf_delete(buffer, { force = true })
				else
					vim.notify("Impossible de déplacer la note", vim.log.levels.ERROR)
				end
			end, "Move note to tomove")
			map("<leader>ndd", function()
				if vim.fn.delete(vim.api.nvim_buf_get_name(buffer)) == 0 then
					vim.api.nvim_buf_delete(buffer, { force = true })
				else
					vim.notify("Impossible de supprimer la note", vim.log.levels.ERROR)
				end
			end, "Delete note")
		end

		if vim.bo.filetype == "markdown" then
			set_mappings(0)
		end
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("razorflak-obsidian-mappings", { clear = true }),
			pattern = "markdown",
			callback = function(event)
				set_mappings(event.buf)
			end,
		})
	end,
}
