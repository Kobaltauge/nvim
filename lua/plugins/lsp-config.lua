return {
  {
    "williamboman/mason.nvim",
    -- lazy = false,
    config = function()
      require("mason").setup({
        PATH = "prepend", -- "skip" seems to cause the spawning error
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- lazy = false,
    config = function()
      require("mason-lspconfig").setup()
    end,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    -- lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.html.setup({
        capabilities = capabilities
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.harper_ls.setup({
        capabilities = capabilities
      })
      lspconfig.powershell_es.setup({
        bundle_path = 'C:/Users/debiecas/AppData/Local/nvim-data/mason/packages/powershell-editor-services',
        capabilities = capabilities
      })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
