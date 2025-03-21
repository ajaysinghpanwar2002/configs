-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "ts_ls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Configure diagnostic display to hide warnings
vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.ERROR }
  },
  signs = {
    severity = { min = vim.diagnostic.severity.ERROR }
  },
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR }
  },
  float = {
    severity = { min = vim.diagnostic.severity.ERROR }
  }
})

local on_attach = function(client, bufnr)
  -- Enable formatting capability but skip for Python files
  if client.server_capabilities.documentFormattingProvider then
    local ft = vim.bo[bufnr].filetype
    if ft ~= "python" then  -- Skip autoformatting for Python
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { async = false }
          vim.lsp.buf.code_action { only = { "source.organizeImports" } }
        end,
      })
    end
  end
end

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = nvlsp.capabilities,
  on_init = nvlsp.on_init,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        -- fieldalignment = true,
      },
    },
  },
}

lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  on_init = nvlsp.on_init,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
  settings = {
    javascript = {
      format = { enable = true },
    },
    typescript = {
      format = { enable = true },
    },
  },
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = nvlsp.capabilities,
  on_init = nvlsp.on_init,
  filetypes = { "python" },
  root_dir = lspconfig.util.root_pattern(".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt"),
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportGeneralTypeIssues = "error",          -- Only show errors, not warnings
          reportOptionalMemberAccess = "none",        -- Disable optional member access warnings
          reportOptionalSubscript = "none",           -- Disable optional subscript warnings
          reportOptionalCall = "none",                -- Disable optional call warnings
          reportOptionalIterable = "none",            -- Disable optional iterable warnings
          reportOptionalContextManager = "none",      -- Disable optional context manager warnings
          reportOptionalOperand = "none",             -- Disable optional operand warnings
          reportUnusedImport = "none",                -- Disable unused import warnings
          reportUnusedClass = "none",                 -- Disable unused class warnings
          reportUnusedFunction = "none",              -- Disable unused function warnings
          reportUnusedVariable = "none",              -- Disable unused variable warnings
          reportDuplicateImport = "none",             -- Disable duplicate import warnings
          reportWildcardImportFromLibrary = "none",   -- Disable wildcard import warnings
          reportPrivateUsage = "none",                -- Disable private usage warnings
          reportConstantRedefinition = "none",        -- Disable constant redefinition warnings
          reportIncompatibleMethodOverride = "error", -- Keep method override errors
          reportMissingImports = "error",             -- Keep missing import errors
          reportUndefinedVariable = "error",          -- Keep undefined variable errors
        }
      },
    },
  },
}

-- Update pylsp with disabled linters/warnings
lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },      -- Disable style checking
        pyflakes = { enabled = false },         -- Disable pyflakes warnings
        pylint = { enabled = false },           -- Disable pylint 
        pyls_isort = { enabled = true },        -- Keep import sorting
        pylsp_mypy = { 
          enabled = true,
          report_progress = true,
          live_mode = false,
          dmypy = false,
          strict = false
        },
        pylsp_black = { enabled = true },       -- Keep black formatting
        pylsp_rope = { enabled = true },        -- Keep rope refactoring
      },
    },
  },
}

lspconfig.kotlin_language_server.setup {
  on_attach = on_attach,
  capabilities = nvlsp.capabilities,
  on_init = nvlsp.on_init,
  cmd = { "kotlin-language-server" },
  filetypes = { "kotlin" },
  root_dir = lspconfig.util.root_pattern("settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git"),
  settings = {
    kotlin = {
      compiler = {
        jvm = {
          target = "1.8"
        }
      }
    }
  }
}

