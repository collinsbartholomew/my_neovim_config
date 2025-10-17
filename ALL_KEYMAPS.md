# Complete Keymap Reference — Exhaustive, Searchable, and Actionable

This document is the canonical, exhaustive reference for every keymap provided by this Neovim setup. It's organized by category, prefix, and filetype. Use it as a bible when learning or customizing your environment.

How to read this doc
- Leader = `<Space>` (set early in `init.lua`).
- Notation: `<leader>x` means press <Space> then `x`.
- Mode column uses: N = Normal, V = Visual, I = Insert, T = Terminal.
- For per-filetype maps, check the "Where to customize" line at the end of each section.

Quick navigation (jump to section)
- Core navigation & editing
- Files & fuzzy finding (Telescope)
- File explorer (Neo-tree)
- Buffers & windows
- LSP (language server)
- Diagnostics & Trouble
- Formatting & Linting
- Debugging (DAP)
- Git
- Terminal & Tasks
- Harpoon
- Overseer (tasks)
- Testing
- Refactoring
- Sessions
- Database
- Colorizer
- Flash
- Mason
- Utility toggles
- Language-specific keymaps (Go, Rust, Python, JS/TS, C/C++, Java, Zig, Dart/Flutter, Assembly, SQL, Hyprland)

---

CORE NAVIGATION & EDITING
- <C-h> (N) — Move to left window
- <C-j> (N) — Move to down window
- <C-k> (N) — Move to up window
- <C-l> (N) — Move to right window
- <S-h> (N) — Previous buffer
- <S-l> (N) — Next buffer
- <C-s> (N/I) — Save buffer
- <Esc> (N) — Clear search highlight
- <A-j> (N/V) — Move line/selection down
- <A-k> (N/V) — Move line/selection up
- v then p (V) — Paste without yanking (preserve default register)

Where to customize: `lua/core/keymaps.lua`

---

FILES & FUZZY-FINDING (Telescope)
Prefix: `<leader>t` or direct leader mappings
- `<leader>ff` (N) — Find files
- `<leader>fg` (N) — Live grep
- `<leader>fb` (N) — Buffers
- `<leader>fh` (N) — Help tags
- `<leader>tr` (N) — Recent files
- `<leader>tc` (N) — Commands
- `<leader>tk` (N) — Keymaps
- `<leader>ts` (N) — Grep string
- `<leader>tm` (N) — Marks
- `<leader>tj` (N) — Jump list
- `<leader>tq` (N) — Quickfix list
- `<leader>tl` (N) — Location list
- `<leader>tgf` (N) — Git files
- `<leader>tgc` (N) — Git commits
- `<leader>tgb` (N) — Git branches
- `<leader>tgs` (N) — Git status
- `<leader>lr` (N) — LSP references via Telescope
- `<leader>ls` (N) — Document symbols
- `<leader>lw` (N) — Workspace symbols
- `<leader>ld` (N) — Diagnostics (Telescope)

Where to customize: `lua/configs/ui/telescope.lua`

---

FILE EXPLORER (Neo-tree)
Prefix: `<leader>n` and legacy `<leader>e`
- `<leader>e` (N) — Toggle file explorer (legacy alias)
- `<leader>nt` (N) — Toggle tree (synonymous with `<leader>e`)
- `<leader>no` (N) — Open file explorer
- `<leader>nr` (N) — Reveal current file in tree

Where to customize: `lua/configs/ui/neotree.lua`

---

BUFFERS & WINDOWS
- `<leader>bd` (N) — Delete buffer
- `<leader>bn` (N) — Next buffer
- `<leader>bp` (N) — Previous buffer
- `<leader>ba` (N) — Delete all other buffers (keep current)
- `<leader>wv` (N) — Vertical split
- `<leader>wh` (N) — Horizontal split
- `<leader>we` (N) — Equalize window sizes
- `<leader>wx` (N) — Close current window

Where to customize: `lua/core/keymaps.lua`

---

LSP (Language Server Protocol)
Common non-leader LSP keys
- `gd` (N) — Go to definition
- `gD` (N) — Go to declaration
- `gi` (N) — Go to implementation
- `gr` (N) — References (LSP/Telescope)
- `gt` (N) — Go to type definition
- `K` (N) — Hover documentation
- `<C-k>` (N) — Signature help

Leader LSP keys
- `<leader>f` (N/V) — Format (global: Conform -> LSP fallback)
- `<leader>fi` (N) — Format info (Conform)
- `<leader>rn` / `<leader>rename` (N) — Rename symbol
- `<leader>ca` (N) — Code action
- `<leader>lwa` (N) — Add workspace folder
- `<leader>lwr` (N) — Remove workspace folder
- `<leader>lwl` (N) — List workspace folders
- `<leader>lI` (N) — LSP info
- `<leader>lL` (N) — LSP logs
- `<leader>lR` (N) — Restart LSP
- `<leader>lih` (N) — Toggle inlay hints (if supported)
- `<leader>lcl` (N) — Run code lens
- `<leader>lcr` (N) — Refresh code lens
- `<leader>lci` (N) — Incoming calls
- `<leader>lco` (N) — Outgoing calls
- `<leader>lm` (N) — Memory safety diagnostics
- `<leader>lo` (N) — Organize imports
- `<leader>lf` (N) — Format with LSP

Where to customize: `lua/configs/lsp/*` and `lua/configs/lsp/servers.lua` and `lua/configs/lsp/autostart.lua` for autostart behavior

---

DIAGNOSTICS & TROUBLE
- `<leader>df` (N) — Diagnostic float
- `<leader>dn` (N) — Next diagnostic
- `<leader>dp` (N) — Prev diagnostic
- `<leader>dl` (N) — Diagnostics to location list
- `<leader>dq` (N) — Diagnostics to quickfix
- `<leader>dr` (N) — Reset diagnostics (custom helper)
- `<leader>dt` (N) — Toggle diagnostics panel (Trouble)
- `<leader>xx` (N) — Toggle Trouble
- `<leader>xX` (N) — Buffer Diagnostics
- `<leader>cs` (N) — Symbols
- `<leader>so` (N) — Symbols Outline

Where to customize: `lua/configs/ui/trouble.lua` and `lua/core/diagnostics.lua`

---

FORMATTING & LINTING
- `<leader>f` (N/V) — Format (Conform or LSP)
- `<leader>fb` (N) — Format using Biome (JS/TS)
- `<leader>fp` (N) — Format with Prettier (when configured)
- `<leader>fs` (N) — Format with Stylua (Lua)
- `<leader>fr` (N) — Format with rustfmt
- `<leader>fg` (N) — Format with gofmt
- `<leader>fc` (N) — Format with clang-format
- `<leader>fq` (N) — Format SQL with sqlfluff
- `<leader>fi` (N) — Format info
- `<leader>ll` (N) — Run linter (nvim-lint)
- `<leader>li` (N) — Linter info (nvim-lint)
- `<leader>ft` (N) — Toggle format on save

Where to customize: `lua/configs/tools/formatting.lua` and `lua/configs/merged.lua` (lint helpers)

---

DEBUGGING (DAP)
Global DAP mappings
- `<leader>db` (N) — Toggle breakpoint
- `<leader>dB` (N) — Conditional breakpoint (prompt)
- `<leader>dc` (N) — Continue
- `<leader>di` (N) — Step into
- `<leader>do` (N) — Step over
- `<leader>dO` (N) — Step out
- `<leader>dr` (N) — Open REPL
- `<leader>dl` (N) — Run last
- `<leader>dt` (N) — Terminate session
- `<leader>du` (N) — Toggle dap-ui
- `<leader>de` (N/V) — Evaluate expression
- `<leader>dsm` (N) — DAP Memory/Scopes
- `<leader>dsh` (N) — DAP Hover
- `<leader>dsp` (N) — DAP Preview
- `<leader>dL` (N) — Log Point

Per-language DAP setup is in: `lua/configs/dap/*` and `lua/configs/merged.lua` (dap helpers)

Where to customize: `lua/configs/dap/keymaps.lua`

---

GIT
- `<leader>gg` (N) — Open Neogit
- `<leader>gs` (N) — Status
- `<leader>gc` (N) — Commit
- `<leader>gp` (N) — Push
- `<leader>gl` (N) — Log
- `<leader>gd` (N) — Open Diffview
- `<leader>gb` (N) — Git blame
- `<leader>gB` (N) — Toggle line blame
- `<leader>gn` (N) — Next hunk
- `<leader>gN` (N) — Previous hunk
- `<leader>gr` (N) — Reset hunk
- `<leader>gR` (N) — Reset buffer
- `<leader>gS` (N) — Stage hunk
- `<leader>gu` (N) — Unstage hunk
- `<leader>gv` (N) — Preview hunk

Where to customize: `lua/configs/ui/gitsigns.lua` and plugin entries

---

TERMINAL & TASKS
- `<C-\>` (N/T) — Enter/exit terminal mode (toggle)
- `<leader>TA` (N) — Toggle all terminals (toggleterm)
- `<leader>Tf` (N) — Float terminal
- `<leader>Th` (N) — Horizontal terminal
- `<leader>Tv` (N) — Vertical terminal
- `<leader>Tg` (N) — LazyGit in terminal
- `<leader>Tn` (N) — Node REPL
- `<leader>Tp` (N) — Python REPL
- Visual `<leader>Ts` (V) — Send selection to terminal
- `<leader>or` (N) — Run task (Overseer)
- `<leader>ot` (N) — Toggle tasks (Overseer)
- `<leader>oi` (N) — Task info (Overseer)
- `<leader>dm` (N) — Memory check (Valgrind)
- `<leader>da` (N) — ASan check
- `<leader>ds` (N) — Security scan (Trivy)
- `<leader>dt` (N) — Threat scan (Semgrep)

Where to customize: `lua/configs/ui/toggleterm.lua` and Overseer configs

---

HARPOON (Quick files)
- `<leader>a` (N) — Add file to Harpoon
- `<C-e>` (N) — Harpoon menu
- `<C-1..4>` (N) — Jump to harpoon file 1..4

Where to customize: plugin config in `lua/plugins/*`

---

OVERSEER (Task runner)
- `<leader>or` (N) — Run task
- `<leader>ot` (N) — Toggle tasks
- `<leader>oi` (N) — Task info
- Custom templates available under `lua/overseer/template/user`

Where to customize: `lua/plugins` and overseer templates

---

TESTING (neotest)
- `<leader>tn` (N) — Run nearest test
- `<leader>tf` (N) — Run tests for current file
- `<leader>ts` (N) — Toggle test summary
- `<leader>to` (N) — Open test output

Where to customize: `lua/plugins` (neotest), adapters in plugin config

---

REFACTORING
- `<leader>rr` — Open refactor menu
- `<leader>re` — Extract function (visual)
- `<leader>rf` — Extract to file
- `<leader>rv` — Extract variable
- `<leader>ri` — Inline variable

Where to customize: `lua/plugins` (refactoring plugin config)

---

SESSIONS
- `<leader>qs` — Restore session
- `<leader>ql` — Restore last session
- `<leader>qd` — Don't save current session

Where to customize: `lua/plugins` (persistence)

---

DATABASE (dadbod & UI)
- `<leader>Dt` — Toggle DB UI
- `<leader>Df` — Find DB buffer
- `<leader>Dr` — Rename DB buffer
- `<leader>Dl` — Last query info
- `<leader>se` — Execute SQL (SQL file or selection)

Where to customize: `lua/configs/merged.lua` (database helpers) and `lua/configs/database.lua` if present

---

COLORIZER
- `<leader>ct` (N) — Colorizer toggle
- `<leader>cr` (N) — Colorizer reload
- `<leader>uC` (N) — Toggle colorizer (utility toggle)

Where to customize: `lua/configs/ui/colorizer.lua`

---

FLASH
- `s` (N/V/O) — Flash jump
- `S` (N/V/O) — Flash Treesitter
- `<leader>uf` (N) — Toggle flash (utility toggle)

Where to customize: `lua/configs/ui/flash.lua`

---

MASON
- `<leader>mm` (N) — Mason
- `<leader>mi` (N) — Mason install
- `<leader>mu` (N) — Mason update
- `<leader>ml` (N) — Mason log
- `<leader>mt` (N) — Mason tools
- `<leader>mU` (N) — Mason tools update

Where to customize: `lua/configs/tools/mason.lua`

---

UTILITY TOGGLES
- `<leader>tt` (N) — Theme toggle (Rose Pine/Tokyo Night)
- `<leader>tT` (N) — Tab toggle (show/hide tab characters)
- `<leader>ur` (N) — Utility reload (Lazy)
- `<leader>uc` (N) — Utility clean (Lazy)
- `<leader>us` (N) — Utility sync (Lazy)
- `<leader>up` (N) — Utility profile (Lazy)
- `<leader>un` (N) — Dismiss notifications (Noice)
- `<leader>uC` (N) — Toggle colorizer
- `<leader>uf` (N) — Toggle flash

Where to customize: `lua/core/keymaps.lua`

---

LANGUAGE-SPECIFIC KEYMAPS (highlights)
Below are the keymaps added per FileType via autocmds; edit them in `lua/core/keymaps.lua` or the respective `configs.lang.*` file.

GO (`*.go`)
- `<leader>gte` — Go test explorer
- `<leader>gtf` — Test current function
- `<leader>gtp` — Test package
- `<leader>gta` — Test all
- `<leader>gat` — Add Tags
- `<leader>grt` — Remove Tags

RUST (`*.rs`)
- `<leader>rr` — Run
- `<leader>rt` — Test
- `<leader>rb` — Build
- `<leader>rc` — Check
- `<leader>rd` — Docs

PYTHON (`*.py`)
- `<leader>pr` — Run file
- `<leader>pt` — Run pytest
- `<leader>pi` — pip install -r requirements.txt

JS/TS (`*.js`, `*.ts`, `*.jsx`, `*.tsx`)
- `<leader>jr` — Run Node file
- `<leader>jt` — Run tests (npm test)
- `<leader>ji` — npm install
- `<leader>jb` — npm run build
- `<leader>jd` — npm run dev

C/C++ (`*.c`, `*.cpp`, `*.h`, `*.hpp`)
- `<leader>cb` — Build (make)
- `<leader>cr` — Run
- `<leader>cc` — Clean
- `<leader>ct` — Test

ZIG (`*.zig`)
- `<leader>zb` — Zig build (zig build)
- `<leader>zr` — Zig run current file (zig run)
- `<leader>zf` — Zig format (zig fmt or Conform)

DART/FLUTTER (`*.dart`)
- `<leader>fr` — Flutter run
- `<leader>fh` — Hot reload
- `<leader>fR` — Hot restart
- `<leader>fq` — Quit
- `<leader>fd` — Devices

ASSEMBLY
- `<leader>ab` — Assemble
- `<leader>ar` — Run
- `<leader>ad` — Disassemble

SQL
- `<leader>se` — Execute query
- `<leader>ss` — Show schemas
- `<leader>st` — Show tables

HYPRLAND
- `<leader>hr` — Reload config
- `<leader>hk` — Kill window
- `<leader>hi` — Info

---

TROUBLESHOOTING & CUSTOMIZATION
- If a mapping is missing, search for it in `lua/core/keymaps.lua` or the language/ui config files.
- To change a mapping: edit the source file and reload the config with:

```vim
:Lazy reload
```

- To find all mappings containing a key, use Telescope (if installed):

```vim
:lua require('telescope.builtin').keymaps({})
```

---

Appendix: Machine-readable index (copy-paste friendly)
- Core: <C-h>,<C-j>,<C-k>,<C-l>,<C-s>,<A-j>,<A-k>,p
- Leader groups: f(format), t(telescope), n(neotree), g(git), d(debug/diagnostics), l(LSP), T(terminal)

---

If you'd like, I can now:
- Generate a condensed HTML cheat-sheet from this Markdown for printing or quick reference, or
- Add Which-Key registration snippets for each group to make the mappings discoverable in-editor, or
- Produce a small CI job that runs `nvim --headless` to ensure future changes don't break startup.