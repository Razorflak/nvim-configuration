local obsidian_notes = "/Users/julien_tanguy2/Google Drive/Mon Drive/Obsidian-vault/work"
return {
	"epwalsh/obsidian.nvim",
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
		-- Required.
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "work",
				path = "/Users/julien_tanguy2/Google Drive/Mon Drive/Obsidian-vault/work",
				overrides = {
					notes_subdir = "inbox",
				},
			},
			{
				name = "personal",
				path = "~/vaults/personal",
			},
		},
		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
			name = "telescope.nvim",
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
			date_format = "%Y%m%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, default tags to add to each new daily note created.
			default_tags = { "daily-notes" },
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = "daily.md",
		},
		disable_frontmatter = true,
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
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

		-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},
		ui = {
			enable = true, -- set to false to disable all additional syntax features
			update_debounce = 200, -- update delay after a text change (in milliseconds)
			max_file_length = 5000, -- disable UI features for files with more than this many lines
			-- Define how various check-boxes are displayed
			checkboxes = {
				-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				["!"] = { char = "", hl_group = "ObsidianImportant" },
				-- Replace the above with this if you don't have a patched font:
				-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
				-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

				-- You can also add more custom ones...
			},
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
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			-- Smart action depending on context, either follow link or toggle checkbox.
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
			-- Recherche dans les notes Obsidian
			["<leader>nff"] = {
				action = function()
					vim.cmd("ObsidianSearch")
				end,
				opts = { buffer = true },
			},
			--Créer une nouvelle note from template
			["<leader>nn"] = {
				action = function()
					vim.cmd("ObsidianNewFromTemplate")
				end,
				opts = { buffer = true },
			},
			-- Ouvre la note du jour
			["<leader>nft"] = {
				action = function()
					vim.cmd("ObsidianTags")
				end,
				opts = { buffer = true },
			},
			-- Ouvre la note du jour
			["<leader>nt"] = {
				action = function()
					vim.cmd("ObsidianTemplate")
				end,
				opts = { buffer = true },
			},
			["<leader>nk"] = {
				action = function()
					local current_file = vim.fn.expand("%:p")
					local target_dir = obsidian_notes .. "/tomove"
					vim.cmd("silent! !mv '" .. current_file .. "' '" .. target_dir .. "'")
					vim.cmd("bd!")
				end,
				desc = "Déplacer la note courante dans 'tomove'",
			},
			["<leader>ndd"] = {
				action = function()
					local current_file = vim.fn.expand("%:p")
					vim.cmd("silent! !rm -f '" .. current_file .. "'")
					vim.cmd("bd!")
				end,
				desc = "Supprimer la note courante",
			},
		},
		-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
		-- URL it will be ignored but you can customize this behavior here.
		---@param url string
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			vim.fn.jobstart({ "open", url }) -- Mac OS
			-- vim.fn.jobstart({"xdg-open", url})  -- linux
			-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
			-- vim.ui.open(url) -- need Neovim 0.10.0+
		end,
		-- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
		-- file it will be ignored but you can customize this behavior here.
		---@param img string
		follow_img_func = function(img)
			vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
			-- vim.fn.jobstart({"xdg-open", url})  -- linux
			-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
		end,

		-- see below for full list of options 👇
	},
}
