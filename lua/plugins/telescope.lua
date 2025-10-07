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
      require('telescope').setup({
        defaults = {
          prompt_prefix = ' ',
          selection_caret = ' ',
          layout_stratgy = 'center',
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
              ['<esc>'] = require('telescope.actions').close,
              ['<C-n>'] = require('telescope.actions').move_selection_next,
              ['<C-p>'] = require('telescope.actions').move_selection_previous,
              ['<C-j>'] = require('telescope.actions').cycle_history_next,
              ['<C-k>'] = require('telescope.actions').cycle_history_prev,
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
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('projects')
    end,
  }
}
