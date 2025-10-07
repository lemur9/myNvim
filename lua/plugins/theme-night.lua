-- 文件树插件
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
        vim.cmd.colorscheme("tokyonight-night")
    end
  }
}

