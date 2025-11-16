_G.LemurVim = require("util")

require("core")
require("plugins")

require("lazy").setup(vim.tbl_values(LemurVim.plugins), LemurVim.lazy)

-- 调试
function LemurVim.dump()
	print(vim.inspect(LemurVim))
end
