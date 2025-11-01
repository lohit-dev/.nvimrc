# Kvim Neovim Configuration

A modern, well-organized Neovim configuration built with Lua, featuring a modular plugin system and comprehensive language support.

## 🚀 Features

- **Modern Plugin System**: Organized plugin structure with lazy loading
- **LSP Support**: Full Language Server Protocol integration with enhanced UI
- **File Explorer**: Oil.nvim for editing your filesystem like a buffer
- **Terminal Integration**: ToggleTerm for persistent terminal sessions
- **Language Support**: Rust, Go, and more with dedicated configurations
- **Auto-formatting**: Pre-commit hooks ensure consistent code formatting

## 📁 Structure

```
kvim/
├── init.lua                    # Bootstrap and plugin loading
├── lua/kinggrey/
│   ├── keymap.lua              # Key mappings and settings
│   ├── health.lua              # Health checks
│   └── plugins/
│       ├── init.lua            # Main plugins (colorscheme, core, editing, UI, utility, lang)
│       ├── lsp/
│       │   ├── init.lua        # LSP plugins (lazydev, lspconfig, cmp, lspsaga)
│       │   ├── lazydev.lua
│       │   ├── lspconfig.lua
│       │   ├── cmp.lua         # blink.cmp - autocompletion
│       │   └── lspsaga.lua
│       └── lang/
│           ├── rust.lua        # Rust support (rustaceanvim, crates.nvim)
│           └── go.lua          # Go support (gopher.nvim)
```

## 🔧 Requirements

- Neovim 0.8+ (recommended 0.10+)
- Git
- Bun (for Husky hooks) - [Install Bun](https://bun.sh/)
- Stylua (for formatting) - [Install Stylua](https://github.com/JohnnyMorganz/StyLua)

## 📦 Installation

1. Clone this repository to your Neovim config directory:
```bash
git clone <your-repo-url> ~/.config/nvim
# or if using kvim name
git clone <your-repo-url> ~/.config/kvim
```

2. Install dependencies:
```bash
bun install  # For Husky hooks
```

3. Start Neovim - Lazy.nvim will automatically install all plugins:
```bash
nvim
```

## 🎨 Key Features

### Plugin Management
- **Lazy.nvim**: Fast plugin manager with lazy loading
- **Organized Structure**: Plugins grouped by category for easy maintenance

### Language Support
- **Rust**: rustaceanvim + crates.nvim for Cargo.toml management
- **Go**: gopher.nvim for Go development
- **More**: Easy to add new languages in `plugins/lang/`

### File Explorer
- **Oil.nvim**: Edit filesystem like a buffer
- **Extensions**: Git status, LSP diagnostics integration

### Terminal
- **ToggleTerm**: Multiple terminal support
  - `<leader>tv` - Terminal vertical split
  - `<leader>th` - Terminal horizontal split
  - `<leader>tf` - Terminal float

### LSP & Completion
- **blink.cmp**: Modern autocompletion
- **LSP Config**: Language Server Protocol setup
- **LSPSaga**: Enhanced LSP UI
- **Pretty Hover**: Beautiful documentation formatting

## ⌨️ Key Mappings

### General
- `<leader>` = `Space`
- `<Esc>` - Clear search highlight
- `jj` - Exit insert mode
- `<leader>w` - Save file
- `<leader>e` - Toggle Oil file explorer

### Terminal
- `<leader>tv` - Terminal vertical
- `<leader>th` - Terminal horizontal
- `<leader>tf` - Terminal float

### File Explorer (Oil)
- `<leader>e` - Open Oil
- `H` - Toggle hidden files
- `-` or `<BS>` - Go to parent directory
- `<CR>` - Open file/directory

### LSP
- `<leader>a` - Code actions (in Rust files)
- `K` - Hover with actions (in Rust files)
- Various mappings via LSP and LSPSaga

## 🛠️ Development

### Adding New Plugins

**Main Plugins** - Add to `lua/kinggrey/plugins/init.lua`:
```lua
require("kinggrey.plugins.your-plugin"),
```

**LSP Plugins** - Add to `lua/kinggrey/plugins/lsp/init.lua`:
```lua
require("kinggrey.plugins.lsp.your-lsp-plugin"),
```

**Language Plugins** - Create new file in `lua/kinggrey/plugins/lang/`:
```lua
-- lang/python.lua
return {
  {
    "your-python-plugin",
    ft = "python",
    config = function()
      -- config here
    end,
  },
}
```

### Code Formatting

This repository uses **Stylua** for Lua code formatting. Formatting is enforced via Husky pre-commit hooks.

**Manual formatting:**
```bash
stylua lua/
# or
bun run format
```

**Install Husky:**
```bash
bun install
```

**Pre-commit hook** automatically formats staged Lua files before commits using Stylua.

The hook will:
1. Format all Lua files in the `lua/` directory
2. Add the formatted files back to staging
3. Continue with the commit

## 📝 Configuration Files

- `.stylua.toml` - Stylua formatting configuration
- `lazy-lock.json` - Lazy.nvim plugin lock file
- `package.json` - Bun dependencies (Husky)
- `.husky/pre-commit` - Pre-commit hook for auto-formatting

## 🔍 Health Check

Run `:checkhealth` in Neovim to see the status of all components, or use the custom health check:
```lua
:checkhealth kinggrey
```

## 📚 Plugin Highlights

- **blink.cmp**: Autocompletion engine
- **oil.nvim**: File explorer
- **toggleterm.nvim**: Terminal management
- **rustaceanvim**: Rust development
- **gopher.nvim**: Go development
- **lspsaga.nvim**: Enhanced LSP UI
- **which-key.nvim**: Key mapping helper
- **telescope.nvim**: Fuzzy finder

## 🤝 Contributing

1. Make your changes
2. Ensure code is formatted (will happen automatically on commit)
3. Commit your changes

## 📄 License

See [LICENSE.md](LICENSE.md) for details.

---

**Enjoy your Neovim setup!** 🎉
