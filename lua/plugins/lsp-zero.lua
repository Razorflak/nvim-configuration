return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.tsserver.setup({
                capabilities = capabilities
            })
            lspconfig.html.setup({
                capabilities = capabilities
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })

            lspconfig.eslint.setup({ })

            vim.keymap.set("n", "gd", function()
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, {})
            vim.keymap.set("n", "gdd", function()
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, {})
            vim.keymap.set("n", "gdv", function()
                vim.cmd("vsplit")
                vim.cmd("wincmd l")
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, {})
            --
            -- Remap for lsp actions
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, {})
            vim.keymap.set("n", "<leader>vws", function()
                vim.lsp.buf.workspace_symbol()
            end, {})
            vim.keymap.set("n", "<leader>vd", function()
                vim.diagnostic.open_float()
            end, {})
            vim.keymap.set("n", "<leader>ee", function()
                vim.diagnostic.goto_next()
            end, {})
            vim.keymap.set("n", "<leader>ez", function()
                vim.diagnostic.goto_prev()
            end, {})
            vim.keymap.set("n", "<leader>vca", function()
                vim.lsp.buf.code_action()
            end, {})
            vim.keymap.set("n", "<leader>vrn", function()
                vim.lsp.buf.rename()
            end, {})
            vim.keymap.set("i", "<C-h>", function()
                vim.lsp.buf.signature_help()
            end, {})
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
        end,
    },
}
