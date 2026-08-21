LemurVim.plugins.dashboard = {
  "nvimdev/dashboard-nvim",
  event = "User " .. LemurVim.colorscheme.event,
  opts = {
    theme = "doom",
    config = {
      -- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=icenvim
      header = {
        " ",
        "██╗     ███████╗███╗   ███╗██╗   ██╗██████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "██║     ██╔════╝████╗ ████║██║   ██║██╔══██╗████╗  ██║██║   ██║██║████╗ ████║",
        "██║     █████╗  ██╔████╔██║██║   ██║██████╔╝██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║     ██╔══╝  ██║╚██╔╝██║██║   ██║██╔══██╗██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        " ",
        string.format("                      %s                       ", LemurVim.version),
        " ",
      },
      -- 注意：doom 主题通过 `lines[i]:find('%w')`（行内是否含 ASCII 字母/数字）
      -- 来反推 center 条目的索引，因此每条 desc 必须至少包含一个 ASCII 字符。
      -- 纯中文/emoji 的 desc 会导致索引错位，触发 "attempt to index a nil value"。
      center = {
        {
          icon = "  ",
          desc = "Lazy 性能分析",
          action = "Lazy profile",
        },
        {
          icon = "  ",
          desc = "编辑配置 (Edit Config)",
          action = string.format("edit ~/.config/nvim/init.lua"),
        },
        {
          icon = "  ",
          desc = "Mason 管理",
          action = "Mason",
        },
        {
          icon = "  ",
          desc = "关于 LemurVim",
          action = "LemurAbout",
        },
      },
      footer = { "🧊 希望你喜欢使用 LemurNvim 😀😀😀" },
    },
  },
  config = function(_, opts)
    -- 防线2：doom 主题通过 `lines[i]:find('%w')` 反推 center 条目索引，
    -- 任何不含 ASCII 字母/数字的 desc 都会导致索引错位并崩溃
    -- （doom.lua:63 "attempt to index a nil value"）。
    -- 这里提前检测，给出明确的警告而不是晦涩的报错。
    for i, item in ipairs(opts.config.center or {}) do
      local text = (item.icon or "") .. (item.desc or "")
      if not text:find("%w") then
        vim.notify(
          string.format(
            "dashboard-nvim: center[%d] (desc=%q) 不含 ASCII 字母/数字，doom 主题会崩溃，请在 desc 中加入英文，如 \"编辑配置 (Edit Config)\"",
            i,
            tostring(item.desc or "")
          ),
          vim.log.levels.WARN
        )
      end
    end

    require("dashboard").setup(opts)

    if vim.api.nvim_buf_get_name(0) == "" then
      vim.cmd("Dashboard")
    end

    -- Use the highlight command to replace instead of overriding the original highlight group
    -- Much more convenient than using vim.api.nvim_set_hl()
    vim.cmd("highlight DashboardFooter cterm=NONE gui=NONE")
  end,
}
