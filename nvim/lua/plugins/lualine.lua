return {
  'nvim-lualine/lualine.nvim', config = function()

    local mode = {
      'mode', fmt = function(str) 
        return ' ' .. str
        -- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
      end,
      separator = { left = ' ', right = '' },
    }

    local filename = {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 2, -- 0 = just filename, 1 = relative path, 2 = absolute path
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100 end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = false, update_in_insert = false, always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = false,
      symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
      cond = hide_in_width,
    }
    
    local colors = {
      black   = '#000000',
      maroon  = '#800000',
      green   = '#008000',
      olive   = '#808000',
      navy    = '#000080',
      purple  = '#800080',
      teal    = '#008080',
      silver  = '#c0c0c0',
      gray    = '#808080',
      red     = '#ff0000',
      lime    = '#00ff00',
      yellow  = '#ffff00',
      blue    = '#0000ff',
      fuchsia = '#ff00ff',
      aqua    = '#00ffff',
      white   = '#ffffff',
    }

    local lualine_theme = {
      normal = {
        a = { fg = colors.white, bg = '#F37021', gui = 'bold' },
        b = { fg = colors.white, bg = 'NONE' },
        c = { fg = colors.silver, bg = 'NONE' },
        x = { fg = colors.silver, bg = 'NONE' },
        y = { fg = colors.silver, bg = 'NONE' },
        z = { fg = colors.white, bg = 'NONE' },
      },
      insert = { 
        a = { fg = colors.white, bg = colors.green, gui = 'bold' },
        b = { fg = colors.white, bg = 'NONE' },
        c = { fg = colors.silver, bg = 'NONE' },
        x = { fg = colors.silver, bg = 'NONE' },
        y = { fg = colors.silver, bg = 'NONE' },
        z = { fg = colors.white, bg = 'NONE' },
      },
      visual = { 
        a = { fg = colors.white, bg = colors.purple, gui = 'bold' },
        b = { fg = colors.white, bg = 'NONE' },
        c = { fg = colors.silver, bg = 'NONE' },
        x = { fg = colors.silver, bg = 'NONE' },
        y = { fg = colors.silver, bg = 'NONE' },
        z = { fg = colors.white, bg = 'NONE' },
      },
      replace = { 
        a = { fg = colors.white, bg = colors.red, gui = 'bold' },
        b = { fg = colors.white, bg = 'NONE' },
        c = { fg = colors.silver, bg = 'NONE' },
        x = { fg = colors.silver, bg = 'NONE' },
        y = { fg = colors.silver, bg = 'NONE' },
        z = { fg = colors.white, bg = 'NONE' },
      },
      inactive = {
        a = { fg = colors.silver, bg = colors.gray, gui = 'bold' },
        b = { fg = colors.gray, bg = colors.black },
        c = { fg = colors.silver, bg = colors.black },
      },
    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = lualine_theme, -- Set theme based on environment variable
        -- Some useful glyphs:
        -- https://www.nerdfonts.com/cheat-sheet
        --        
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { 'alpha', 'neo-tree' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { {'branch', padding = 2 } },
        lualine_c = { filename },
        lualine_x = { diagnostics, diff, { 'encoding', cond = hide_in_width }, { 'filetype', cond = hide_in_width } },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { { 'location', padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { 'fugitive' },
    }
  end,
}
