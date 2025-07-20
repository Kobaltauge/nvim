if vim.g.nvy then
  vim.o.guifont = "Cousine Nerd Font:h10"
  vim.cmd("cd %:p:h")
end

if vim.fn.has("unix") == 1 and string.match(vim.fn.system("uname"), "Linux") then
  vim.o.shell = "/bin/bash"
end

if (vim.g.vscode) then
  -- VSCode extension
  require("config.vim-options-vsc")
else
  require("config.vim-options")
end


