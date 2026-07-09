return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local builtin = require("telescope.builtin")

    -- Theme-aware palette, same approach as lua/kinggrey/lualine.lua: pull
    -- real colors out of whatever colorscheme is active instead of hardcoding
    -- hex values or relying on alpha's default hl links (which is why the
    -- header used to render yellow no matter which theme was picked -- alpha
    -- links AlphaHeader -> "Type", and "Type" happens to be yellow/orange in
    -- most colorschemes).
    local function to_hex(color)
      if type(color) ~= "number" then
        return nil
      end
      return string.format("#%06x", color)
    end

    local function hl(name)
      local ok, value = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if not ok then
        return {}
      end
      return value
    end

    local function pick(specs, key, fallback)
      for _, name in ipairs(specs) do
        local value = to_hex(hl(name)[key])
        if value then
          return value
        end
      end
      return fallback
    end

    -- OVERMIND ASCII header
    dashboard.section.header.val = {
      [[                                                                              ]],
      [[    _       _________ _        _______    _______  _______  _______           ]],
      [[   | \    /\\__   __/( (    /|(  ____ \  (  ____ \(  ____ )(  ____ \|\     /| ]],
      [[   |  \  / /   ) (   |  \  ( || (    \/  | (    \/| (    )|| (    \/( \   / ) ]],
      [[   |  (_/ /    | |   |   \ | || |        | |      | (____)|| (__     \ (_) /  ]],
      [[   |   _ (     | |   | (\ \) || | ____   | | ____ |     __)|  __)     \   /   ]],
      [[   |  ( \ \    | |   | | \   || | \_  )  | | \_  )| (\ (   | (         ) (    ]],
      [[   |  /  \ \___) (___| )  \  || (___) |  | (___) || ) \ \__| (____/\   | |    ]],
      [[   |_/    \/\_______/|/    )_)(_______)  (_______)|/   \__/(_______/   \_/    ]],
      [[                                                                              ]],
    }

    --- Re-derive dashboard highlight groups from the active colorscheme.
    --- Called once up front and again on every ColorScheme change, so
    --- switching themes (:Theme, the picker, etc) updates the dashboard's
    --- colors too instead of leaving it stuck on whatever rendered at startup.
    local function apply_theme()
      local violet = pick({ "Keyword", "Type", "Statement" }, "fg", "#d183e8")
      local blue = pick({ "Function", "Special", "Directory" }, "fg", "#80a0ff")
      local cyan = pick({ "String", "Conditional", "DiagnosticInfo" }, "fg", "#79dac8")
      local grey = pick({ "Comment" }, "fg", "#6c7086")

      vim.api.nvim_set_hl(0, "KingGreyDashHeader", { fg = violet, bold = true })
      vim.api.nvim_set_hl(0, "KingGreyDashButtons", { fg = blue })
      vim.api.nvim_set_hl(0, "KingGreyDashShortcut", { fg = cyan, bold = true })
      vim.api.nvim_set_hl(0, "KingGreyDashFooter", { fg = grey, italic = true })
    end

    apply_theme()
    dashboard.section.header.opts.hl = "KingGreyDashHeader"
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("KingGreyDashboardTheme", { clear = true }),
      callback = function()
        apply_theme()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Dashboard buttons -- plain text, no emoji/icons
    dashboard.section.buttons.val = {
      dashboard.button("e", "Open Explorer", "<cmd>Oil<cr>"),
      dashboard.button("r", "Recently Opened Files", function()
        builtin.oldfiles({ only_cwd = false })
      end),
      dashboard.button("s", "Open Last Session", function()
        local session_path = vim.fn.stdpath("data") .. "/Session.vim"
        if vim.fn.filereadable(session_path) == 1 then
          vim.cmd("source " .. session_path)
          vim.notify("Session loaded!", vim.log.levels.INFO)
        else
          -- Try alternative session paths
          local alt_paths = {
            vim.fn.stdpath("data") .. "/sessions/last_session.vim",
            vim.fn.getcwd() .. "/.nvim_session.vim",
          }
          local found = false
          for _, path in ipairs(alt_paths) do
            if vim.fn.filereadable(path) == 1 then
              vim.cmd("source " .. path)
              vim.notify("Session loaded!", vim.log.levels.INFO)
              found = true
              break
            end
          end
          if not found then
            vim.notify(
              "No saved session found. Use :mksession to save a session.",
              vim.log.levels.WARN
            )
          end
        end
      end),
      dashboard.button("f", "Find File", function()
        builtin.find_files()
      end),
      dashboard.button("w", "Find Word", function()
        builtin.grep_string()
      end),
      dashboard.button("g", "Live Grep", function()
        builtin.live_grep()
      end),
      dashboard.button("b", "Open Buffers", function()
        builtin.buffers()
      end),
      dashboard.button("h", "Help Tags", function()
        builtin.help_tags()
      end),
      dashboard.button("q", "Quit NVim", "<cmd>qa<cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "KingGreyDashButtons"
      button.opts.hl_shortcut = "KingGreyDashShortcut"
    end

    -- Footer: e.g. "6th Jul 2026 Monday  6:10 AM"
    local function ordinal(n)
      local suffix = "th"
      if n % 100 < 11 or n % 100 > 13 then
        local last_digit = n % 10
        if last_digit == 1 then
          suffix = "st"
        elseif last_digit == 2 then
          suffix = "nd"
        elseif last_digit == 3 then
          suffix = "rd"
        end
      end
      return n .. suffix
    end

    -- Footer with statistics
    local function footer()
      local now = os.date("*t")
      local day = ordinal(now.day)
      local month = os.date("%b")
      local weekday = os.date("%A")
      local time = os.date("%I:%M %p"):gsub("^0", "")
      return ("  %s %s %d %s  %s"):format(day, month, now.year, weekday, time)
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "KingGreyDashFooter"

    -- Setup alpha
    alpha.setup(dashboard.config)

    -- Refresh footer on load
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        dashboard.section.footer.val = footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
