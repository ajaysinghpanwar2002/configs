require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local telescope = require "telescope"

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

map("n", "<C-e>", "<C-e>", { noremap = true, silent = true })
map("n", "<C-y>", "<C-y>", { noremap = true, silent = true })

map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<C-d>", vim.lsp.buf.definition, { noremap = true, silent = true })

map("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })

map("n", "<Leader>ct", function()
  local copilot_enabled = vim.g.copilot_enabled or false
  if copilot_enabled then
    vim.cmd "Copilot disable"
    vim.g.copilot_enabled = false
    print "Copilot disabled"
  else
    vim.cmd "Copilot enable"
    vim.g.copilot_enabled = true
    print "Copilot enabled"
  end
end, { desc = "Toggle Copilot" })

map("n", "<leader>cc", ":Lazy load CopilotChat.nvim | CopilotChat<CR>", { noremap = true, silent = true })
-- map("n", "<leader>fg", function()
--   require("telescope").extensions.live_grep_args.live_grep_args()
-- end, { desc = "Live Grep with Args" })

-- map("n", "<leader>gr", function()
--   local word = vim.fn.expand("<cword>")
--   vim.cmd("vimgrep /" .. word .. "/gj **/*.*")
--   vim.cmd("copen")
-- end, { desc = "Grep current word in project" })

map("n", "<leader>gr", function()
  local word = vim.fn.expand "<cword>"
  require("telescope").extensions.live_grep_args.live_grep_args { default_text = word }
end, { desc = "Live Grep current word with preview" })

map("n", "<leader>ws", ":WitSearch ", { noremap = true, silent = false, desc = "Wit: Web Search" })
map("n", "<leader>ww", ":WitSearchWiki ", { noremap = true, silent = false, desc = "Wit: Wikipedia Search" })
map("v", "<leader>ws", ":WitSearchVisual<CR>", { noremap = true, silent = false, desc = "Wit: Visual Web Search" })

map("n", "<leader>ge", function()
  local task_file = vim.fn.input("Task file path: ")
  if task_file == "" then
    print("No task file provided!")
    return
  end

  task_file = vim.fn.expand(task_file)

  -- Read and parse JSON file
  local file = io.open(task_file, "r")
  if not file then
    vim.notify("File not found: " .. task_file, vim.log.levels.ERROR)
    return
  end

  local json_content = file:read "*a"
  file:close()

  local ok, data = pcall(vim.json.decode, json_content)
  if not ok then
    vim.notify("Failed to parse JSON file", vim.log.levels.ERROR)
    return
  end

  local env_vars = {}
  for _, container in ipairs(data.containerDefinitions or {}) do
    if container.name == "ecs-recommendation-next" then
      for _, env in ipairs(container.environment or {}) do
        table.insert(env_vars, env.name .. "=" .. (env.value or ""))
      end
      break
    end
  end

  if #env_vars == 0 then
    vim.notify("⚠️ No environment variables found in container definition", vim.log.levels.WARN)
    return
  end

  local output_file = vim.fn.getcwd() .. "/.env"
  local out = io.open(output_file, "w")
  if out then
    out:write(table.concat(env_vars, "\n"))
    out:close()
    vim.notify(".env file generated at: " .. output_file, vim.log.levels.INFO)
  else
    vim.notify("Failed to write .env file", vim.log.levels.ERROR)
  end
end, { desc = "Generate .env from ECS task definition" })
