-- Run from the config directory: nvim --clean -l tests/java.lua
local config, enabled, command, options
package.loaded.jdtls = { extendedClientCapabilities = { test = true } }
vim.lsp.config = function(name, value)
	assert(name == "jdtls")
	config = value
end
vim.lsp.enable = function(name)
	enabled = name
end
vim.lsp.rpc.start = function(cmd)
	command = cmd
end

local spec = dofile("lua/plugins/java.lua")[1]
assert(spec.ft == "java")
spec.config()
assert(enabled == "jdtls")
assert(config.init_options.extendedClientCapabilities.test)
assert(#config.init_options.bundles == 1)
config.cmd({}, { root_dir = "/tmp/one/project" })
local workspace = command[3]
assert(command[1] == "jdtls" and command[2] == "-data")
assert(command[6]:match("^%-%-jvm%-arg=%-javaagent:.*/share/jdtls/lombok.jar$"))
config.cmd({}, { root_dir = "/tmp/two/project" })
assert(command[3] ~= workspace, "Projects with identical names must have separate indexes")
config.cmd({}, {})
assert(command[3]:find(vim.fn.sha256(vim.fn.getcwd()), 1, true))

package.loaded.conform = {
	setup = function(value)
		options = value
	end,
}
dofile("lua/plugins/formatting.lua").config()
vim.bo.filetype = "java"
assert(options.format_on_save(0).lsp_format == "fallback")
vim.bo.filetype = "typescript"
assert(options.format_on_save(0).lsp_format == "never")
assert(type(options.formatters_by_ft.typescript) == "function")
print("Java config checks passed")
