-- Host de Python (tu venv)
vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/neovim/bin/python"

-----------------------------------------------------------
-- Opciones básicas
-----------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.g.mapleader = " "

-----------------------------------------------------------
-- lazy.nvim bootstrap
-----------------------------------------------------------
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

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------
require("lazy").setup({
  ---------------------------------------------------------
  -- Temas y UI
  ---------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          icons_enabled = true,
        },
      })
    end,
  },

  ---------------------------------------------------------
  -- Árbol de archivos
  ---------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  ---------------------------------------------------------
  -- Telescope (fuzzy finder)
  ---------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep()  end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers()    end, desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags()  end, desc = "Help tags" },
    },
    config = function()
      require("telescope").setup({})
    end,
  },

  ---------------------------------------------------------
  -- Treesitter
  ---------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end
      ts_configs.setup({
        ensure_installed = { "lua", "python", "bash", "json", "yaml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  ---------------------------------------------------------
  -- LSP: mason + lspconfig (API clásica)
  ---------------------------------------------------------
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

 
    {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { "pyright", "lua_ls" },
        automatic_installation = true,
        handlers = {
          function(_)
            -- Handler vacío: usamos la API nativa vim.lsp.config de Neovim 0.11+
          end,
        },
      })

      -- Configurar LSP con la API nativa de Neovim 0.11+

      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        filetypes = { "python" },
      }
      vim.lsp.enable("pyright")

      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        root_markers = { ".luarc.json", ".luacheckrc", "selene.toml", ".git" },
        filetypes = { "lua" },
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      }
      vim.lsp.enable("lua_ls")
    end,
  },

  ---------------------------------------------------------
  -- Autocompletado: nvim-cmp
  ---------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]     = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  ---------------------------------------------------------
  -- Calidad de vida
  ---------------------------------------------------------
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", ":UndotreeToggle<CR>", desc = "Toggle Undotree" },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  ---------------------------------------------------------
  -- GitHub Copilot (copilot.lua + copilot-cmp)
  ---------------------------------------------------------
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false, -- usamos copilot-cmp, no los ghost text de aquí
        },
        panel = {
          enabled = false,
        },
      })
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
      -- añadir fuente de Copilot a nvim-cmp
      local cmp = require("cmp")
      local sources = cmp.get_config().sources
      table.insert(sources, 1, { name = "copilot" })
      cmp.setup({ sources = sources })
    end,
  },

----------------------------------------------------------
--- para Clip board ----
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup({
        max_length = 0,      -- sin límite
        silent = true,       -- no mensajes
        trim = false,
      })

      -- Mapear yank al clipboard con OSC 52
      local function copy(lines, _)
        require("osc52").copy(table.concat(lines, "\n"))
      end

      local function paste()
        return { vim.fn.getreg('"'), vim.fn.getregtype('"') }
      end

      vim.g.clipboard = {
        name = "osc52",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
      }
    end,
  },


})

-----------------------------------------------------------
-- Mapeos básicos
-----------------------------------------------------------
vim.keymap.set("n", "<leader>qq", ":qa!<CR>", { silent = true, desc = "Quit all" })

-- -- Silenciar el warning de deprecación de nvim-lspconfig
-- pcall(function()
--   local lspconfig = require("lspconfig")
--   if lspconfig.util and lspconfig.util._set_log_level then
--     lspconfig.util._set_log_level("OFF")
--   end
-- end)
