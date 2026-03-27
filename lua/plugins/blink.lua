LemurVim.plugins.blink = {
  {
    "folke/neodev.nvim",
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      snippets = {
        expand = function(snippet, _)
          -- 安全访问 LemurVim.cmp
          if LemurVim and LemurVim.cmp and LemurVim.cmp.expand then
            return LemurVim.cmp.expand(snippet)
          else
            -- fallback to default expand function if available
            local luasnip_status, luasnip = pcall(require, "luasnip")
            if luasnip_status then
              return luasnip.lsp_expand(snippet)
            end
          end
        end,
      },

      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        kind_icons = {},
      },

      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },

      -- experimental signature help support
      -- signature = { enabled = true },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },

      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
    ---@param opts blink.cmp.Config
    config = function(_, opts)
      local function get_kind_icons()
        local lv = rawget(_G, "LemurVim")
        if not lv or not lv.config or not lv.config.icons or not lv.config.icons.kinds then
          return {}
        end
        return lv.config.icons.kinds
      end

      local function get_cmp_map()
        local lv = rawget(_G, "LemurVim")
        if lv and lv.cmp and type(lv.cmp.map) == "function" then
          return lv.cmp.map
        end
        local ok_util_cmp, util_cmp = pcall(require, "util.cmp")
        if ok_util_cmp and util_cmp and type(util_cmp.map) == "function" then
          return util_cmp.map
        end
        return function(_, fallback)
          return function()
            if type(fallback) == "function" then
              return fallback()
            end
            return fallback
          end
        end
      end

      opts = opts or {}
      opts.keymap = opts.keymap or {}
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, get_kind_icons())
      local cmp_map = get_cmp_map()

      -- add ai_accept to <Tab> key
      if not opts.keymap["<Tab>"] then
        if opts.keymap.preset == "super-tab" then -- super-tab
          opts.keymap["<Tab>"] = {
            require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
            cmp_map({ "snippet_forward", "ai_nes", "ai_accept" }),
            "fallback",
          }
        else -- other presets
          opts.keymap["<Tab>"] = {
            cmp_map({ "snippet_forward", "ai_nes", "ai_accept" }),
            "fallback",
          }
        end
      end

      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          local provider_kind = provider.kind
          local transform_items = provider.transform_items
          provider.transform_items = function(ctx, items)
            local resolved_items = items
            if type(transform_items) == "function" then
              resolved_items = transform_items(ctx, items)
            end
            resolved_items = resolved_items or {}

            local kind_icons = get_kind_icons()
            if vim.tbl_isempty(kind_icons) then
              return resolved_items
            end
            for _, item in ipairs(resolved_items) do
              local kind_name = item.kind_name or provider_kind
              if kind_name and kind_icons[kind_name] then
                item.kind_icon = kind_icons[kind_name]
              end
            end
            return resolved_items
          end

          provider.kind = nil
        elseif type(provider.transform_items) ~= "function" then
          provider.transform_items = function(_, items)
            return items or {}
          end
        else
          local transform_items = provider.transform_items
          provider.transform_items = function(ctx, items)
            local resolved_items = transform_items(ctx, items)
            if resolved_items == nil then
              return items or {}
            end
            return resolved_items
          end
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  -- catppuccin support
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}
