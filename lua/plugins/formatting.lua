local function get_formatters(bufnr)
	local util = require("lspconfig.util")

	-- Check si le path du buffer contient formatter_override.path et si c'est vrai, retourner formatter_override.formatter
	local formatter_override = _G.LocalConfig and _G.LocalConfig.formatter_override
	if formatter_override then
		local path = vim.api.nvim_buf_get_name(bufnr)
		if string.find(path, formatter_override.path) then
			return { formatter_override.formatter }
		end
	end
	local function get_distance(path, root)
		if not root or root == "" then
			return 999
		end
		local common_len = #path - #root
		local rel_path = path:sub(common_len + 1)
		if not rel_path or rel_path == "/" or rel_path == "\\" then
			return 1
		end
		local slashes = 0
		for i = 1, #rel_path do
			if rel_path:sub(i, i) == util.path.sep then
				slashes = slashes + 1
			end
		end
		return slashes + 1
	end

	if not bufnr then
		return { "prettierd" }
	end
	local path = vim.api.nvim_buf_get_name(bufnr)
	if not path or vim.bo[bufnr].buftype ~= "" then
		return { "prettierd" }
	end

	-- PRETTIER
	local prettier_root = util.root_pattern(
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.js",
		".prettierrc.cjs",
		"prettier.config.js",
		"prettier.config.cjs"
	)(path)
	local prettier_dist = get_distance(path, prettier_root)

	local biome_root = util.root_pattern("biome.json", "biome.jsonc")(path)
	local biome_dist = get_distance(path, biome_root)

	local eslint_root = util.root_pattern(
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
		"eslint.config.js"
	)(path)
	local eslint_dist = get_distance(path, eslint_root)

	local closest_dist = math.min(prettier_dist or 999, biome_dist or 999, eslint_dist or 999)
	local candidates = {}

	if prettier_dist == closest_dist then
		table.insert(candidates, { "prettierd", prettier_root })
	end
	if biome_dist == closest_dist then
		table.insert(candidates, { "biome", biome_root })
	end
	if eslint_dist == closest_dist then
		table.insert(candidates, { "eslint_d", eslint_root })
	end

	for _, candidate in ipairs(candidates) do
		local formatter, root = candidate[1], candidate[2]
		local info = require("conform").get_formatter_info(formatter, bufnr)
		if info.available then
			return { formatter }
		end
	end

	return { "prettierd" }
end

return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd", "biome", "eslint_d" },
				javascriptreact = { "prettierd", "biome", "eslint_d" },
				typescriptreact = { "prettierd", "biome", "eslint_d" },
				typescript = function(bufnr)
					return get_formatters(bufnr)
				end,
				svelte = function(bufnr)
					return get_formatters(bufnr)
				end,
				css = { "prettierd" },
				html = { "prettierd" },
				json = function(bufnr)
					return get_formatters(bufnr)
				end,
				yaml = { "prettierd" },
				markdown = nil,
				graphql = { "prettierd" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			format_on_save = { lsp_fallback = false, async = false, timeout_ms = 3000 },
			notify_on_error = false,
			log_level = vim.log.levels.DEBUG,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({ lsp_fallback = true, async = false, timeout_ms = 3000 })
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
