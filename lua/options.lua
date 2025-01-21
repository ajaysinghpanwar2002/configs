require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--

local opt = vim.opt

-- Enable folding based on Tree-sitter
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Open all folds by default when opening a file
vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"}, {
  pattern = "*",
  command = "normal! zR"
})

