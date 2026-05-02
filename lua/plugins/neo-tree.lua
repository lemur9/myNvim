LemurVim.plugins["neo-tree"] = {

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          -- 安全访问 LemurVim.root()
          local root_dir = vim.uv.cwd()
          if _G.LemurVim and LemurVim.root then
            pcall(function()
              root_dir = LemurVim.root()
            end)
          end
          require("neo-tree.command").execute({ toggle = true, dir = root_dir })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<C-e>",
        function()
          -- 检查 neo-tree 窗口是否存在
          local win_ids = vim.api.nvim_list_wins()
          for _, win_id in ipairs(win_ids) do
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local buf_name = vim.api.nvim_buf_get_name(buf_id)
            if buf_name:match("neo%-tree") then
              -- 如果当前不在 neo-tree 窗口，则跳转到它
              if vim.api.nvim_get_current_win() ~= win_id then
                vim.api.nvim_set_current_win(win_id)
              else
                -- 如果已经在 neo-tree 窗口，则跳回上一个窗口
                vim.cmd("wincmd p")
              end
              return
            end
          end
          -- 如果 neo-tree 未打开，则打开它
          vim.cmd("Neotree focus")
        end,
        desc = "Toggle focus between editor and NeoTree",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        max_width = 30,
        width = 30,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = true } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        require("snacks").rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })

      -- 当进入 neo-tree 窗口时，如果它是唯一的普通窗口，则自动退出
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        callback = function()
          -- 检查当前缓冲区是否是 neo-tree
          if vim.bo.filetype ~= "neo-tree" then
            return
          end

          local wins = vim.api.nvim_list_wins()
          -- 过滤出非浮动窗口
          local normal_wins = vim.tbl_filter(function(win)
            local config = vim.api.nvim_win_get_config(win)
            return config.relative == ""
          end, wins)

          -- 如果只剩下一个普通窗口（就是当前的 neo-tree），则退出
          if #normal_wins == 1 then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
}
