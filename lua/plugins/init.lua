return {
    -- Packer can manage itself
    
    {
	    "kylechui/nvim-surround",
	    version = "*", -- Use for stability; omit to use `main` branch for the latest features
	    event = "VeryLazy",
	    config = function()
		    require("nvim-surround").setup({
			    -- Configuration here, or leave empty to use defaults
		    })
	    end
    },
    {
	    'rose-pine/neovim',
	    as = 'rose-pine',
	    config = function()
		    vim.cmd('colorscheme rose-pine')
	    end
    }, 

    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                icons = false,
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
        },

        "christoomey/vim-tmux-navigator",
        "sindrets/diffview.nvim",
        "nvim-treesitter/playground",
        "theprimeagen/refactoring.nvim",
        "theprimeagen/harpoon",
        "mbbill/undotree",
        "tpope/vim-fugitive",
        "nvim-treesitter/nvim-treesitter-context",
        "dense-analysis/ale",
        
         

        "folke/zen-mode.nvim",
        "eandrju/cellular-automaton.nvim",
        "laytan/cloak.nvim",
    }
