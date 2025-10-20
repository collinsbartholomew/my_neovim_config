-- added-by-agent: csharp-setup 20251020-153000
-- mason: omnisharp
-- manual: dotnet-sdk installation required

local M = {}

-- Function to find OmniSharp binary
local function get_omnisharp_cmd()
  -- Check OMNISHARP_PATH environment variable first
  local omnisharp_path = os.getenv("OMNISHARP_PATH")
  if omnisharp_path and vim.fn.executable(omnisharp_path) == 1 then
    return { omnisharp_path, "-lsp" }
  end

  -- Check for Mason installed OmniSharp
  local mason_registry = package.loaded["mason-registry"]
  if mason_registry and mason_registry.is_installed("omnisharp") then
    local omnisharp_pkg = mason_registry.get_package("omnisharp")
    local install_path = omnisharp_pkg:get_install_path()
    
    -- Different paths based on OS and OmniSharp distribution
    local possible_paths = {
      install_path .. "/OmniSharp.exe",           -- Windows
      install_path .. "/omnisharp/OmniSharp.exe", -- Linux/OmniSharp-mono
      install_path .. "/OmniSharp",               -- Linux/OmniSharp-Roslyn
      install_path .. "/bin/omnisharp",           -- Potential future path
    }
    
    for _, path in ipairs(possible_paths) do
      if vim.fn.executable(path) == 1 then
        -- For OmniSharp.exe, we might need to use mono
        if path:match("%.exe$") then
          if vim.fn.executable("mono") == 1 then
            return { "mono", path, "-lsp" }
          end
        else
          return { path, "-lsp" }
        end
      end
    end
  end

  -- Check system OmniSharp
  if vim.fn.executable("omnisharp") == 1 then
    return { "omnisharp", "-lsp" }
  end

  -- Fallback - notify user
  vim.notify(
    "OmniSharp not found. Please install OmniSharp via Mason or set OMNISHARP_PATH.",
    vim.log.levels.WARN
  )
  
  return nil
end

function M.setup(config)
  config = config or {}
  
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then
    vim.notify("lspconfig not available for C# setup", vim.log.levels.ERROR)
    return
  end

  local cmd = get_omnisharp_cmd()
  if not cmd then
    return
  end

  -- Override cmd if provided in config
  if config.cmd then
    cmd = config.cmd
  end

  lspconfig.omnisharp.setup({
    cmd = cmd,
    root_dir = lspconfig.util.root_pattern(".sln", ".csproj", "global.json", ".git"),
    on_attach = function(client, bufnr)
      -- Standard LSP keymaps
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local opts = { noremap=true, silent=true }
      
      buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      
      -- Enable inlay hints if available
      pcall(function()
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint(bufnr, true)
        end
      end)
    end,
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      MsBuild = {
        LoadProjectsOnDemand = true,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        AnalyzersSupport = true,
      },
    },
  })
end

return M