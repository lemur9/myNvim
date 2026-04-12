if lazyvim_docs then
	-- In case you don't want to use `:LazyExtras`,
	-- then you need to set the option below.
	vim.g.lazyvim_picker = "fzf"
end

---@class FzfLuaOpts: lazyvim.util.pick.Opts
---@field cmd string?

-- 注册 fzf-lua picker
local function register_picker()
	-- 强制加载 pick 模块
	local pick = LemurVim.pick

	---@type LazyPicker
	local picker = {
		name = "fzf",
		commands = {
			files = "files",
		},

		---@param command string
		---@param opts? FzfLuaOpts
		open = function(command, opts)
			opts = opts or {}
			if opts.cmd == nil and command == "git_files" and opts.show_untracked then
				opts.cmd = "git ls-files --exclude-standard --cached --others"
			end
			return require("fzf-lua")[command](opts)
		end,
	}

	pick.register(picker)
end

local function symbols_filter(entry, ctx)
	if ctx.symbols_filter == nil then
		-- 检查是否可以访问 LemurVim 配置
		local config_available = false
		if _G.LemurVim and package.loaded["core.init"] then
			local config = require("core.init")
			if config and config.get_kind_filter then
				ctx.symbols_filter = config.get_kind_filter(ctx.bufnr) or false
				config_available = true
			end
		end
		
		if not config_available then
			ctx.symbols_filter = false
		end
	end
	if ctx.symbols_filter == false then
		return true
	end
	return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

LemurVim.plugins["fzf-lua"] = {
	desc = "Awesome picker for FZF (alternative to Telescope)",
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		opts = function(_, opts)
			local fzf = require("fzf-lua")
			local config = fzf.config
			local actions = fzf.actions

			-- Quickfix
			config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
			config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
			config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
			config.defaults.keymap.fzf["ctrl-x"] = "jump"
			config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
			config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
			config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
			config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

			-- Trouble
			if pcall(require, "trouble") then
				local trouble_status, trouble_fzf = pcall(require, "trouble.sources.fzf")
				if trouble_status and trouble_fzf and trouble_fzf.actions then
					config.defaults.actions.files["ctrl-t"] = trouble_fzf.actions.open
				end
			end

			-- Toggle root dir / cwd
			config.defaults.actions.files["ctrl-r"] = function(_, ctx)
				local o = vim.deepcopy(ctx.__call_opts)
				o.root = o.root == false
				o.cwd = nil
				o.buf = ctx.__CTX.bufnr
				
				-- 安全访问 LemurVim
				if _G.LemurVim and LemurVim.pick then
					LemurVim.pick.open(ctx.__INFO.cmd, o)
				else
					require("fzf-lua")[ctx.__INFO.cmd](o)
				end
			end
			config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
			config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

			local img_previewer ---@type string[]?
			for _, v in ipairs({
				{ cmd = "ueberzug", args = {} },
				{ cmd = "chafa", args = { "{file}", "--format=symbols" } },
				{ cmd = "viu", args = { "-b" } },
			}) do
				if vim.fn.executable(v.cmd) == 1 then
					img_previewer = vim.list_extend({ v.cmd }, v.args)
					break
				end
			end

			return {
				"default-title",
				fzf_colors = true,
				fzf_opts = {
					["--no-scrollbar"] = true,
				},
				defaults = {
					-- formatter = "path.filename_first",
					formatter = "path.dirname_first",
				},
				previewers = {
					builtin = {
						extensions = {
							["png"] = img_previewer,
							["jpg"] = img_previewer,
							["jpeg"] = img_previewer,
							["gif"] = img_previewer,
							["webp"] = img_previewer,
						},
						ueberzug_scaler = "fit_contain",
					},
				},
				-- Custom LazyVim option to configure vim.ui.select
				ui_select = function(fzf_opts, items)
					return vim.tbl_deep_extend("force", fzf_opts, {
						prompt = " ",
						winopts = {
							title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
							title_pos = "center",
						},
					}, fzf_opts.kind == "codeaction" and {
						winopts = {
							layout = "vertical",
							-- height is number of items minus 15 lines for the preview, with a max of 80% screen height
							height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
							width = 0.5,
							preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
								layout = "vertical",
								vertical = "down:15,border-top",
								hidden = "hidden",
							} or {
								layout = "vertical",
								vertical = "down:15,border-top",
							},
						},
					} or {
						winopts = {
							width = 0.5,
							-- height is number of items, with a max of 80% screen height
							height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
						},
					})
				end,
				winopts = {
					width = 0.8,
					height = 0.8,
					row = 0.5,
					col = 0.5,
					preview = {
						scrollchars = { "┃", "" },
					},
				},
				files = {
					cwd_prompt = false,
					actions = {
						["alt-i"] = { actions.toggle_ignore },
						["alt-h"] = { actions.toggle_hidden },
					},
				},
				grep = {
					actions = {
						["alt-i"] = { actions.toggle_ignore },
						["alt-h"] = { actions.toggle_hidden },
					},
				},
				lsp = {
					symbols = {
						symbol_hl = function(s)
							return "TroubleIcon" .. s
						end,
						symbol_fmt = function(s)
							return s:lower() .. "\t"
						end,
						child_prefix = false,
					},
					code_actions = {
						previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
					},
				},
			}
		end,
		config = function(_, opts)
			if opts[1] == "default-title" then
				-- use the same prompt for all pickers for profile `default-title` and
				-- profiles that use `default-title` as base profile
				local function fix(t)
					t.prompt = t.prompt ~= nil and " " or nil
					for _, v in pairs(t) do
						if type(v) == "table" then
							fix(v)
						end
					end
					return t
				end
				opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
				opts[1] = nil
			end
			require("fzf-lua").setup(opts)
		end,
		init = function()
			-- 注册 picker
			register_picker()

			-- 安全处理延迟加载
			local function setup_ui_select()
				if _G.LemurVim then
					vim.ui.select = function(...)
						require("lazy").load({ plugins = { "fzf-lua" } })
						local opts = (_G.LemurVim and LemurVim.opts and LemurVim.opts("fzf-lua")) or {}
						require("fzf-lua").register_ui_select(opts.ui_select or nil)
						return vim.ui.select(...)
					end
				end
			end

			-- 尝试立即设置或延迟设置
			if _G.LemurVim then
				setup_ui_select()
			else
				vim.defer_fn(setup_ui_select, 50)
			end
		end,
		keys = {
			{ "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
			{ "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
			{
				"<leader>,",
				LemurVim.pick("buffers", { sort_mru=true, sort_lastused=true }),
				desc = "Switch Buffer",
			},
			{ "<leader>/", LemurVim.pick("live_grep"), desc = "Grep (Root Dir)" },
			{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader><space>", LemurVim.pick("files"), desc = "Find Files (Root Dir)" },
			-- find
			{ "<leader>fb", LemurVim.pick("buffers", { sort_mru=true, sort_lastused=true }), desc = "Buffers" },
			{ "<leader>fB", "<cmd>FzfLua buffers<cr>", desc = "Buffers (all)" },
			{ "<leader>fc", LemurVim.pick.config_files, desc = "Find Config File" },
			{ "<leader>ff", LemurVim.pick("files"), desc = "Find Files (Root Dir)" },
			{ "<leader>fF", LemurVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
			{ "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
			{ "<leader>fR", LemurVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
			-- git
			{ "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
			{ "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff (hunks)" },
			{ "<leader>gl", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
			{ "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
			-- search
			{ '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
			{ "<leader>s/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
			{ "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>FzfLua lines<cr>", desc = "Buffer Lines" },
			{ "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
			{ "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
			{ "<leader>sg", LemurVim.pick("live_grep"), desc = "Grep (Root Dir)" },
			{ "<leader>sG", LemurVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
			{ "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>sw", LemurVim.pick("grep_cword"), desc = "Word (Root Dir)" },
			{ "<leader>sW", LemurVim.pick("grep_cword", { root = false }), desc = "Word (cwd)" },
			{ "<leader>sw", LemurVim.pick("grep_visual"), mode = "x", desc = "Selection (Root Dir)" },
			{ "<leader>sW", LemurVim.pick("grep_visual", { root = false }), mode = "x", desc = "Selection (cwd)" },
			{ "<leader>uC", LemurVim.pick("colorschemes"), desc = "Colorscheme with Preview" },
			{
				"<leader>ss",
				function()
					require("fzf-lua").lsp_document_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("fzf-lua").lsp_live_workspace_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
	},

	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		opts = {},
        -- stylua: ignore
        keys = {
          { "<leader>st", function() require("todo-comments.fzf").todo() end, desc = "Todo" },
          { "<leader>sT", function () require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
        },
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
        -- stylua: ignore
        ["*"] = {
          keys = {
            { "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "Goto Definition", has = "definition" },
            { "gr", "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>", desc = "References", nowait = true },
            { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
            { "gy", "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
          }
        },
			},
		},
	},
}
