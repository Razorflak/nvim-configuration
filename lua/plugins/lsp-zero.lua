return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },

    },
    config = function()
        local lsp = require("lsp-zero")
        lsp.preset("recommended")
        lsp.ensure_installed({
            "tsserver",
        })
        -- Fix Undefined global 'vim'
        lsp.nvim_workspace()

        lsp.set_sign_icons({
            error = "✘",
            warn = "▲",
            hint = "⚑",
            info = "»",
        })

        lsp.on_attach(function(client, bufnr)
            -- Navbuddy attach
            local navbuddy = require("nvim-navbuddy")
            if client.name ~= "eslint" and client.name ~= "null-ls" then
                navbuddy.attach(client, bufnr)
            end
            --
            -- Remap for goto definition
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gd", function()
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, opts)
            vim.keymap.set("n", "gdd", function()
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, opts)
            vim.keymap.set("n", "gdv", function()
                vim.cmd("vsplit")
                vim.cmd("wincmd l")
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, opts)
            --
            -- Remap for lsp acitons
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, opts)
            vim.keymap.set("n", "<leader>vws", function()
                vim.lsp.buf.workspace_symbol()
            end, opts)
            vim.keymap.set("n", "<leader>vd", function()
                vim.diagnostic.open_float()
            end, opts)
            vim.keymap.set("n", "<leader>ee", function()
                vim.diagnostic.goto_next()
            end, opts)
            vim.keymap.set("n", "<leader>ez", function()
                vim.diagnostic.goto_prev()
            end, opts)
            vim.keymap.set("n", "<leader>vca", function()
                vim.lsp.buf.code_action()
            end, opts)
            vim.keymap.set("n", "<leader>vrn", function()
                vim.lsp.buf.rename()
            end, opts)
            vim.keymap.set("i", "<C-h>", function()
                vim.lsp.buf.signature_help()
            end, opts)
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
        end)

        lsp.setup()

        vim.diagnostic.config({
            virtual_text = true,
        })
    end,
}
