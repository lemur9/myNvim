LemurVim.plugins.bufferline = {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
      -- calling `setup` is optional for customization
      require("bufferline").setup{
        options = {
          indicator = {
            icon = '▎', -- 分割线
            style = 'underline',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',

          -- 左侧让出 neo-tree 的位置
          offsets = {{
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              separator = false,
            },
          }
        }
      }
    end
  }
}

