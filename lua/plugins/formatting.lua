local project_formatters = {
	{ path = "neomed.git/develop", formatter = "prettier" },
	{ path = "neomed.git/test-synth", formatter = "prettier" },
	{ path = "neomed.git/fid-token", formatter = "prettier" },
	{ path = "neomed.git/fcr-", formatter = "prettier" },
	{ path = "neomed.git/neo-331-med19-numberly", formatter = "prettier" },
	{ path = "stickycom.git", formatter = "eslint_d" },
	{ path = "neomed.git", formatter = "prettier" },
	{ path = "kadokajo", formatter = "eslint_d" },
}

local function get_formatter(default_formatter)
	local root_dir = vim.fn.getcwd()
	for _, project in ipairs(project_formatters) do
		if string.find(root_dir, project.path) then
			return { project.formatter }
		end
	end
	return { default_formatter }
end

return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "biome", "prettier" },
				-- typescript = {"biome", "prettier"},
				javascriptreact = { "biome", "prettier" },
				typescriptreact = { "biome", "prettier" },
				typescript = function()
					return get_formatter("prettier")
				end,
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			format_on_save = {
				lsp_fallback = false,
				async = false,
				timeout_ms = 3000,
			},
			notify_on_error = false,
			log_level = vim.log.levels.DEBUG,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
