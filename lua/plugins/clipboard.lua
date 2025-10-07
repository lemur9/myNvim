return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ahmedkhalf/project.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values

      telescope.setup({
        defaults = {
          prompt_prefix = ' ',
          selection_caret = ' ',
          layout_strategy = 'center',
          layout_config = {
            width = 0.8,
            height = 0.7,
          },
          file_ignore_patterns = {
            'node_modules',
            '.git/*',
            '%.zip',
            '%.exe',
            '%.dll',
          },
          mappings = {
            i = {
              ['<C-c>'] = false,
              ['<esc>'] = actions.close,
              ['<C-n>'] = actions.move_selection_next,
              ['<C-p>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.cycle_history_next,
              ['<C-k>'] = actions.cycle_history_prev,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--hidden' },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('projects')

      --------------------------------------------------------------------
      -- 📋 自定义寄存器查看器（带预览 + 搜索 + 系统剪贴板模式）
      --------------------------------------------------------------------
      local function registers_with_preview(opts, only_clipboard)
        opts = opts or {}
        local registers = vim.fn.getreginfo()
        local results = {}

        for reg, info in pairs(registers) do
          if not only_clipboard or (reg == "+" or reg == "*") then
            local content = table.concat(info.regcontents, "\n")
            table.insert(results, { reg, content })
          end
        end

        pickers.new(opts, {
          prompt_title = only_clipboard and "Clipboard Registers" or "Registers",
          finder = finders.new_table {
            results = results,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry[1] .. "   " .. entry[2]:gsub("\n", " "),
                ordinal = entry[1] .. " " .. entry[2], -- 支持模糊搜索
              }
            end
          },
          sorter = conf.generic_sorter(opts),
          previewer = require("telescope.previewers").new_buffer_previewer {
            define_preview = function(self, entry)
              local lines = {}
              for s in string.gmatch(entry.value[2], "([^\n]*)") do
                table.insert(lines, s)
              end
              table.insert(lines, "")
              table.insert(lines, string.format("[寄存器: %s] 内容长度: %d", entry.value[1], #entry.value[2]))
              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            end,
          },
          attach_mappings = function(_, map)
            local function paste_selection(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.api.nvim_put(vim.fn.getreg(selection.value[1], 1, 1), "l", true, true)
            end
            map("i", "<CR>", paste_selection)
            map("n", "<CR>", paste_selection)
            return true
          end,
        }):find()
      end

      -- Ctrl+R 打开所有寄存器
      vim.keymap.set("n", "<C-a>", function()
        registers_with_preview({}, false)
      end, { noremap = true, silent = true, desc = "显示所有寄存器" })

      -- Ctrl+Shift+R 打开系统剪贴板寄存器
      vim.keymap.set("n", "<C-S-a>", function()
        registers_with_preview({}, true)
      end, { noremap = true, silent = true, desc = "显示系统剪贴板寄存器" })
    end,
  }
}

