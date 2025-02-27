return {
	{
		"neovim/nvim-lspconfig",
		event = "BufAdd",
		dependencies = {
			-- "jose-elias-alvarez/null-ls.nvim",
			"glepnir/lspsaga.nvim",
			-- "stevearc/conform.nvim",
			"windwp/nvim-autopairs",
		},
		config = function()
			-- local popup = require("nikp.utils.popup")
			local nvim_lsp = require("lspconfig")
			-- local on_attach = require("nikp.keymaps.lsp").on_attach
			-- local diagnostic_config = require("nikp.keymaps.lsp").diagnostic_config
			-- local map = require("nikp.keymaps.utils").map
			-- require("notifier").setup()
			-- require("lint")

			-- Common UI settings related to LSP

			require("lspsaga").setup({
				symbol_in_winbar = {
					enable = false,
				},
			})
			-- LSP Diagnostics Options Setup
			local sign = function(opts)
				vim.fn.sign_define(opts.name, {
					texthl = opts.name,
					text = opts.text,
					numhl = "",
				})
			end

			sign({ name = "DiagnosticSignError", text = "" })
			sign({ name = "DiagnosticSignWarn", text = "" })
			sign({ name = "DiagnosticSignHint", text = "" })
			sign({ name = "DiagnosticSignInfo", text = "" })

			vim.diagnostic.config(diagnostic_config)

			-- Fixed column for diagnostics to appear
			-- Show autodiagnostic popup on cursor hover_range
			vim.cmd([[
        autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
      ]])

			-- Common flags
			local lsp_flags = {
				debounce_text_changes = 50,
			}

			-- set up completion capabilities using nvim_cmp with LSP source
			-- local capabilities =
			--     require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			-- capabilities.textDocument.completion.completionItem.snippetSupport = true
			-- local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- PER LANGUAGE SETUPS

			-- C and Variants
			nvim_lsp.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				lsp_flags = lsp_flags,
			})

			-- THIS FIXES THE ORDER OF TYPESCRIPT DIAGNOSTIC LINES
			-- PUT THE MOST RELEVANT INFO FIRST
			--- @param err lsp.ResponseError
			--- @param result lsp.PublishDiagnosticsParams
			--- @param ctx lsp.HandlerContext
			local function diagnostics_handler(err, result, ctx)
				if err ~= nil then
					error("Failed to request diagnostics: " .. vim.inspect(err))
				end

				if result == nil then
					return
				end

				local buffer = vim.uri_to_bufnr(result.uri)
				local namespace = vim.lsp.diagnostic.get_namespace(ctx.client_id)

				local diagnostics = vim.tbl_map(function(diagnostic)
					local resultLines = vim.split(diagnostic.message, "\n")
					local output = vim.fn.reverse(resultLines)
					return {
						bufnr = buffer,
						lnum = diagnostic.range.start.line,
						end_lnum = diagnostic.range["end"].line,
						col = diagnostic.range.start.character,
						end_col = diagnostic.range["end"].character,
						severity = diagnostic.severity,
						message = table.concat(output, "\n\n"),
						source = diagnostic.source,
						code = diagnostic.code,
					}
				end, result.diagnostics)

				vim.diagnostic.set(namespace, buffer, diagnostics)
			end

			-- HTML
			nvim_lsp.html.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- CSS
			nvim_lsp.cssls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- ESLINT
			nvim_lsp.eslint.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- JSON
			nvim_lsp.jsonls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- GOLANG
			local util = require("lspconfig/util")
			nvim_lsp.gopls.setup({
				cmd = { "gopls", "serve" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					map("n", "<leader>ru", function()
						popup.output_command(":!go run .")
					end)
				end,
			})

			-- LUA
			nvim_lsp.lua_ls.setup({
				commands = {
					Format = {
						function()
							vim.lsp.buf.format()
						end,
					},
				},
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
			})

			-- BASH
			nvim_lsp.bashls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "sh", "*.bashrc", "shell", "tmux" },
				{
					bashIde = {
						globPattern = "*@(.sh|.inc|.bash|.command)",
					},
				},
			})

			--Set completeopt to have a better completion experience
			-- :help completeopt
			-- menuone: popup even when there's only one match
			-- noinsert: Do not insert text until a selection is made
			-- noselect: Do not select, force to select one from the menu
			-- shortness: avoid showing extra messages when using completion
			-- updatetime: set updatetime for CursorHold
			vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
			vim.opt.shortmess = vim.opt.shortmess + { c = true }
			vim.api.nvim_set_option("updatetime", 300)
		end,
	},
}
