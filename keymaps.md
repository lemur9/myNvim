# Neovim 快捷键大全

本文档列出了当前 Neovim 配置中的所有快捷键，包括自定义快捷键、各插件定义的快捷键以及 Neovim 默认快捷键。

## 自定义快捷键 (lua/core/keymaps.lua)

这些快捷键在核心键位映射文件中定义。

### 插入模式
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `jk` | i | 退出插入模式 | 自定义 |

### 视觉模式
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `J` | v | 向下移动选中行 | 自定义 |
| `K` | v | 向上移动选中行 | 自定义 |

### 正常模式
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `<leader>sv` | n | 垂直分割窗口 (`<C-w>v`) | 自定义 |
| `<leader>sh` | n | 水平分割窗口 (`<C-w>s`) | 自定义 |
| `<C-s>` | n | 保存文件 (`:w`) | 自定义 |
| `<C-k>` | n, v | 向上移动5行 | 自定义 |
| `<C-j>` | n, v | 向下移动5行 | 自定义 |
| `<C-z>` | n, i | 撤销 (`undo`) | 自定义 |
| `<leader>nh` | n | 取消搜索高亮 (`:nohl`) | 自定义 |

### 插件快捷键 (在 keymaps.lua 中定义)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `<A-Left>` | n | 切换到上一个缓冲区 (BufferLineCyclePrev) | bufferline |
| `<A-Right>` | n | 切换到下一个缓冲区 (BufferLineCycleNext) | bufferline |
| `<leader>lt` | n | 切换 Live Server (LiveServerToggle) | live-server-nvim |

### LSP 快捷键 (通过 LspAttach 自动命令设置)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `K` | n | 查看文档 (hover) | nvim-lspconfig |
| `<space>gd` | n | 跳转到定义 | nvim-lspconfig |
| `<space>gD` | n | 跳转到声明 | nvim-lspconfig |
| `<space>rn` | n | 重命名符号 | nvim-lspconfig |
| `<space>ca` | n, v | 代码操作 | nvim-lspconfig |

## 插件快捷键

### fzf-lua (lua/plugins/fzf.lua)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `<c-j>` | t | 在 fzf 终端中向下移动 | fzf-lua |
| `<c-k>` | t | 在 fzf 终端中向上移动 | fzf-lua |
| `<leader>,` | n | 切换缓冲区 (最近使用排序) | fzf-lua |
| `<leader>/` | n | Grep (根目录) | fzf-lua |
| `<leader>:` | n | 命令历史 | fzf-lua |
| `<leader><space>` | n | 查找文件 (根目录) | fzf-lua |
| `<leader>fb` | n | 缓冲区 (最近使用排序) | fzf-lua |
| `<leader>fB` | n | 缓冲区 (全部) | fzf-lua |
| `<leader>fc` | n | 查找配置文件 | fzf-lua |
| `<leader>ff` | n | 查找文件 (根目录) | fzf-lua |
| `<leader>fF` | n | 查找文件 (当前工作目录) | fzf-lua |
| `<leader>fg` | n | 查找文件 (git-files) | fzf-lua |
| `<leader>fr` | n | 最近文件 | fzf-lua |
| `<leader>fR` | n | 最近文件 (当前工作目录) | fzf-lua |
| `<leader>gc` | n | Git 提交 | fzf-lua |
| `<leader>gd` | n | Git 差异 (hunks) | fzf-lua |
| `<leader>gl` | n | Git 提交 | fzf-lua |
| `<leader>gs` | n | Git 状态 | fzf-lua |
| `<leader>gS` | n | Git 储藏 | fzf-lua |
| `<leader>s"` | n | 寄存器 | fzf-lua |
| `<leader>s/` | n | 搜索历史 | fzf-lua |
| `<leader>sa` | n | 自动命令 | fzf-lua |
| `<leader>sb` | n | 缓冲区行 | fzf-lua |
| `<leader>sc` | n | 命令历史 | fzf-lua |
| `<leader>sC` | n | 命令 | fzf-lua |
| `<leader>sd` | n | 工作区诊断 | fzf-lua |
| `<leader>sD` | n | 缓冲区诊断 | fzf-lua |
| `<leader>sg` | n | Grep (根目录) | fzf-lua |
| `<leader>sG` | n | Grep (当前工作目录) | fzf-lua |
| `<leader>sh` | n | 帮助页面 | fzf-lua |
| `<leader>sH` | n | 搜索高亮组 | fzf-lua |
| `<leader>sj` | n | 跳转列表 | fzf-lua |
| `<leader>sk` | n | 键位映射 | fzf-lua |
| `<leader>sl` | n | 位置列表 | fzf-lua |
| `<leader>sM` | n | 手册页 | fzf-lua |
| `<leader>sm` | n | 标记 | fzf-lua |
| `<leader>sR` | n | 恢复上次搜索 | fzf-lua |
| `<leader>sq` | n | 快速修复列表 | fzf-lua |
| `<leader>sw` | n | 搜索当前单词 (根目录) | fzf-lua |
| `<leader>sW` | n | 搜索当前单词 (当前工作目录) | fzf-lua |
| `<leader>sw` | x | 搜索视觉选择 (根目录) | fzf-lua |
| `<leader>sW` | x | 搜索视觉选择 (当前工作目录) | fzf-lua |
| `<leader>uC` | n | 配色方案预览 | fzf-lua |
| `<leader>ss` | n | 跳转到符号 (文档) | fzf-lua |
| `<leader>sS` | n | 跳转到符号 (工作区) | fzf-lua |

**注意**: fzf-lua 还定义了以下 LSP 快捷键 (覆盖默认映射):
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `gd` | n | 跳转到定义 (使用 fzf-lua) | fzf-lua |
| `gr` | n | 引用 (使用 fzf-lua) | fzf-lua |
| `gI` | n | 跳转到实现 (使用 fzf-lua) | fzf-lua |
| `gy` | n | 跳转到类型定义 (使用 fzf-lua) | fzf-lua |

**fzf 内部键位映射** (在 fzf 界面中使用):
- `ctrl-q`: 选择全部并接受
- `ctrl-u`: 上半页
- `ctrl-d`: 下半页
- `ctrl-x`: 跳转
- `ctrl-f`: 预览页向下
- `ctrl-b`: 预览页向上
- `ctrl-t`: 在 trouble 中打开 (如果安装)

### neo-tree (lua/plugins/neo-tree.lua)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `<leader>fe` | n | 文件资源管理器 (根目录) | neo-tree |
| `<leader>fE` | n | 文件资源管理器 (当前工作目录) | neo-tree |
| `<leader>e` | n | 同 `<leader>fe` (重映射) | neo-tree |
| `<leader>E` | n | 同 `<leader>fE` (重映射) | neo-tree |
| `<leader>ge` | n | Git 资源管理器 | neo-tree |
| `<leader>be` | n | 缓冲区资源管理器 | neo-tree |
| `<leader>ee` | n | 跳转到树 (文件系统) | neo-tree |

**neo-tree 窗口内映射** (当 neo-tree 窗口激活时):
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `l` | n | 打开节点 | neo-tree |
| `h` | n | 关闭节点 | neo-tree |
| `<space>` | n | 无操作 (禁用) | neo-tree |
| `Y` | n | 复制路径到剪贴板 | neo-tree |
| `O` | n | 用系统应用程序打开 | neo-tree |
| `P` | n | 切换预览 | neo-tree |

### blink.cmp (lua/plugins/blink.lua)
补全框架快捷键 (在补全菜单出现时有效):

| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `<C-y>` | i | 选择并接受 | blink.cmp |
| `<Tab>` | i | 片段前进 / AI 接受 / 回退 | blink.cmp |
| `<CR>` (回车) | i | 确认选择 (根据预设) | blink.cmp |

**注意**: blink.cmp 使用 `preset = "enter"` 配置，具体行为请参考插件文档。

### Trans.nvim (lua/plugins/trans.lua)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `mm` | n, x | 翻译 | Trans.nvim |
| `mk` | n, x | 自动播放 | Trans.nvim |
| `mi` | n | 从输入翻译 | Trans.nvim |

### markdown-preview.nvim (lua/plugins/markdown.lua)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `<leader>mk` | n | 切换 Markdown 预览 | markdown-preview.nvim |

### snacks.nvim (lua/plugins/snacks.lua)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `<leader>ca` | n | 代码操作 | snacks.nvim |
| `<leader>nf` | n | 查找文件 | snacks.nvim |
| `<leader>nh` | n | 通知历史 | snacks.nvim |

### gitsigns.nvim (lua/plugins/gitsigns.lua)
| 按键 | 模式 | 描述 | 插件 |
|------|------|------|------|
| `]h` | n | 下一个变更块 | gitsigns.nvim |
| `[h` | n | 上一个变更块 | gitsigns.nvim |
| `]H` | n | 最后一个变更块 | gitsigns.nvim |
| `[H` | n | 第一个变更块 | gitsigns.nvim |
| `<leader>ghs` | n, v | 暂存当前块 | gitsigns.nvim |
| `<leader>ghr` | n, v | 重置当前块 | gitsigns.nvim |
| `<leader>ghS` | n | 暂存整个缓冲区 | gitsigns.nvim |
| `<leader>ghu` | n | 撤销暂存块 | gitsigns.nvim |
| `<leader>ghR` | n | 重置整个缓冲区 | gitsigns.nvim |
| `<leader>ghp` | n | 行内预览块 | gitsigns.nvim |
| `<leader>ghb` | n | 显示当前行作者信息 | gitsigns.nvim |
| `<leader>ghB` | n | 显示缓冲区作者信息 | gitsigns.nvim |
| `<leader>ghd` | n | 与索引比较 | gitsigns.nvim |
| `<leader>ghD` | n | 与上一个提交比较 | gitsigns.nvim |
| `ih` | o, x | 选择变更块 | gitsigns.nvim |

## Neovim 默认快捷键

以下是一些常用的 Neovim 默认快捷键，这些快捷键没有在配置中显式定义，但始终可用。

### 移动
| 按键 | 模式 | 描述 |
|------|------|------|
| `h` | n, v | 左移 |
| `j` | n, v | 下移 |
| `k` | n, v | 上移 |
| `l` | n, v | 右移 |
| `w` | n, v | 跳到下一个单词开头 |
| `b` | n, v | 跳到上一个单词开头 |
| `e` | n, v | 跳到单词末尾 |
| `0` | n, v | 跳到行首 |
| `^` | n, v | 跳到行第一个非空字符 |
| `$` | n, v | 跳到行尾 |
| `gg` | n, v | 跳到文件开头 |
| `G` | n, v | 跳到文件末尾 |
| `Ctrl-d` | n, v | 向下滚动半页 |
| `Ctrl-u` | n, v | 向上滚动半页 |
| `Ctrl-f` | n, v | 向下翻页 |
| `Ctrl-b` | n, v | 向上翻页 |
| `%` | n, v | 跳转到匹配的括号 |

### 编辑
| 按键 | 模式 | 描述 |
|------|------|------|
| `i` | n | 进入插入模式 (光标前) |
| `a` | n | 进入插入模式 (光标后) |
| `I` | n | 进入插入模式 (行首) |
| `A` | n | 进入插入模式 (行尾) |
| `o` | n | 在下方新行插入 |
| `O` | n | 在上方新行插入 |
| `x` | n | 删除当前字符 |
| `dd` | n | 删除当前行 |
| `yy` | n | 复制当前行 |
| `p` | n | 在光标后粘贴 |
| `P` | n | 在光标前粘贴 |
| `u` | n | 撤销 |
| `Ctrl-r` | n | 重做 |
| `.` | n | 重复上次编辑 |

### 选择
| 按键 | 模式 | 描述 |
|------|------|------|
| `v` | n | 进入字符可视模式 |
| `V` | n | 进入行可视模式 |
| `Ctrl-v` | n | 进入块可视模式 |

### 搜索和替换
| 按键 | 模式 | 描述 |
|------|------|------|
| `/` | n | 向前搜索 |
| `?` | n | 向后搜索 |
| `n` | n | 下一个匹配 |
| `N` | n | 上一个匹配 |
| `*` | n | 搜索当前单词 (向前) |
| `#` | n | 搜索当前单词 (向后) |
| `:%s/old/new/g` | n | 全局替换 |

### 窗口管理
| 按键 | 模式 | 描述 |
|------|------|------|
| `Ctrl-w h` | n | 切换到左边窗口 |
| `Ctrl-w j` | n | 切换到下边窗口 |
| `Ctrl-w k` | n | 切换到上边窗口 |
| `Ctrl-w l` | n | 切换到右边窗口 |
| `Ctrl-w s` | n | 水平分割窗口 |
| `Ctrl-w v` | n | 垂直分割窗口 |
| `Ctrl-w c` | n | 关闭当前窗口 |
| `Ctrl-w =` | n | 均衡窗口大小 |
| `Ctrl-w _` | n | 最大化窗口高度 |
| `Ctrl-w |` | n | 最大化窗口宽度 |
| `Ctrl-w r` | n | 旋转窗口 |
| `Ctrl-w x` | n | 交换窗口 |

### 标签页
| 按键 | 模式 | 描述 |
|------|------|------|
| `:tabnew` | n | 新建标签页 |
| `gt` | n | 下一个标签页 |
| `gT` | n | 上一个标签页 |
| `{i}gt` | n | 切换到第 i 个标签页 |

### 插入模式
| 按键 | 模式 | 描述 |
|------|------|------|
| `Ctrl-w` | i | 删除前一个单词 |
| `Ctrl-u` | i | 删除到行首 |
| `Ctrl-h` | i | 退格 |
| `Ctrl-t` | i | 增加缩进 |
| `Ctrl-d` | i | 减少缩进 |
| `Ctrl-o` | i | 执行一个正常模式命令后返回插入模式 |

### 命令行
| 按键 | 模式 | 描述 |
|------|------|------|
| `:` | n | 进入命令行模式 |
| `q:` | n | 打开命令历史窗口 |
| `Ctrl-f` | c | 在命令行中打开命令历史窗口 |

## 总结

此文档涵盖了当前 Neovim 配置中的大多数快捷键。如需更详细的信息，请参考各插件的官方文档。

**注意**: 某些插件的快捷键可能会冲突，实际行为以运行时为准。可以使用 `:map` 命令查看当前所有映射。

**最后更新**: 2026-04-09