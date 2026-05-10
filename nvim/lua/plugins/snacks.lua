return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>h",
      function()
        Snacks.dashboard.open()
      end,
      desc = "Open Snacks Dashboard",
      mode = "n",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Buffer delete",
      mode = "n",
    },
    {
      "<leader>ba",
      function()
        Snacks.bufdelete.all()
      end,
      desc = "Buffer delete all",
      mode = "n",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Buffer delete other",
      mode = "n",
    },
    {
      "<leader>bz",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
      mode = "n",
    },
  },
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        pick = nil,
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
				        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢾⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⢠⡾⡛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠻⣻⣾⣡⠞⢌⠻⣦⣠⣾⡟⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⣻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⢸⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣿⠁⠀⠀⠑⢌⢻⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠇⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠈⠻⠾⣿⢻⠀⠀⠀⠀⠀⠀⠀⢸⢹⣿⢾⠏⠀⠀⠀⠀⠀⠙⢿⣾⡿⢻⠀⠀⠀⠀⠀⠀⠀⢀⡴⣫⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⠀⠀⠀⢸⢸⣿⠀⠀⠀⠀⠀⠀⠀⣠⡾⢋⠔⠁⠀⠀⠀⠀⠀⢀⡴⣫⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⠀⠀⠀⢸⢸⣿⠀⠀⠀⠀⠀⣠⡾⢋⠔⠁⠀⠀⠀⠀⠀⠀⡴⣫⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⠀⠀⠀⢸⢸⣿⠀⠀⠀⣠⡾⢋⠔⠁⠀⠀⠀⠀⠀⠀⡠⣪⣾⡋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⠀⠀⠀⢸⢸⣿⠀⣠⡾⢋⡔⠁⠀⠀⠀⠀⠀⠀⡠⣪⣾⠟⢌⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⣠⠞⣿⢸⠀⠀⠀⠀⠀⠀⠀⢸⢸⣿⡾⢋⡴⠃⠀⠀⠀⠀⠀⠀⡠⣪⣾⠟⠁⠀⠀⠑⢌⠻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⣠⠞⣡⠞⣿⢸⠀⠀⠀⠀⠀⠀⠀⢸⡸⢋⡴⠋⠀⠀⠀⠀⠀⠀⣠⢞⣿⠟⠁⠀⠀⠀⠀⠀⠀⠑⢌⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⢾⣥⠚⠁⠀⣿⢸⠀⠀⠀⠀⠀⠀⠀⢸⡷⠋⠀⠀⠀⠀⠀⠀⣠⢞⣵⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡱⢨⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠙⢶⡀⠄⣿⢸⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⣠⢞⣵⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠙⢦⣿⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢞⣵⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢊⡴⠋⠀⠀⠀⣠⣤⣤⣤⡀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣵⣿⣥⡀⢀⣀⣤⣤⣤⣤⡀⢀⣠⣤⣮⣴⡋⠀⠀⢀⣀⣀⣻⡟⠉⣹⠇⣀⣠⣤⣤⣄⣀
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⠀⠀⠀⠀⣰⠟⢉⣤⣤⣤⡿⣱⡟⠉⣁⣀⣀⣼⣷⠟⢉⣅⣈⠉⢻⣆⣼⠋⠉⢉⣉⠁⢰⣟⣾⠋⢉⣁⡈⠉⢻
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⠀⠀⢀⣴⡟⠀⠘⠿⢿⣭⢰⡟⠀⣼⠏⠉⠉⣽⠋⢠⡿⢩⡿⠀⣼⣿⠃⢠⡿⣿⠇⢀⣿⣿⠃⠠⠿⠿⠟⠀⣿
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⠀⠀⢀⣴⣿⣿⠻⠶⣦⡄⠀⣿⣿⠀⢰⣏⣀⣠⣺⡏⢀⣾⢁⣾⠃⣰⣿⠇⢠⣿⣱⡟⠀⣼⢻⡏⠀⣶⣶⣶⣶⡾⠃
          ⠀⠀⠀⠀⠀⣿⢸⠀⠀⢀⡴⣫⡾⣿⠛⠛⠛⠛⠀⣰⣿⣧⠀⠈⠛⠉⢹⣿⣇⠈⠛⠛⢁⣴⠟⣿⠀⠀⠉⣹⠁⢰⣏⢸⡇⠀⠉⠉⠉⣽⠇⠀
          ⠀⠀⠀⠀⠀⠙⠷⠿⠿⠿⠾⠋⠀⠛⠛⠛⢿⡿⠛⠋⠀⠙⣻⢿⡿⠟⠛⠁⠙⠛⠛⠛⠛⠁⠀⠙⠛⠛⠛⠛⠛⠻⠟⠈⠛⠛⠛⠛⠛⠋⠀⠀
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⢚⣵⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
				]],
      },
      sections = {
        {
          section = "terminal",
          cmd = "ascii-image-converter ~/.config/nvim/lua/plugins/snacks.webp -Cb --threshold 180 -d 60,24; sleep 0.1",
          height = 24,
          indent = 0,
        },
        -- {
        --   section = "terminal",
        --   cmd = "chafa --format symbols --size 90x25 ~/.config/nvim/lua/plugins/snacks.webp",
        --   height = 25,
        --   indent = 5,
        -- },
        -- { section = "header" },
        {
          pane = 2,
          {
            section = "keys",
            icon = "❯",
            title = "Menu",
            indent = 2,
            padding = 1,
          },
          {
            section = "recent_files",
            icon = " ",
            title = "Recent Files",
            limit = 10,
            indent = 2,
            padding = 1,
          },
          { section = "startup" },
        },
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    rename = { enabled = true },
    zen = {
      enabled = true,
      toggles = {
        ufo = true,
        dim = true,
        git_signs = false,
        diagnostics = false,
        line_number = false,
        relative_number = false,
        signcolumn = "no",
        indent = false,
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    Snacks.toggle.new({
      id = "ufo",
      name = "Enable/Disable ufo",
      get = function()
        return require("ufo").inspect()
      end,
      set = function(state)
        if state == nil then
          require("noice").enable()
          require("ufo").enable()
          vim.o.foldenable = true
          vim.o.foldcolumn = "1"
        else
          require("noice").disable()
          require("ufo").disable()
          vim.o.foldenable = false
          vim.o.foldcolumn = "0"
        end
      end,
    })
  end,
}
