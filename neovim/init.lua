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
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.wrap = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json,lua",
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
      vim.g.nord_bold = false
      vim.g.nord_italic = false
      vim.cmd.colorscheme("nord")
      vim.cmd([[highlight @comment gui=italic]])
      vim.cmd([[highlight @keyword.function guifg=#81A1C1]])
      vim.cmd([[highlight @keyword.operator guifg=#81A1C1]])
      vim.cmd([[highlight @keyword.return guifg=#81A1C1]])
      vim.cmd([[highlight @function gui=bold]])
      vim.cmd([[highlight @function.call guifg=#88C0D0 gui=none]])
    end,
  },

  { -- A blazing fast and easy to configure neovim statusline plugin
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
    },
  },

  { -- Highly extendable fuzzy finder over lists
    "nvim-telescope/telescope.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>f", [[<cmd>Telescope find_files hidden=true<cr>]] },
      { "<leader>p", [[<cmd>Telescope projects<cr>]] },
      { "<leader><tab>", [[<cmd>Telescope buffers ]] ..
                         [[sort_mru=true ignore_current_buffer=true<cr>]] },
    },
  },

  { -- The superior project management solution for Neovim
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
      require("telescope").load_extension("projects")
    end,
  },

  { -- A file explorer tree for neovim
    "nvim-tree/nvim-tree.lua",
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true
      },
      filters = { dotfiles = true }
    },
    cmd = "NvimTreeToggle",
    keys = {{ "<leader>t", [[<cmd>NvimTreeToggle<cr>]] }},
  },

  { -- File manager for Neovim powered by nnn
    "luukvbaal/nnn.nvim",
    config = true,
    keys = {{ "<leader>n", [[<cmd>NnnPicker<cr>]] }},
  },

  { -- Magit clone for Neovim
    "TimUntersberger/neogit",
    opts = { disable_commit_confirmation = true },
    keys = {{ "<leader>gg", [[<cmd>write<cr><cmd>Neogit<cr>]] }},
  },

  { -- Git decorations for buffers
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
      on_attach = function()
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "<leader>gd", gs.toggle_deleted)
        vim.keymap.set("n", "<leader>gp", gs.preview_hunk)
        vim.keymap.set("n", "<leader>gr", gs.reset_hunk)
        vim.keymap.set("n", "<leader>gs", gs.stage_hunk)
        vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk)
        vim.keymap.set({"o", "x"}, "ig", gs.select_hunk)
        local ts_repeat = require("nvim-treesitter.textobjects.repeatable_move")
        local next_hunk, prev_hunk =
          ts_repeat.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
        vim.keymap.set({"n", "x", "o"}, "]g", next_hunk)
        vim.keymap.set({"n", "x", "o"}, "[g", prev_hunk)
      end,
    },
  },

  { -- A Git wrapper so awesome, it should be illegal
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {{ "<leader>gb", [[<cmd>Git blame<cr>]] }},
  },

  { -- Detects and activates virtualenvs in your poetry or pipenv project
    "petobens/poet-v",
    init = function()
      vim.g.poetv_executables = {"poetry"}
      vim.g.poetv_auto_activate = 1
    end,
  },

  { -- Language Server Protocols
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup({})
      vim.keymap.set("n", "<leader>m", [[<cmd>Mason<cr>]])

      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "gr", vim.lsp.buf.references)
      vim.keymap.set("n", "gR", vim.lsp.buf.rename)
      vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
      vim.keymap.set("n", "ge", vim.diagnostic.open_float)

      local diag_opts = { severity = { min = vim.diagnostic.severity.HINT } }
      local function update_severity(s)
        diag_opts = s
        if s ~= false then
          diag_opts = { severity = { min = vim.diagnostic.severity[diag_opts] } }
        end
        vim.diagnostic.config({
          underline = diag_opts,
          virtual_text = diag_opts,
          signs = diag_opts,
        })
        local ts_repeat = require("nvim-treesitter.textobjects.repeatable_move")
        local next_diag, prev_diag = ts_repeat.make_repeatable_move_pair(
          function() vim.diagnostic.goto_next(diag_opts) end,
          function() vim.diagnostic.goto_prev(diag_opts) end)
        vim.keymap.set({"n", "x", "o"}, "]e", next_diag)
        vim.keymap.set({"n", "x", "o"}, "[e", prev_diag)
      end
      update_severity('HINT')
      vim.keymap.set("n", "<space>ee", function() update_severity('ERROR') end)
      vim.keymap.set("n", "<space>ew", function() update_severity('WARN') end)
      vim.keymap.set("n", "<space>ed", function() update_severity('HINT') end)
      vim.keymap.set("n", "<space>eo", function() update_severity(false) end)
      vim.keymap.set("n", "<space>eq", function()
        vim.diagnostic.setloclist(diag_opts)
      end)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        settings = { Lua = { completion = { keywordSnippet = "Disable" } } } })
      require("lspconfig").pyright.setup({
        capabilities = capabilities,
        settings = { python = { pythonPath = ".venv/bin/python" } },
      })
    end,
  },

  { -- A tree like view for symbols in Neovim using the Language Server Protocol
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({
        autofold_depth = 1,
        -- show_symbol_details = false,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "Outline",
        callback = function()
          vim.opt_local.signcolumn = "no"
        end,
      })
    end,
    keys = {{ "<leader>o", [[<cmd>SymbolsOutline<cr>]]}},
  },

  { -- Pretty diagnostics, references, telescope results, quickfix/location list
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local trouble = require("trouble.providers.telescope")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = { ['<c-t>'] = trouble.open_with_trouble },
            n = { ['<c-t>'] = trouble.open_with_trouble },
          }
        }
      })
    end,
    keys = {
      { "<leader>q", [[<cmd>TroubleToggle document_diagnostics<cr>]] },
      { "<leader>w", [[<cmd>TroubleToggle workspace_diagnostics<cr>]] },
      { "<leader>xl", [[<cmd>TroubleToggle loclist<cr>]] },
      { "<leader>xq", [[<cmd>TroubleToggle quickfix<cr>]] },
      { "gd", [[<cmd>TroubleToggle lsp_definitions<cr>]] },
      { "gr", [[<cmd>TroubleToggle lsp_references<cr>]] },
    },
  },

  { -- A completion plugin for neovim coded in Lua
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp", max_item_count = 5 },
          { name = "buffer", max_item_count = 5 },
          { name = "path",
            option = {
              get_cwd = function() return vim.fn.getcwd() end,
            },
          },
          { name = "luasnip" },
        }),
        mapping = cmp.mapping.preset.insert({
          ['<tab>'] = cmp.mapping.confirm({ select = true }),
          ['<S-tab>'] = cmp.mapping.abort(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })
    end,
  },

  { -- Nvim Treesitter configurations and abstraction layer
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "help" },
        auto_install = true,
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "+",
            node_incremental = "+",
            node_decremental = "_",
          },
        },
      })
    end,
  },

  { -- Treesitter playground integrated into Neovim
    "nvim-treesitter/playground",
    keys = {
      { "<leader>Tc", [[<cmd>TSHighlightCapturesUnderCursor<cr>]]},
      { "<leader>Tp", [[<cmd>TSPlaygroundToggle<cr>]]},
    },
  },

  { -- Syntax aware text-objects, select, move, swap, and peek support
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]a"] = "@parameter.inner",
              ["]c"] = "@comment.outer",
              ["]C"] = "@class.outer",
              ["]f"] = "@function.outer",
            },
            goto_previous_start = {
              ["[a"] = "@parameter.inner",
              ["[c"] = "@comment.outer",
              ["[C"] = "@class.outer",
              ["[f"] = "@function.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",  ["ia"] = "@parameter.inner",
              ["ac"] = "@comment.outer",    ["ic"] = "@comment.inner",
              ["aC"] = "@class.outer",      ["iC"] = "@class.inner",
              ["af"] = "@function.outer",   ["if"] = "@function.inner",
            },
          },
          swap = {
            enable = true,
            swap_next =     { ["<leader>a"] = "@parameter.inner" },
            swap_previous = { ["<leader>A"] = "@parameter.inner" },
          },
        }
      })
      -- Make movements repeatable with ; and ,
      local ts_repeat = require("nvim-treesitter.textobjects.repeatable_move")
      vim.keymap.set({"n", "x", "o"}, ";", ts_repeat.repeat_last_move)
      vim.keymap.set({"n", "x", "o"}, ",", ts_repeat.repeat_last_move_opposite)
      -- Make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f)
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F)
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t)
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T)
    end,
  },

  { -- Use treesitter to auto close and auto rename html tags
    "windwp/nvim-ts-autotag",
    config = true,
  },

  { -- Autopair plugin for Neovim that supports multiple characters
    "windwp/nvim-autopairs",
    config = true,
  },

  { -- A nicer Python indentation style for vim
    "Vimjas/vim-python-pep8-indent"
  },

  { -- Add/change/delete surrounding delimiter pairs with ease
    "kylechui/nvim-surround",
    config = true,
  },

  { -- Smart and powerful comment plugin for neovim
    "numToStr/Comment.nvim",
    config = true,
  },

  { -- Better whitespace highlighting for Vim
    "ntpeters/vim-better-whitespace",
    config = function()
      -- Do it this way to prevent unwanted highlighting in insert mode
      vim.g.better_whitespace_enabled = 0
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd([[EnableWhitespace]])
        end,
      })
      vim.g.better_whitespace_filetypes_blacklist = {'toggleterm'}
      local ts_repeat = require("nvim-treesitter.textobjects.repeatable_move")
      local next_ws, prev_ws = ts_repeat.make_repeatable_move_pair(
        function() vim.cmd([[NextTrailingWhitespace]]) end,
        function() vim.cmd([[PrevTrailingWhitespace]]) end)
      vim.keymap.set("n", "]w", next_ws)
      vim.keymap.set("n", "[w", prev_ws)
    end,
  },

  { -- Improved Yank and Put functionalities for Neovim
    "gbprod/yanky.nvim",
    dependencies = "kkharji/sqlite.lua",
    config = function()
      require("yanky").setup({
        ring = {
          storage = "sqlite",
        }
      })
      vim.keymap.set({"n", "x"}, "y", [[<Plug>(YankyYank)]])
      vim.keymap.set({"n", "x"}, "p", [[<Plug>(YankyPutAfter)]])
      vim.keymap.set({"n", "x"}, "P", [[<Plug>(YankyPutBefore)]])
      vim.keymap.set("n", "<C-p>", [[<Plug>(YankyCycleForward)]])
      vim.keymap.set("n", "<C-n>", [[<Plug>(YankyCycleBackward)]])
      require("telescope").load_extension("yank_history")
      vim.keymap.set("n", "<leader>y", [[<cmd>Telescope yank_history<cr>]])
      -- Copy to system clipboard
      vim.keymap.set("v", "<C-c>", '"+y')
    end,
  },

  { -- General-purpose motion plugin for Neovim
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  { -- A neovim lua plugin to help easily manage multiple terminal windows
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    opts = {
      size = function(term)
        if term.direction == "vertical" then return vim.o.columns * 0.5
        else return vim.o.lines * 0.3 end
      end,
    },
  },

})


-- Keymaps
vim.keymap.set("n", "<leader>l", [[<cmd>Lazy<cr>]])

-- Fix j/k movements in wrapped lines
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Use Caps+j/k in command completion popups
vim.keymap.set('c', '<up>',   '<C-p>')
vim.keymap.set('c', '<down>', '<C-n>')

-- Toggle terminals; move between splits
local function termcmd(key, direction)
  local vcount = vim.v.count
  if vim.fn.mode() == "t" then vcount = 0 end
  if vcount >= 1 or vim.fn.winnr() == vim.fn.winnr(key) then
    if key == "h"
      then vim.cmd([[NvimTreeToggle]])
    else
      local id = require("toggleterm.terminal").get_focused_id() or vcount or 0
      require("toggleterm").toggle(id, nil, nil, direction)
    end
  else
    vim.cmd("wincmd " .. key)
  end
end
vim.keymap.set({"n", "t"}, "<C-h>", function() termcmd("h") end)
vim.keymap.set({"n", "t"}, "<C-j>", function() termcmd("j", "horizontal") end)
vim.keymap.set({"n", "t"}, "<C-k>", function() termcmd("k", "float") end)
vim.keymap.set({"n", "t"}, "<C-l>", function() termcmd("l", "vertical") end)
vim.keymap.set("t", "<C-]>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-w>o", [[<cmd>wincmd o<cr>]])

-- Resize splits
vim.keymap.set({"n", "t"}, "<C-A-j>", [[<cmd>resize -2<cr>]])
vim.keymap.set({"n", "t"}, "<C-A-k>", [[<cmd>resize +2<cr>]])
vim.keymap.set({"n", "t"}, "<C-A-h>", [[<cmd>vertical resize +3<cr>]])
vim.keymap.set({"n", "t"}, "<C-A-l>", [[<cmd>vertical resize -3<cr>]])
