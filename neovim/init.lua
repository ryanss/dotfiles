-- Settings
vim.g.mapleader = " "
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.laststatus = 3
vim.o.scrolloff = 3
vim.o.shiftwidth = 4
vim.o.sidescrolloff = 3
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.wrap = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})


-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Plugins
require("lazy").setup({

  { -- Neovim theme based off an arctic, north-bluish color palette
    "shaunsingh/nord.nvim",
    config = function()
      vim.g.nord_borders = true
      vim.g.nord_disable_background = true
      vim.g.nord_italic = false
      vim.cmd.colorscheme("nord")
    end,
  },

  { -- Highly extendable fuzzy finder over lists
    "nvim-telescope/telescope.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("telescope").load_extension("projects")
    end,
    keys = {
      { "<leader>f", [[<cmd>Telescope find_files hidden=true<cr>]] },
      { "<leader>p", [[<cmd>Telescope projects<cr>]] },
      { "<leader><tab>", [[<cmd>Telescope buffers ]] ..
                         [[sort_mru=true ignore_current_buffer=true<cr>]] },
    },
  },

  { -- The superior project management solution for Neovim
    "ahmedkhalf/project.nvim",
    config = function() require("project_nvim").setup() end,
  },

  { -- Magit clone for Neovim
    'TimUntersberger/neogit',
    opts = { disable_commit_confirmation = true },
    keys = {{ "<leader>gg", [[<cmd>Neogit<cr>]] }},
  },

  { -- Git decorations for buffers
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function()
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "[g", gs.prev_hunk)
        vim.keymap.set("n", "]g", gs.next_hunk)
        vim.keymap.set("n", "<leader>gd", gs.toggle_deleted)
        vim.keymap.set("n", "<leader>gp", gs.preview_hunk)
        vim.keymap.set("n", "<leader>gr", gs.reset_hunk)
        vim.keymap.set("n", "<leader>gs", gs.stage_hunk)
        vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk)
        vim.keymap.set({"o", "x"}, "ig", gs.select_hunk)
      end,
    },
    event = 'BufReadPost',
  },

  { -- General-purpose motion plugin for Neovim
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

})


-- Keymaps
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
