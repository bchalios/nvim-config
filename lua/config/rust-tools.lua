local rt = require("rust-tools")

rt.setup({
  tools = {
    autoSetHints = true,
    inlay_hints = {
      parameter_hints_prefix = "",
    }
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
