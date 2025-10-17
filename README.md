# Neovim Supercharged — Your Ultimate, Zero-Fuss Dev Environment

Welcome to a fast, modern, and highly-configurable Neovim setup designed for everyday development across languages — from Zig to TypeScript, Rust to Python, and everything in between.

This configuration focuses on:
- Speedy startup and lazy-loading of plugins
- Great defaults for editing, navigation, git, and debugging
- A carefully tuned LSP & tooling experience (mason/mason-lspconfig, lspconfig, autopairs, treesitter, dap)
- A single, maintainable place for small feature configs (consolidated helpers in `lua/configs/merged.lua`)
- Pragmatic keymaps that are discoverable, consistent, and extensible

Why this config?
- Works out-of-the-box for modern JS/TS/React + backend languages
- Includes Zig language support (`zls`) and sensible Zig keymaps
- Lazy proxy shims keep backward compatibility for old module names while staying fast
- Centralized small-configs reduce cognitive overhead when making edits

Quick Preview
- Leader key: <Space>
- Common keymaps: `<Space>f` (format), `gd` (goto def), `K` (hover), `<Space>gg` (Neogit)
- Zig: `<Space>zb` (build), `<Space>zr` (run), `<Space>zf` (format)

Getting started (recommended)
1. Clone your dotfiles into `~/.config/nvim` (or point $XDG_CONFIG_HOME to your repo).
2. Start Neovim and let `lazy.nvim` bootstrap itself. Then install plugins: inside Neovim run:

```bash
:Lazy sync
```

3. Open Mason and install language servers/tools (if not auto-installed):

```vim
:Mason
# or
:MasonInstall zls pyright rust-analyzer clangd biome vtsls tailwindcss-language-server
```

4. Verify health and LSP status:

```vim
:checkhealth
```

Key files to know (quick guide)
- `init.lua` — entry point. Bootstraps `lazy.nvim` and loads `core`.
- `lua/core/` — core options, keymaps, autocommands, diagnostics.
- `lua/plugins/` — plugin manifest (split into `plugins/init.lua` + `plugins/core.lua`).
- `lua/configs/merged.lua` — consolidated small feature configs (cmake, copilot, db helpers, treesitter, dap helpers, zig helpers).
- `lua/configs/init.lua` — lazy compatibility layer for legacy `configs.*` requires.
- `lua/configs/ui/` and `lua/configs/lang/` — canonical UI and language-specific configuration modules.

Tweaks & Preferences
- Leader key is set to `<Space>` early in `init.lua`.
- Color scheme: `rose-pine` by default (toggle with `<Space>tt`).
- Formatting: `conform.nvim` is integrated, but falls back to LSP or formatters installed via Mason. Use `<Space>f` to format.

Zig support
- LSP server: `zls` — included in the Mason ensure list.
- Keymaps: `<Space>zb` (build), `<Space>zr` (run current file), `<Space>zf` (format using `zig fmt` or Conform).

Customizing keymaps
- Primary keymaps live in `lua/core/keymaps.lua`.
- Per-language keymaps are added via filetype autocmds (also in `core/keymaps.lua` and `configs.merged.lua`).
- To change a keymap, edit `lua/core/keymaps.lua` or override via your personal layer.

Plugin management
- This config uses `folke/lazy.nvim` (bootstrapped in `init.lua`).
- Add/remove plugins in `lua/plugins/*.lua`. Keep heavy/plugin-specific setup inside their `config` function for lazy loading.

Troubleshooting
- If an LSP server doesn't start, ensure the server is installed via Mason or in your PATH. Example:

```vim
:MasonInstall zls
```

- If a plugin fails to load, run `:Lazy sync` and check `:messages` for errors.
- Use the verbose headless test to spot startup issues:

```bash
nvim --headless -V3/tmp/nvim_startup.log -u ~/.config/nvim/init.lua -c 'lua print("START_OK")' -c qa
# Inspect /tmp/nvim_startup.log if startup fails
```

Contributing & Extending
- Want to add a language integration? Add a file to `lua/configs/lang/` and wire it in via `configs.lsp.servers` or the `configs.merged` helper.
- Prefer smaller modules? Break `configs/merged.lua` into logical files under `lua/configs/` and update `configs.init` mapping.
- Open an issue or PR with a clear description and a small test case.

Maintainer notes (for busy tinkerers)
- Keep plugin `config` functions idempotent and pcall-wrapped to avoid hard failures during startup.
- Avoid requiring heavy modules at top-level; use autocmds and lazy-loading when possible.
- Use `configs.init` proxies temporarily during migrations, then canonicalize to `configs.ui.*` or `configs.lang.*`.

FAQ
Q: How do I add a formatter or linter?
A: Add it to Mason (or install via your system), then configure `configs.tools.formatting` or add a Conform formatter mapping. See `lua/configs/tools/formatting.lua`.

Q: How do I enable a plugin only for a project?
A: Use `lazy.nvim`'s `ft`, `cmd`, or `event` options in `lua/plugins/*.lua`, or use per-project `local.lua` conditional requires.

Q: How do I fully remove compatibility shims?
A: The config uses a lazy proxy layer (`lua/configs/init.lua`) to keep old `require('configs.*')` working; if you want to fully canonicalize, remove the proxy and update all references — I can do that for you.

Credits & Inspiration
- Built on top of ideas from LazyVim, kickstart.nvim, and many community configs.
- Special thanks to plugin authors: folke, williamboman, stevearc, simrat39, and many more.

Enjoy — and if you want, I can:
- Fully remove the lazy compatibility layer and canonicalize every require in the repo,
- Add an automated headless test (CI-ready) that verifies config loads cleanly, or
- Produce a short video-style walkthrough (step-by-step commands) for first-time setup.

Happy hacking!
