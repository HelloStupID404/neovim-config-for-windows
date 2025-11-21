:: cd to the directory of the plugins first
@echo off

for %%r in (
    https://github.com/EdenEast/nightfox.nvim.git
    https://github.com/folke/tokyonight.nvim.git

    https://github.com/nvim-lualine/lualine.nvim.git
    https://github.com/nvim-tree/nvim-tree.lua.git
    https://github.com/akinsho/bufferline.nvim.git
    https://github.com/nvim-treesitter/nvim-treesitter.git
    https://github.com/lukas-reineke/indent-blankline.nvim.git
    https://github.com/RRethy/vim-illuminate.git
    https://github.com/norcalli/nvim-colorizer.lua.git
    https://github.com/HiPhish/rainbow-delimiters.nvim.git
    https://github.com/windwp/nvim-autopairs.git
    https://github.com/numToStr/Comment.nvim.git
    https://github.com/lewis6991/gitsigns.nvim.git
    https://github.com/nvim-tree/nvim-web-devicons.git

    https://github.com/neovim/nvim-lspconfig.git
    https://github.com/mason-org/mason.nvim.git
    https://github.com/mason-org/mason-lspconfig.nvim.git
    https://github.com/hrsh7th/nvim-cmp.git
    https://github.com/hrsh7th/cmp-buffer.git
    https://github.com/hrsh7th/cmp-nvim-lsp.git
    https://github.com/saadparwaiz1/cmp_luasnip.git
    https://github.com/L3MON4D3/LuaSnip.git
    https://github.com/rafamadriz/friendly-snippets.git
) do (
    git clone %%r
)

pause