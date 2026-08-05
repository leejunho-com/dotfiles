return {
  -- nil_ls installed via Nix (mason build needs cargo)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = { mason = false },
      },
    },
  },
}
