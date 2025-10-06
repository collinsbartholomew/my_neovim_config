# Complete Keybindings Reference

## 🚀 Core Navigation & File Management

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>ff` | Normal | `Telescope find_files` | Find files in project |
| `<leader>fg` | Normal | `Telescope live_grep` | Live grep search |
| `<leader>fb` | Normal | `Telescope buffers` | List open buffers |
| `<leader>fh` | Normal | `Telescope help_tags` | Search help documentation |
| `<leader>e` | Normal | `Neotree toggle` | Toggle file explorer |
| `<leader>q` | Normal | `qa` | Quit all windows |

## 📁 Buffer Management

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<S-h>` | Normal | `bprevious` | Previous buffer |
| `<S-l>` | Normal | `bnext` | Next buffer |
| `<leader>bd` | Normal | `bdelete` | Delete current buffer |

## 🪟 Window Navigation

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<C-h>` | Normal | `<C-w>h` | Go to left window |
| `<C-j>` | Normal | `<C-w>j` | Go to lower window |
| `<C-k>` | Normal | `<C-w>k` | Go to upper window |
| `<C-l>` | Normal | `<C-w>l` | Go to right window |

## 💾 File Operations

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<C-s>` | Normal | `w` | Save file |
| `<C-s>` | Insert | `<Esc>w<cr>a` | Save file (from insert mode) |
| `<Esc>` | Normal | `nohlsearch` | Clear search highlighting |
| `<Esc>` | Terminal | `<C-\><C-n>` | Exit terminal mode |

## ✏️ Text Editing & Movement

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<` | Visual | `<gv` | Indent left (keep selection) |
| `>` | Visual | `>gv` | Indent right (keep selection) |
| `<A-j>` | Normal | `m .+1<cr>==` | Move line down |
| `<A-k>` | Normal | `m .-2<cr>==` | Move line up |
| `<A-j>` | Visual | `:m '>+1<cr>gv=gv` | Move selection down |
| `<A-k>` | Visual | `:m '<-2<cr>gv=gv` | Move selection up |
| `gc` | Normal/Visual | Comment toggle | Toggle line/block comments |
| `gb` | Visual | Block comment | Toggle block comments |

## 🔧 LSP Core Features

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `gd` | Normal | `vim.lsp.buf.definition` | Go to definition |
| `gD` | Normal | `vim.lsp.buf.declaration` | Go to declaration |
| `gi` | Normal | `vim.lsp.buf.implementation` | Go to implementation |
| `gr` | Normal | `vim.lsp.buf.references` | Find references |
| `K` | Normal | `vim.lsp.buf.hover` | Show hover documentation |
| `<C-k>` | Normal | `vim.lsp.buf.signature_help` | Show signature help |
| `<leader>rn` | Normal | `vim.lsp.buf.rename` | Rename symbol |
| `<leader>ca` | Normal | `vim.lsp.buf.code_action` | Show code actions |
| `<leader>f` | Normal | `vim.lsp.buf.format` | Format document |

## 🚀 Advanced LSP Features

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>ws` | Normal | `vim.lsp.buf.workspace_symbol` | Search workspace symbols |
| `<leader>wa` | Normal | `vim.lsp.buf.add_workspace_folder` | Add workspace folder |
| `<leader>wr` | Normal | `vim.lsp.buf.remove_workspace_folder` | Remove workspace folder |
| `<leader>ih` | Normal | Toggle inlay hints | Toggle parameter/type hints (buffer-specific) |
| `<leader>lh` | Normal | Toggle inlay hints | Toggle inlay hints (global) |
| `<leader>cl` | Normal | `vim.lsp.codelens.run` | Run code lens action |
| `<leader>cr` | Normal | `vim.lsp.codelens.refresh` | Refresh code lens |

## 🌳 Call & Type Hierarchy

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>ci` | Normal | `vim.lsp.buf.incoming_calls` | Show incoming calls |
| `<leader>co` | Normal | `vim.lsp.buf.outgoing_calls` | Show outgoing calls |
| `<leader>st` | Normal | Type hierarchy supertypes | Show supertypes (safe) |
| `<leader>it` | Normal | Type hierarchy subtypes | Show subtypes (safe) |

## 🩺 Diagnostics

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>df` | Normal | `vim.diagnostic.open_float` | Show diagnostic float |
| `[d` | Normal | `vim.diagnostic.goto_prev` | Go to previous diagnostic |
| `]d` | Normal | `vim.diagnostic.goto_next` | Go to next diagnostic |
| `<leader>dl` | Normal | `vim.diagnostic.setloclist` | Add diagnostics to location list |

## 🔄 LSP Management

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>lR` | Normal | Refresh all LSP | Refresh workspace, codelens, inlay hints |
| `<leader>lr` | Normal | Refresh LSP features | Refresh buffer-specific LSP features |

## 🎨 Language-Specific Features

### Supported Languages
**Core**: Lua, JavaScript/TypeScript, HTML, CSS, JSON, YAML, Bash  
**Web Stack**: TailwindCSS, Biome, Emmet, TypeScript Tools  
**Systems**: Rust, Go, C/C++, Assembly (ARM/GAS/NASM)  
**Enterprise**: Java, Kotlin, PHP, Python  
**Database**: SQL, Prisma  
**Mobile**: Dart/Flutter  
**Other**: Zig, Vim script

### Assembly Development
| Feature | Description |
|---------|-------------|
| **Syntax Support** | ARM, GAS, NASM syntax highlighting |
| **LSP Integration** | asm-lsp with formatting support |
| **Indentation** | Smart assembly-specific indentation |

## 🔍 Telescope LSP Integration

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>lr` | Normal | `Telescope lsp_references` | LSP references in Telescope |
| `<leader>ls` | Normal | `Telescope lsp_document_symbols` | Document symbols |
| `<leader>lw` | Normal | `Telescope lsp_workspace_symbols` | Workspace symbols |
| `<leader>ld` | Normal | `Telescope diagnostics` | Show diagnostics |

## 🎯 Trouble.nvim Integration

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>xx` | Normal | `Trouble diagnostics toggle` | Toggle diagnostics list |
| `<leader>xX` | Normal | `Trouble diagnostics toggle filter.buf=0` | Buffer diagnostics |
| `<leader>cs` | Normal | `Trouble symbols toggle focus=false` | Toggle symbols list |

## ⚡ Flash Navigation

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `s` | Normal/Visual/Operator | Flash jump | Quick jump to location |
| `S` | Normal/Visual/Operator | Flash treesitter | Treesitter-aware jump |

## 🌿 Git Integration

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>gs` | Normal | `Git` | Git status |
| `<leader>gc` | Normal | `Git commit` | Git commit |
| `<leader>gp` | Normal | `Git push` | Git push |
| `<leader>gd` | Normal | `DiffviewOpen` | Open git diff view |
| `<leader>gh` | Normal | `DiffviewFileHistory` | File git history |
| `<leader>gg` | Normal | `Neogit` | Open Neogit |

## 🎵 Harpoon Quick Navigation

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>a` | Normal | Add file to Harpoon | Mark file for quick access |
| `<C-e>` | Normal | Harpoon quick menu | Show marked files |
| `<C-1>` | Normal | Harpoon file 1 | Jump to first marked file |
| `<C-2>` | Normal | Harpoon file 2 | Jump to second marked file |
| `<C-3>` | Normal | Harpoon file 3 | Jump to third marked file |
| `<C-4>` | Normal | Harpoon file 4 | Jump to fourth marked file |

## 💾 Session Management

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>qs` | Normal | Restore session | Load last session |
| `<leader>ql` | Normal | Restore last session | Load previous session |
| `<leader>qd` | Normal | Don't save session | Skip saving current session |

## 🔧 Utility Functions

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>tt` | Normal | Toggle tab visualization | Show/hide tab characters |
| `<leader>so` | Normal | `SymbolsOutline` | Toggle symbols outline |
| `<C-\\>` | Normal | `ToggleTerm` | Toggle terminal |

## 📝 Text Manipulation

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `ys{motion}{char}` | Normal | Surround add | Add surrounding characters |
| `ds{char}` | Normal | Surround delete | Delete surrounding characters |
| `cs{old}{new}` | Normal | Surround change | Change surrounding characters |
| `S{char}` | Visual | Surround visual | Surround visual selection |

## 📝 Completion (Insert Mode)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<C-Space>` | Insert | Trigger completion | Manual completion trigger |
| `<Tab>` | Insert | Next completion/snippet | Navigate completion or expand snippet |
| `<S-Tab>` | Insert | Previous completion/snippet | Navigate back in completion |
| `<CR>` | Insert | Confirm completion | Accept selected completion |
| `<C-e>` | Insert | Abort completion | Cancel completion menu |
| `<C-b>` | Insert | Scroll docs up | Scroll completion docs |
| `<C-f>` | Insert | Scroll docs down | Scroll completion docs |

## 🎯 Context-Aware Features

### React/TypeScript Development
- **LSP Integration**: TypeScript Tools + Emmet + TailwindCSS
- **Snippet**: `rfc` → React functional component with TypeScript
- **Snippet**: `us` → useState hook with TypeScript types
- **Snippet**: `ue` → useEffect hook with dependencies
- **Snippet**: `napi` → Next.js API route handler

### Database Development
- **LSP Integration**: Prisma + SQL LSP + Dadbod UI
- **Snippet**: `selj` → SELECT with JOIN statement
- **Snippet**: `ct` → CREATE TABLE with common columns
- **Snippet**: `ins` → INSERT INTO statement

### Systems Programming
- **Rust**: Full rust-analyzer integration with inlay hints
- **Go**: gopls with goimports and staticcheck
- **C/C++**: Clangd with clang-tidy and header insertion
- **Assembly**: ARM/GAS/NASM syntax + asm-lsp

### Web Development Stack
- **TailwindCSS**: Context-aware completions with custom regex patterns
- **Biome**: Integrated formatting and linting for JS/TS
- **Emmet**: HTML/CSS expansions with React support
- **CSS Colors**: Live color preview and picker integration

## 📊 Development Metrics

### LSP Servers Configured: 20+
- **Web**: 7 servers (HTML, CSS, JS/TS, Tailwind, JSON, YAML, Emmet)
- **Systems**: 5 servers (Rust, Go, C/C++, Assembly, Zig)
- **Enterprise**: 4 servers (Java, Kotlin, PHP, Python)
- **Database**: 2 servers (SQL, Prisma)
- **Other**: 3 servers (Lua, Bash, Dart)

### Plugin Count: 50+ optimized plugins
- **Lazy Loading**: Event-driven and command-based loading
- **Startup Time**: Optimized for fast boot with deferred loading
- **Memory Usage**: Efficient with conditional plugin activation suggests classes in `className` attributes
- **Auto-Sort**: `<leader>lt` sorts Tailwind classes

## 🚀 Performance Features

- **Debounced Git Blame**: 1-second delay prevents excessive calls
- **Context-Aware Completions**: Reduces noise, improves relevance
- **Lazy Loading**: Plugins load only when needed
- **Optimized LSP**: Single unified configuration prevents conflicts

---

**Note**: `<leader>` is typically mapped to `Space` key. All keybindings are optimized for professional development workflow with minimal finger movement and maximum efficiency.