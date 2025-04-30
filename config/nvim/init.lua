--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

--]]

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Show a few lines of context around the cursor. Note that this makes the text scroll if you
-- mouse-click near the start or end of the window.
vim.opt.scrolloff = 10

-- relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- thin vertical line
vim.opt.colorcolumn = "120"

vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>-", ":split<CR>", { desc = "Horizontal split" })

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

vim.opt.termguicolors = true

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  {
    "NMAC427/guess-indent.nvim",
    opts = {
      auto_cmd = true,     -- Set up autocommand on startup
      override_editorconfig = false,
      filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
        "netrw",
        "tutor",
      },
      filetype_defaults = {
        python = {
          indent_size = 4,
          tab_width = 4,
          use_tabs = false,
        },
      },
    },
  },

  {
    "tzachar/highlight-undo.nvim",
    opts = {
      duration = 500,
    },
  },

  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    keys = {
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },

  {
    -- Autoclose brackets, quotes, etc.
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,                      -- Enable treesitter integration
        ts_config = {
          lua = { "string" },                 -- Don't add pairs in lua string treesitter nodes
          javascript = { "template_string" }, -- Don't add pairs in js template_string
        },
        fast_wrap = {
          map = "<M-e>", -- Alt+e to fast wrap
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      })
    end,
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  {                     -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      -- Document existing key chains
      spec = {
        { "<leader>c", group = "[C]ode",     mode = { "n", "x" } },
        { "<leader>d", group = "[D]ebug" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>f", group = "[F]ind" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>t", group = "[T]oggle" },
      },
    },
  },

  -- ───────────────────────────────────────────── NAVIGATION ─────────────────────────────────────────────

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`

        defaults = {
          path_display = { "truncate" },
        },
        pickers = {
          lsp_references = {
            path_display = { "tail" },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- telescope-file-browser
      require("telescope").load_extension("file_browser")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
      vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>f/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[F]ind [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[F]ind [N]eovim files" })
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>", { desc = "[F]ile [B]rowser" })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      local conf = require("telescope.config").values

      local function toggle_telescope(harpoon_files)
        local finder = function()
          local paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
          end

          return require("telescope.finders").new_table({
            results = paths,
          })
        end

        require("telescope.pickers")
            .new({}, {
              prompt_title = "Harpoon",
              finder = finder(),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
              layout_config = {
                height = 0.7,
                prompt_position = "top",
                preview_cutoff = 120,
              },
              attach_mappings = function(prompt_bufnr, map)
                map("i", "<C-d>", function()
                  local state = require("telescope.actions.state")
                  local selected_entry = state.get_selected_entry()
                  local current_picker = state.get_current_picker(prompt_bufnr)

                  table.remove(harpoon_files.items, selected_entry.index)
                  current_picker:refresh(finder())
                end)
                return true
              end,
            })
            :find()
      end

      vim.keymap.set("n", "<leader>A", function()
        harpoon:list():add()
      end)

      vim.keymap.set("n", "<leader>a", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })

      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end)
      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end)
      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end)
      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end)

      -- Toggle previous & next buffers
      vim.keymap.set("n", "<leader>j", function()
        harpoon:list():prev()
      end)
      vim.keymap.set("n", "<leader>k", function()
        harpoon:list():next()
      end)
    end,
  },

  -- ─────────────────────────────────────────── LSP Plugins ───────────────────────────────────────────
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
    },
    cmd = {
      "DapContinue",
      "DapStepInto",
      "DapStepOver",
      "DapStepOut",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapClearBreakpoints",
      "DapReplOpen",
      "DapReplClose",
      "DapReplExecute",
      "DapReplEvaluate",
    },
    keys = {
      { "<leader>dr", desc = "Debug: Start/Continue" },
      { "<leader>di", desc = "Debug: Step Into" },
      { "<leader>do", desc = "Debug: Step Over" },
      { "<leader>dO", desc = "Debug: Step Out" },
      { "<leader>b",  desc = "Debug: Toggle Breakpoint" },
    },
    config = function(_)
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint", {
        text = "◉",
        texthl = "DapBreakpointSymbol",
        linehl = "DapBreakpointLine",
        numhl = "DapBreakpointNum",
      })

      vim.keymap.set("n", "<leader>dr", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })

      -- Session management
      vim.keymap.set("n", "<leader>dcc", function()
        dap.clear_breakpoints()
        vim.notify("Cleared all breakpoints", vim.log.levels.INFO, { title = "Debug" })
      end, { desc = "Debug: Clear all breakpoints" })

      -- Add the REPL evaluation keymaps
      local dap_repl = require("dap.repl")

      -- Helper function to get visual selection (for code execution in REPL)
      function vim.getVisualSelection()
        vim.cmd('noau normal! "vy"')
        local text = vim.fn.getreg("v")
        vim.fn.setreg("v", {})
        text = string.gsub(text, "\n$", "")
        return text
      end

      -- Execute line OR highlighted code in debug REPL
      vim.keymap.set({ "n", "v" }, "<leader>de", function()
        if vim.fn.mode() == "v" then
          local text = vim.getVisualSelection()
          dap_repl.execute(text)
        else
          local line = vim.api.nvim_get_current_line()
          dap_repl.execute(line)
        end
      end, { desc = "Debug: Execute Line/Selection" })

      -- Python setup
      require("dap-python").setup("python") -- Note: you need debugpy installed
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 1.0 },
          },
          size = 42,
          position = "right",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)

      -- Set up the automatic open/close
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Add the toggle UI keymap
      vim.keymap.set("n", "<leader>du", function()
        dapui.toggle()
      end, { desc = "Debug: Toggle UI" })
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    opts = {
      enabled = true,
      enabled_commands = true,            -- Create commands DapVirtualTextEnable, DapVirtualTextDisable, etc.
      highlight_changed_variables = true, -- Highlight changed values with NvimDapVirtualTextChanged
      highlight_new_as_changed = false,   -- Highlight new variables in the same way as changed variables
      show_stop_reason = true,            -- Show stop reason when stopped for exceptions
      commented = false,                  -- Prefix virtual text with comment string
      only_first_definition = true,       -- Only show virtual text at first definition (if there are multiple)
      all_references = false,             -- Show virtual text on all all references of the variable (not only definitions)

      virt_text_pos = "eol",

      -- Experimental features:
      all_frames = false,      -- Show virtual text for all stack frames not only current
      virt_lines = false,      -- Show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil, -- Position the virtual text at a fixed window column (starting from the first text column)
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
    },
    cmd = {
      "Neotest",
      "NeotestNearest",
      "NeotestFile",
      "NeotestRun",
      "NeotestAttach",
      "NeotestSummary",
    },
    keys = {
      { "<leader>tt", desc = "Run nearest test" },
      { "<leader>tf", desc = "Run tests in current file" },
      { "<leader>td", desc = "Debug nearest test" },
      { "<leader>ts", desc = "Stop/Summary" },
      { "<leader>to", desc = "Open test output" },
    },
    config = function()
      local neotest = require("neotest")
      local dap = require("dap")
      local dapui = require("dapui")

      -- Set up DAP event listeners for UI
      dap.listeners.before.event_initialized["neotest"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["neotest"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["neotest"] = function()
        dapui.close()
      end

      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            python = "python",
            pytest_discover_instance = true,
          }),
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function(path)
              return path:match("(.*/)")
            end,
          }),
        },
        quickfix = {
          enabled = true,
          open = function()
            vim.cmd("copen")
          end,
        },
        icons = {
          running = "◌",
          passed = "✓",
          failed = "✗",
          skipped = "○",
        },
      })

      vim.keymap.set("n", "<leader>tt", function()
        neotest.run.run()
      end, { desc = "Run nearest test" })

      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run tests in current file" })

      vim.keymap.set("n", "<leader>td", function()
        neotest.run.run({ strategy = "dap" })
      end, { desc = "Debug nearest test" })

      vim.keymap.set("n", "<leader>ts", function()
        neotest.run.stop()
      end, { desc = "Stop test run" })

      vim.keymap.set("n", "<leader>ta", function()
        neotest.run.attach()
      end, { desc = "Attach to test run" })

      vim.keymap.set("n", "<leader>to", function()
        neotest.output.open({ enter = true })
      end, { desc = "Open test output" })

      vim.keymap.set("n", "<leader>tp", function()
        neotest.output_panel.toggle()
      end, { desc = "Toggle output panel" })

      vim.keymap.set("n", "<leader>ts", function()
        neotest.summary.toggle()
      end, { desc = "Toggle test summary" })

      vim.keymap.set("n", "[t", function()
        neotest.jump.prev({ status = "failed" })
      end, { desc = "Jump to previous failed test" })

      vim.keymap.set("n", "]t", function()
        neotest.jump.next({ status = "failed" })
      end, { desc = "Jump to next failed test" })
    end,
  },

  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim",       opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config({ signs = { text = diagnostic_signs } })
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},

        -- ─────────────────────────────────── PYTHON ───────────────────────────────────
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
              },
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
        ruff = {
          line_length = 120,
        },

        -- ───────────────────────────────────── LUA ─────────────────────────────────────
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },

        -- ───────────────────────────────── TypeScript ─────────────────────────────────
        ["typescript-language-server"] = {
          settings = {
            javascript = {
              suggest = {
                autoImports = true,
              },
            },
            typescript = {
              suggest = {
                autoImports = true,
              },
            },
          },
        },
        eslint = {},

        emmet_ls = {
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "tsx",
            "jsx",
          },
        },

        -- ───────────────────────────────────── OTHER ─────────────────────────────────────
        cssls = {},
        tailwindcss = {},
        sqlls = {},
        yamlls = {},
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "basedpyright",
        "ruff",
        "debugpy",
        "cssls",
        "tailwindcss",
        "emmet_ls",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  { -- Autocompletion
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = "super-tab",

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 600 },
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      snippets = { preset = "luasnip" },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = "lua" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
    },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting   -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters

      -- list of formatters & linters for mason to install
      require("mason-null-ls").setup({
        ensure_installed = {
          "checkmake",
          "prettier", -- ts/js formatter
          "stylua",   -- lua formatter
          "eslint_d", -- ts/js linter
          "shfmt",
          "ruff",
        },
        -- auto-install configured formatters & linters (with null-ls)
        automatic_installation = true,
      })

      local sources = {
        diagnostics.checkmake,
        formatting.prettier.with({
          filetypes = {
            "html",
            "json",
            "yaml",
            "markdown",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
          },
        }),
        formatting.stylua.with({
          extra_args = { "--indent-width", "2", "--indent-type", "Spaces" },
        }),
        formatting.shfmt.with({ args = { "-i", "4" } }),
        formatting.terraform_fmt,
        require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
        require("none-ls.formatting.ruff_format"),
      }

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
        sources = sources,
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })
    end,
  },

  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    init = function()
      -- Set contrast and style
      -- Available contrast options: 'hard', 'medium'(default), 'soft'
      vim.g.gruvbox_material_background = "soft"
      -- Available foreground options: 'material'(default), 'mix', 'original'
      vim.g.gruvbox_material_foreground = "material"
      -- Available styles: 'default'(default), 'mix', 'original'
      vim.g.gruvbox_material_better_performance = 1

      -- transparency
      vim.g.gruvbox_material_transparent_background = 1

      -- Load the colorscheme
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()
    end,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        "python",
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby", "python" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
      max_lines = 5,        -- Number of lines the context will take up at most
      trim_scope = "outer", -- Controls which context lines to discard if max_lines is exceeded
      patterns = {          -- Match patterns for showing context
        default = {
          "class",
          "function",
          "method",
          "for",
          "while",
          "if",
          "switch",
          "case",
        },
      },
    },
  },

  {
    "https://github.com/github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Accept the current suggestion
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
      })
      -- Accept next word
      vim.keymap.set("i", "<C-k>", "<Plug>(copilot-accept-word)", {
        silent = true,
      })
      -- Accept current line
      vim.keymap.set("i", "<C-;>", "<Plug>(copilot-accept-line)", {
        silent = true,
      })
      -- Show next/previous suggestion
      vim.keymap.set("i", "<C-i>", "<Plug>(copilot-next)", {
        silent = true,
      })
      vim.keymap.set("i", "<C-u>", "<Plug>(copilot-previous)", {
        silent = true,
      })
      -- Dismiss suggestion
      vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)", {
        silent = true,
      })
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
      },
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "gruvbox-material",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },

        sections = {
          lualine_a = {
            {
              "filename",
              path = 1,
              shorting_target = 55,
            },
          },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            {
              "harpoon2",
            },
          },
          lualine_x = {
            { "diagnostics",   sections = { "error", "warn" } },
            { "searchcount" },
            { "selectioncount" },
          },
          lualine_y = { "location" },
          lualine_z = { "mode" },
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false,
    ---@module "neo-tree"
    ---@type neotree.Config?
    opts = {
      window = {
        position = "right",
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.keymap.set("n", "<leader>e", function()
        require("neo-tree.command").execute({
          position = "right",
          toggle = true,
        })
      end, { desc = "Toggle Neo-tree" })
    end,
  },

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
