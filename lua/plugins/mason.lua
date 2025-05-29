return {
	{
		"williamboman/mason.nvim",
		event = "UIEnter",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = true,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"bash-language-server",
					"eslint-lsp",
					"gopls",
					"html-lsp",
					"json-lsp",
					"lua-language-server",
					-- "nextls",
					"prettier",
				},
				auto_update = true,
			})
		end,
	},
}
