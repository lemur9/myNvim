LemurVim.plugins.trans = {
  {
    "JuanZoran/Trans.nvim",
    build = function () require'Trans'.install() end,
    keys = {
      -- 可以换成其他你想映射的键
      { 'mm', mode = { 'n', 'x' }, '<Cmd>Translate<CR>', desc = '󰊿 翻译' },
      { 'mk', mode = { 'n', 'x' }, '<Cmd>TransPlay<CR>', desc = ' 自动朗读' },
      -- 目前这个功能的视窗还没有做好，可以在配置里将view.i改成hover
      { 'mi', '<Cmd>TranslateInput<CR>', desc = '󰊿 输入翻译' },
    },
    dependencies = { 'kkharji/sqlite.lua', },
    opts = {
      -- your configuration there
    }
  }
}
