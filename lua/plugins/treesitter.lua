return {
            -- Highlight, edit, and navigate code
            'nvim-treesitter/nvim-treesitter',
            dependencies = {
                'nvim-treesitter/nvim-treesitter-textobjects',
            },
            build = ':TSUpdate'
            config = function()
                local config = require("nvim-treesitter.configs")
                config.setup({
                    ensure_installed = {"lua", "python", "go"},
                    highlight = {enable = true },
                    indent = { enable = true },
                })
                end
                
        }
