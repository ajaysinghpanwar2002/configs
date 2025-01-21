require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<Leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

map('n', '<C-e>', '<C-e>', {noremap = true, silent = true})
map('n', '<C-y>', '<C-y>', {noremap = true, silent = true})


map('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
map('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
map('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
map('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map('n', '<C-d>', vim.lsp.buf.definition, { noremap = true, silent = true })

map("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })

map("n", "<Leader>ct", function()
  local copilot_enabled = vim.g.copilot_enabled or false
  if copilot_enabled then
    vim.cmd("Copilot disable")
    vim.g.copilot_enabled = false
    print("Copilot disabled")
  else
    vim.cmd("Copilot enable")
    vim.g.copilot_enabled = true
    print("Copilot enabled")
  end
end, { desc = "Toggle Copilot" })

map("n", "<leader>cc", ":Lazy load CopilotChat.nvim | CopilotChat<CR>", { noremap = true, silent = true })

