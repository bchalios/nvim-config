local rt = require("rust-tools")

local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb") -- note that this will error if you provide a non-existent package name
local dbg_path = codelldb:get_install_path()
local codelldb_path = dbg_path .. "/extension/adapter/codelldb"
local liblldb_path = dbg_path .. "/extension/lldb/lib/liblldb.so"

rt.setup({
  tools = {
    autoSetHints = true,
    inlay_hints = {
      parameter_hints_prefix = "",
    }
  },
  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
  },
  server = {
    on_attach = function(client, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>ha", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      -- Generic setup from config/lsp.lua
      LspCommonAttach(client, bufnr)
    end,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
            command = "clippy",
            allTargets = false,
            extraArgs = {"--target-dir", "/tmp/rust-analyzer-check"},
        },
      },
    },
  },
})
