local IS_DEV = false

local prompts = {
	-- Prompts liés au code
	Explain = "Veuillez expliquer comment fonctionne le code suivant.",
	Review = "Veuillez examiner le code suivant et fournir des suggestions pour l'améliorer.",
	Tests = "Veuillez expliquer comment fonctionne le code sélectionné, puis générer des tests unitaires pour celui-ci.",
	Refactor = "Veuillez refactoriser le code suivant pour améliorer sa clarté et sa lisibilité.",
	FixCode = "Veuillez corriger le code suivant pour qu'il fonctionne comme prévu.",
	FixError = "Veuillez expliquer l'erreur dans le texte suivant et fournir une solution.",
	BetterNamings = "Veuillez fournir de meilleurs noms pour les variables et fonctions suivantes.",
	Documentation = "Veuillez fournir de la documentation pour le code suivant.",
	SwaggerApiDocs = "Veuillez fournir de la documentation pour l'API suivante en utilisant Swagger.",
	SwaggerJsDocs = "Veuillez écrire des JSDoc pour l'API suivante en utilisant Swagger.",
	-- Prompts liés au texte
	Summarize = "Veuillez résumer le texte suivant.",
	Spelling = "Veuillez corriger les fautes de grammaire et d'orthographe dans le texte suivant.",
	Wording = "Veuillez améliorer la grammaire et la formulation du texte suivant.",
	Concise = "Veuillez réécrire le texte suivant pour le rendre plus concis.",
	Mock = "Veuillez générer un objet fictif pour le type Typescript sélectionné.",
	MockNoUndefined = "Veuillez générer un objet fictif pour le type Typescript sélectionné. Si une valeur est optionnelle, remplissez l'objet avec une valeur.",
}

return {
	{
		dir = IS_DEV and "~/Projects/research/CopilotChat.nvim" or nil,

		"CopilotC-Nvim/CopilotChat.nvim",
		version = "v3.3.1",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			question_header = "## User ",
			answer_header = "## Copilot ",
			error_header = "## Error ",
			prompts = prompts,
			auto_follow_cursor = false, -- Don't follow the cursor after getting response
			show_help = false, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				-- Close the chat
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				-- Reset the chat buffer
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				-- Submit the prompt to Copilot
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				-- Accept the diff
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				-- Yank the diff in the response to register
				yank_diff = {
					normal = "<leader>cy",
				},
				-- Show the diff
				show_diff = {
					normal = "<leader>cd",
				},
				-- Show the prompt
				show_info = {
					normal = "gmp",
				},
				show_context = {
					normal = "<leader>cx",
				},
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")
			-- Use unnamed register for the selection
			opts.selection = select.unnamed

			-- Override the git prompts message
			opts.prompts.Commit = {
				prompt = "Write commit message for the change with commitizen convention",
				selection = select.gitdiff,
			}
			opts.prompts.CommitStaged = {
				prompt = "Write commit message for the change with commitizen convention",
				selection = function(source)
					return select.gitdiff(source, true)
				end,
			}

			chat.setup(opts)

			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })

			-- Restore CopilotChatBuffer
			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = select.buffer })
			end, { nargs = "*", range = true })

			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true

					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end,
		event = "VeryLazy",
		keys = {
			{
				"<leader>ccp",
				":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
				mode = "x",
				desc = "CopilotChat - Prompt actions",
			},
			{ "<leader>ccc", "<cmd>CopilotChat<cr>", desc = "CopilotChat - Toggle CopilotChat window" },
			{
				"<leader>ccb",
				mode = "n",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "CopilotChat - Quick chat about the buffer",
			},
			{
				"<leader>ccv",
				mode = "x",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, {
							selection = require("CopilotChat.select").visual,
							system_prompt = "Tu es un ingénieur, expert en développement. Réponds au questions de manière clair sans inventer d'information.",
						})
					end
				end,
				desc = "CopilotChat - Quick chat about the visual selection",
			},
		},
	},
}
