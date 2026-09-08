return {
  --disable mini.pairs
  { "nvim-mini/mini.pairs", enabled = false },

  --disable markdownlint (MD013/MD032 fire on every note)
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
}
