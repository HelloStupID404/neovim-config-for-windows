-- Perfection Is A Trap.
------------
-- options
------------
-- 行号
vim.opt.number = true
vim.opt.relativenumber = false
-- 缩进
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
-- 文本显示
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 80
-- 光标行高亮
vim.opt.cursorline = true
-- 系统剪贴板
vim.opt.clipboard = 'unnamedplus'
-- 鼠标
vim.o.mouse = "a"
vim.o.mousemodel = "extend"  -- 关闭右键浮窗
-- 窗口
vim.opt.splitright = true
vim.opt.splitbelow = true
-- 搜索
vim.opt.ignorecase = true  -- 全小写时可搜索到大写（若出现大写则严格匹配）
vim.opt.smartcase = true
-- 画面
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.o.fillchars = "vert:┃"
-- 启动路径
vim.cmd('cd %:p:h')
-- 禁用Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- 终端
vim.o.shell= "cmd"  -- :term 命令（chcp 65001 && cls）
vim.api.nvim_create_autocmd("TermOpen", {  -- 监听事件，自动命名
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(buf, "Term-"..buf..".exe")
  end,
})
-- 主题
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Comment", { bold = true })
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { link = "Normal" })
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { link = "Normal" })
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })  -- 浮窗背景
  end,
})
vim.cmd('colorscheme dawnfox')
------------
-- keymaps
------------
local keymap = vim.keymap
-- 主键
vim.g.mapleader = " "
-- 配置
keymap.set("n", "<leader>in", ":e $MYVIMRC<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>rs", ":source $MYVIMRC<CR>", { noremap = true, silent = true })
-- 模式
keymap.set({"n", "i", "v", "s", "x", "o", "c"}, "fj", "<ESC>")
keymap.set({'n', 'i', 'v'}, '<C-;>', '<End>')  -- 光标移动至行尾
keymap.set({'n', 'i', 'v'}, '<C-\'>', '<Home>')  -- 光标移动至行首
keymap.set('n', '<leader>w', ':w<CR>')  -- Ctrl+v uff0c,u3302,uff08,uff09（全角标点符号）
keymap.set('n', '<leader>cp', ':<C-r>+')  -- 粘贴至命令行
keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- 整行移动
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set('t', 'fj', '<C-\\><C-n>')  -- exit<CR>
keymap.set('i', '<C-BS>', '<C-w>')  -- Ctrl+BackSpace
-- 新增窗口
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
-- bufferline
keymap.set("n", "<leader>bn", ":bn<CR>")
keymap.set("n", "<leader>bp", ":bp<CR>")
keymap.set("n", "<leader>bd", ":bd<CR>")
keymap.set("n", "<leader>bb", ":b#<CR>")  -- Alt+Tab
keymap.set("n", "<leader>b;", ":bufdo bd<CR>")  -- 清空缓冲条
-- nvim-tree
keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>cd", ":NvimTreeOpen %:p:h<CR>", { noremap = true, silent = true })  -- 刷新当前目录
keymap.set("n", "<leader>af", ":NvimTreeOpen D:/A8File/AUTO<CR>", { noremap = true, silent = true })
-- tcc
keymap.set("n", "<leader>cl", ":!cmd /k tcc -o %<.exe %<CR>")  -- 编译前需先关闭程序
keymap.set("n", "<leader>ex", ":terminal chcp 65001 & cls & echo -------------------& echo Welcome To C Space!&echo -------------------& %<.exe<CR>", { noremap = true, silent = true })
-- java
keymap.set("n", "<leader>ja", ":terminal echo ----------------------&echo Welcome To Java Space!&echo ----------------------& java %<CR>", { noremap = true, silent = true })
-- python
keymap.set("n", "<leader>py", ":terminal echo ------------------------&echo Welcome To Python Space!&echo ------------------------& python %<CR>", { noremap = true, silent = true })
-- 主题切换
local themes = { "dawnfox", "duskfox", "tokyonight-moon" }
local index = 1
local function toggle_theme()
  index = index % 3 + 1
  vim.cmd.colorscheme(themes[index])
end
vim.keymap.set("n", "<leader>th", toggle_theme, { noremap = true, silent = true })
------------
-- neovide
------------
-- 关闭窗口
keymap.set("n", "<C-q>", ":q!<CR>")  -- 按键重叠会延迟
-- 字体
vim.o.guifont = "JetBrainsMono Nerd Font,Microsoft YaHei:h16"  -- "Maple Mono NF CN:style=Regular:h16"
-- 标题
vim.o.title = true
vim.o.titlestring = "%F"  -- 文件绝对路径
-- 光标
vim.g.neovide_hide_mouse_when_typing = true  -- 隐藏鼠标
vim.g.neovide_cursor_vfx_mode = "wireframe"  -- 特效
-- 顶部空出距离
vim.g.neovide_padding_top = 0
-- 关闭浮窗阴影
vim.g.neovide_floating_shadow = false
-- 不透明度
vim.g.neovide_transparency = 1.0
-- 全屏
vim.g.neovide_fullscreen = true
function full_screen()
  if vim.g.neovide_fullscreen == false then
    vim.g.neovide_fullscreen = true
  else
    vim.g.neovide_fullscreen = false
  end
end
keymap.set('n', '<leader>fs', ':lua full_screen()<CR>', { noremap = true, silent = true })
-- 标题背景色
vim.g.neovide_title_background_color = string.format(  -- 初始化
  "%x",
  vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg
)
vim.api.nvim_create_autocmd("ColorScheme", {  -- 自动切换
  callback = function()
    vim.g.neovide_title_background_color = string.format(
      "%x",
      vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)
  end
})
------------
-- plugins
------------
-- lualine
function time()  -- 时间
  return " ".. os.date("%H:%M")
end
local battery = ""
function battery()  -- 电量
  if battery == "" then
    local handle = io.popen("wmic path Win32_Battery get EstimatedChargeRemaining /value")
    local result = handle:read("*a")
    handle:close()
    local power = result:match("(%d+)")
    power = tonumber(power)
    if power >= 10 then
      battery = " ".. power .."%%"
    else
      battery = "Battery:N/A"
    end
  end
  return battery
end
vim.loop.new_timer():start(0, 60000, vim.schedule_wrap(function()
  battery = "" end))  -- 定时刷新
require('lualine').setup{
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'location'},
    lualine_c = {'branch', 'diagnostics'},
    lualine_x = {'encoding'},
    lualine_y = {battery},
    lualine_z = {time}
  },
}
----------------
-- tree-sitter
require('nvim-treesitter.configs').setup{
  ensure_installed = { "c", "cpp", "java", "python", "c_sharp",
    "typescript", "javascript", "html", "css", "json", "xml",
    "go", "rust", "markdown", "lua", "vim",
    "ruby", "bash", "sql"
  },
  highlight = {
    enable = true,  -- 启用语法高亮
    additional_vim_regex_highlighting = false,  -- 禁用内建高亮
  },
}
--------------
-- nvim-tree
require('nvim-tree').setup{
  view = {
    width = 30,
  },
  filters = {
    dotfiles = false, -- 显示隐藏文件
    custom = { "desktop.ini" },  -- 隐藏指定文件
  },
  renderer = {
    root_folder_label = function(name)
      return "========= Explorer ========="  -- 自定义标题
    end,
    indent_markers = {
      enable = true,  -- 启用缩进线
    },
  },
}
---------------
-- bufferline
require("bufferline").setup{
  highlights = {
    buffer_selected = {
      italic = false,
    },
  },
  options = {
    separator_style = "slant",  -- slant, slope
    show_buffer_close_icons = true,
    buffer_close_icon = "",
  },
}
------------
-- comment
require('Comment').setup({
  toggler = {  -- Normal Mode
    line = 'gcc',
    block = 'gbc',
  },
  opleader = {  -- Visual Mode
    line = 'gc',
    block = 'gb',
  },
})
--------------
-- autopairs
local npairs_ok, npairs = pcall(require, "nvim-autopairs")
if not npairs_ok then
  return
end
npairs.setup({
  check_ts = true,
  enable_moveright = true,  -- 跳出右符号
})
local Rule = require("nvim-autopairs.rule")
npairs.add_rules({
  Rule("<", ">", { "html", "xml", "markdown" }),
})
--------------
-- indent-bl
local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}
local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup{ scope = { highlight = highlight } }
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
--------------
-- colorizer
require('colorizer').setup()
------------------
-- neovim 0.11.5
-- neovide 0.14.0
-- END
