-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
if vim.g.nvy then
  vim.o.guifont = "Cousine Nerd Font:h10"
  vim.cmd("cd %:p:h")
end

-- if (vim.g.vscode) then
--   -- VSCode extension
--   require("vim-options-vsc")
-- else
--   require("vim-options")
-- end
