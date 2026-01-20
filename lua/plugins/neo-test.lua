local util = require("lspconfig.util")

local VITEST_PATTERNS =
	{ "vitest.config.ts", "vitest.config.js", "vitest.config.mjs", "vitest.config.cjs", "vite.config.ts" }
local JEST_PATTERNS = { "jest.config.js", "jest.config.ts", "jest.config.mjs", "jest.config.cjs", "jest.config.json" }

local function find_closest_config(path, patterns)
	local root = util.root_pattern(unpack(patterns))(path)
	if not root then
		return nil, math.huge
	end
	local distance = select(2, path:gsub(root, "")):gsub("/", ""):len()
	return root, distance
end

local function getClosestTestConfig(path)
	local vitest_root, vitest_dist = find_closest_config(path, VITEST_PATTERNS)
	local jest_root, jest_dist = find_closest_config(path, JEST_PATTERNS)

	if vitest_dist < jest_dist then
		return "vitest", vitest_root
	end
	if jest_dist < vitest_dist then
		return "jest", jest_root
	end
	if vitest_root then
		return "vitest", vitest_root
	end
	if jest_root then
		return "jest", jest_root
	end
	return nil, vim.fn.getcwd()
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
	},
	config = function()
		-- Base adapters (sans overrides complexes qui peuvent causer async issues)
		local neotest_vitest = require("neotest-vitest")({
			vitestCommand = "pnpx vitest run --no-coverage",
		})
		local neotest_jest = require("neotest-jest")({
			jestCommand = "pnpx jest",
		})

		require("neotest").setup({
			output_panel = {
				open = "botright vsplit | vertical resize " .. math.floor(vim.o.columns * 0.5),
			},
			adapters = {
				neotest_vitest,
				-- neotest_jest,
			},
			-- Discovery SAFE : évite le bug autocmd fast event
			discovery = {
				enabled = true,
				timeout = 2000,
			},
			-- Simple cwd override sans async heavy
			cwd = function(file)
				local _, root = getClosestTestConfig(file)
				return root
			end,
		})
	end,
	event = "VeryLazy",
	keys = {
		{
			"<leader>tt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run Test File",
		},
		{
			"<leader>tT",
			function()
				require("neotest").run.run(vim.loop.cwd())
			end,
			desc = "Run All Test Files",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest Test",
		},
		{
			"<leader>trr",
			function()
				vim.schedule(function()
					require("neotest").reload()
					vim.notify("Neotest reloaded", vim.log.levels.INFO)
				end)
			end,
			desc = "Reload Tests",
		},
		{
			"<leader>td",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Run Debug Test",
		},
		{
			"<leader>ts",
			function()
				vim.schedule(require("neotest").summary.toggle)
			end,
			desc = "Toggle Test Summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Test Output",
		},
		{
			"<leader>tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop Running Test",
		},
		{
			"<leader>tw",
			function()
				require("neotest").watch.watch(vim.fn.expand("%"))
			end,
			desc = "Running Test File in watch mode",
		},
	},
}
