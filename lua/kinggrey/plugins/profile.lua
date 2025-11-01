return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')
    local builtin = require('telescope.builtin')

    -- Custom header with OVERMIND ASCII art
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

    -- Dashboard buttons
    dashboard.section.buttons.val = {
      dashboard.button('e', '📁 Open Explorer', '<cmd>Oil<cr>'),
      dashboard.button('r', '📂 Recently Opened Files', function()
        builtin.oldfiles({ only_cwd = false })
      end),
      dashboard.button('s', '💾 Open Last Session', function()
        local session_path = vim.fn.stdpath('data') .. '/Session.vim'
        if vim.fn.filereadable(session_path) == 1 then
          vim.cmd('source ' .. session_path)
          vim.notify('Session loaded!', vim.log.levels.INFO)
        else
          -- Try alternative session paths
          local alt_paths = {
            vim.fn.stdpath('data') .. '/sessions/last_session.vim',
            vim.fn.getcwd() .. '/.nvim_session.vim',
          }
          local found = false
          for _, path in ipairs(alt_paths) do
            if vim.fn.filereadable(path) == 1 then
              vim.cmd('source ' .. path)
              vim.notify('Session loaded!', vim.log.levels.INFO)
              found = true
              break
            end
          end
          if not found then
            vim.notify('No saved session found. Use :mksession to save a session.', vim.log.levels.WARN)
          end
        end
      end),
      dashboard.button('f', '🔍 Find File', function()
        builtin.find_files()
      end),
      dashboard.button('w', '🔤 Find Word', function()
        builtin.grep_string()
      end),
      dashboard.button('g', '📝 Live Grep', function()
        builtin.live_grep()
      end),
      dashboard.button('b', '📑 Open Buffers', function()
        builtin.buffers()
      end),
      dashboard.button('h', '❓ Help Tags', function()
        builtin.help_tags()
      end),
      dashboard.button('q', '❌ Quit NVim', '<cmd>qa<cr>'),
    }

    -- Footer with statistics
    local function footer()
      local datetime = os.date('  %d-%m-%Y %H:%M:%S')
      local plugins_text = ''
      local lazy_ok, lazy = pcall(require, 'lazy')
      if lazy_ok then
        local count = #vim.tbl_keys(require('lazy').plugins())
        plugins_text = '  ' .. count .. ' plugins'
      end
      return datetime .. plugins_text
    end

    dashboard.section.footer.val = footer()

    -- Setup alpha
    alpha.setup(dashboard.config)

    -- Refresh footer on load
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        dashboard.section.footer.val = footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}