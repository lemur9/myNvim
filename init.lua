_G.LemurVim = require("util")

require("core")
require("plugins")

if not LemurVim.noplugin() then
  require("lazy").setup(vim.tbl_values(LemurVim.plugins), LemurVim.lazy)
end
-- 调试
function LemurVim.dump()
	print(vim.inspect(LemurVim))
end
