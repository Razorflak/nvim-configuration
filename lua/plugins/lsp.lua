local function project_config(files)
	return {
		root_dir = function(bufnr)
			return vim.fs.root(bufnr, files)
		end,
	}
end

return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua-language-server",
				"rust-analyzer",
				"typescript-language-server",
				"svelte-language-server",
				"tailwindcss-language-server",
				"eslint-lsp",
				"biome",
				"stylua",
				"prettierd",
				"black",
				"isort",
				"js-debug-adapter",
			},
			run_on_start = true,
			start_delay = 3000,
			debounce_hours = 24,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
				handlers = {
					["textDocument/hover"] = function(err, result, ctx, config)
						config = vim.tbl_extend("force", config or {}, { border = "rounded" })
						return vim.lsp.handlers.hover(err, result, ctx, config)
					end,
					["textDocument/signatureHelp"] = function(err, result, ctx, config)
						config = vim.tbl_extend("force", config or {}, { border = "rounded" })
						return vim.lsp.handlers.signature_help(err, result, ctx, config)
					end,
				},
			})

			for _, server in ipairs({ "lua_ls", "tailwindcss", "rust_analyzer", "svelte" }) do
				vim.lsp.config(server, {})
				vim.lsp.enable(server)
			end

			vim.lsp.config("biome", project_config({ "biome.json", "biome.jsonc" }))
			vim.lsp.enable("biome")

			vim.lsp.config(
				"eslint",
				project_config({
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.json",
				})
			)
			vim.lsp.enable("eslint")

			vim.lsp.config("ts_ls", {
				on_attach = function(client, bufnr)
					vim.keymap.set("n", "gds", function()
						local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
						client:exec_cmd({
							command = "_typescript.goToSourceDefinition",
							arguments = { vim.api.nvim_buf_get_name(bufnr), params.position },
						}, { bufnr = bufnr })
					end, { buffer = bufnr, desc = "TypeScript source definition" })
				end,
			})
			vim.lsp.enable("ts_ls")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("razorflak-lsp", { clear = true }),
				callback = function(event)
					local opts = { buffer = event.buf }
					local function map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
					end

					map("gD", vim.lsp.buf.type_definition, "Type definition")
					map("gd", vim.lsp.buf.definition, "Definition")
					map("gdd", vim.lsp.buf.definition, "Definition")
					map("gdv", function()
						vim.cmd.vsplit()
						vim.lsp.buf.definition()
					end, "Definition in vertical split")
					map("<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
					map("<leader>vd", vim.diagnostic.open_float, "Line diagnostics")
					map("<leader>ee", function()
						vim.diagnostic.jump({ count = 1 })
					end, "Next diagnostic")
					map("<leader>ez", function()
						vim.diagnostic.jump({ count = -1 })
					end, "Previous diagnostic")
					map("<leader>vca", vim.lsp.buf.code_action, "Code action")
					map("<leader>vrn", vim.lsp.buf.rename, "Rename symbol")
					vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {
						buffer = event.buf,
						desc = "Signature help",
					})
				end,
			})

			vim.diagnostic.config({ virtual_text = { current_line = true } })

			vim.api.nvim_create_user_command("LspStopStart", function()
				vim.cmd("LspStop")
				vim.defer_fn(function()
					vim.cmd("LspStart")
				end, 500)
			end, { desc = "Restart LSP clients" })
		end,
	},
}
