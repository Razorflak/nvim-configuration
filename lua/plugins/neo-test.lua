local VITEST_PATTERNS = {
	"vitest.config.ts",
	"vitest.config.js",
	"vitest.config.mjs",
	"vitest.config.cjs",
	"vitest.config.mts",
	"vitest.config.cts",
}
local JEST_PATTERNS = {
	"jest.config.js",
	"jest.config.ts",
	"jest.config.mjs",
	"jest.config.cjs",
	"jest.config.json",
}

local function find_closest_config(path, patterns)
	local start = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
	local config = vim.fs.find(patterns, { path = start, upward = true })[1]
	if not config then
		return nil, math.huge, nil
	end

	local root = vim.fs.dirname(config)
	local relative = path:sub(#root + 1)
	local _, distance = relative:gsub("[/\\]", "")
	return root, distance, config
end

local function get_closest_test_config(path)
	local vitest_root, vitest_dist, vitest_config = find_closest_config(path, VITEST_PATTERNS)
	local jest_root, jest_dist, jest_config = find_closest_config(path, JEST_PATTERNS)

	if vitest_dist < jest_dist then
		return "vitest", vitest_root, vitest_config
	end
	if jest_dist < vitest_dist then
		return "jest", jest_root, jest_config
	end
	if vitest_root then
		return "vitest", vitest_root, vitest_config
	end
	if jest_root then
		return "jest", jest_root, jest_config
	end
	return nil, nil, nil
end

local function is_test_file(path)
	return path ~= nil
		and (
			path:match("[._]test%.[cm]?[jt]sx?$") ~= nil
			or path:match("[._]spec%.[cm]?[jt]sx?$") ~= nil
			or path:match("[/\\]__tests__[/\\]") ~= nil
		)
end

local function uses_adapter(path, adapter)
	if not is_test_file(path) then
		return false
	end
	local selected = get_closest_test_config(path)
	return selected == adapter
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
	},
	config = function()
		local neotest_vitest = require("neotest-vitest")({
			vitestCommand = "pnpm exec vitest run --no-coverage",
			is_test_file = function(path)
				return uses_adapter(path, "vitest")
			end,
			cwd = function(path)
				local _, root = get_closest_test_config(path)
				return root or vim.fn.getcwd()
			end,
			vitestConfigFile = function(path)
				local _, _, config = get_closest_test_config(path)
				return config
			end,
		})

		local neotest_jest = require("neotest-jest")({
			isTestFile = function(path)
				return uses_adapter(path, "jest")
			end,
			cwd = function(path)
				local _, root = get_closest_test_config(path)
				return root or vim.fn.getcwd()
			end,
			jestConfigFile = function(path)
				local _, _, config = get_closest_test_config(path)
				return config
			end,
		})

		require("neotest").setup({
			output_panel = {
				open = "botright vsplit | vertical resize " .. math.floor(vim.o.columns * 0.5),
			},
			adapters = {
				neotest_vitest,
				neotest_jest,
			},
			-- Discovery SAFE : évite le bug autocmd fast event
			discovery = {
				enabled = true,
				timeout = 2000,
			},
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
				require("neotest").run.run(vim.uv.cwd())
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
