if lazyvim_docs then
	-- 如果不想使用 `:LazyExtras`，
	-- 则需要设置以下选项。
	vim.g.lazyvim_picker = "fzf"
end

---@class FzfLuaOpts: lazyvim.util.pick.Opts
---@field cmd string?

local M = {}

-- 延迟初始化 picker，避免在 LemurVim 初始化之前访问
local picker_registered = false
function M.ensure_picker_registered()
	if picker_registered then return true end
	
	-- 检查 LemurVim 是否已经初始化
	if _G.LemurVim and LemurVim.pick then
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
		
		if LemurVim.pick.register(picker) then
			picker_registered = true
		end
	end
	
	return picker_registered
end

-- 确保在使用前注册 picker
function M.safe_pick_call(command, opts)
	if not M.ensure_picker_registered() then
		-- 如果注册失败，尝试延迟注册
		vim.defer_fn(function() M.ensure_picker_registered() end, 10)
	end
	
	-- 如果 LemurVim 可用，则使用它
	if _G.LemurVim and LemurVim.pick then
		return LemurVim.pick.open(command, opts)
	else
		-- 否则直接调用 fzf-lua
		return require("fzf-lua")[command](opts)
	end
end

function M.symbols_filter(entry, ctx)
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

return M