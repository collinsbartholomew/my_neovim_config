-- added-by-agent: java-setup 20251020-163000
-- mason: jdtls
-- manual: java-debug and vscode-java-test bundle build steps

local M = {}

function M.setup(config)
    config = config or {}

    -- Check if jdtls is available
    local jdtls_status, jdtls = pcall(require, "jdtls")
    if not jdtls_status then
        vim.notify("nvim-jdtls not found. Please install the plugin.", vim.log.levels.WARN)
        return
    end

    local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if not cmp_nvim_lsp_status_ok then
        vim.notify("cmp_nvim_lsp not available", vim.log.levels.WARN)
        return
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Find root directory
    local root_dir = jdtls.setup.find_root({ '.git', 'pom.xml', 'build.gradle', 'settings.gradle', 'mvnw', 'gradlew' })
    if not root_dir then
        vim.notify("Unable to find Java project root directory.", vim.log.levels.WARN)
        return
    end

    -- Setup workspace directory
    local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
    local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
    vim.fn.mkdir(workspace_dir, 'p')

    -- Find Java executable
    local java_exec = nil
    local jdtls_java_home = os.getenv("JDTLS_JAVA_HOME")
    if jdtls_java_home then
        java_exec = jdtls_java_home .. '/bin/java'
    else
        -- Try to find Java 21 or latest available
        local java_paths = {
            '/usr/lib/jvm/java-21-openjdk/bin/java',
            '/usr/lib/jvm/java-17-openjdk/bin/java',
            '/usr/lib/jvm/default/bin/java',
            'java'
        }

        for _, path in ipairs(java_paths) do
            if vim.fn.executable(path) == 1 then
                java_exec = path
                break
            end
        end
    end

    if not java_exec then
        vim.notify("Java executable not found. Please install JDK and set JDTLS_JAVA_HOME.", vim.log.levels.ERROR)
        return
    end

    -- Find JDTLS installation
    local jdtls_path = nil
    local mason_registry_status, mason_registry = pcall(require, "mason-registry")
    if mason_registry_status and mason_registry.is_installed("jdtls") then
        local jdtls_pkg = mason_registry.get_package("jdtls")
        jdtls_path = jdtls_pkg:get_install_path()
    else
        -- Try common installation paths
        local common_paths = {
            '/usr/share/java/jdtls',
            vim.fn.expand('~/.local/share/jdtls'),
        }

        for _, path in ipairs(common_paths) do
            if vim.fn.isdirectory(path) == 1 then
                jdtls_path = path
                break
            end
        end
    end

    if not jdtls_path then
        vim.notify("JDTLS not found. Please install via Mason or manually.", vim.log.levels.ERROR)
        return
    end

    -- Setup bundles from dap module
    local bundles = require('profile.languages.java.dap').get_bundles()

    -- Configure JDTLS
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local config = {
        cmd = {
            java_exec,
            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-noverify',
            '-Xmx1G',
            '--add-modules=ALL-SYSTEM',
            '--add-opens', 'java.base/java.util=ALL-UNNAMED',
            '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
            '-jar', jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar',
            '-configuration', jdtls_path .. '/config_linux',
            '-data', workspace_dir
        },
        root_dir = root_dir,
        settings = {
            java = {
                eclipse = {
                    downloadSources = true
                },
                configuration = {
                    updateBuildConfiguration = "interactive"
                },
                maven = {
                    downloadSources = true
                },
                implementationsCodeLens = {
                    enabled = true
                },
                referencesCodeLens = {
                    enabled = true
                },
                references = {
                    includeDecompiledSources = true
                },
                format = {
                    enabled = true,
                    settings = {
                        url = vim.fn.stdpath("config") .. "/lua/profile/languages/java/formatter.xml",
                        profile = "GoogleStyle"
                    }
                },
                signatureHelp = {
                    enabled = true
                },
                contentProvider = {
                    preferred = "fernflower"
                },
                completion = {
                    favoriteStaticMembers = {
                        "org.hamcrest.MatcherAssert.assertThat",
                        "org.hamcrest.Matchers.*",
                        "org.hamcrest.CoreMatchers.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                        "org.mockito.Mockito.*"
                    }
                },
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999
                    }
                },
                codeGeneration = {
                    toString = {
                        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                    },
                    useBlocks = true
                }
            }
        },
        init_options = {
            bundles = bundles,
            extendedClientCapabilities = extendedClientCapabilities
        },
        on_attach = function(client, bufnr)
            -- Buffer local mappings
            local function buf_set_keymap(...)
                vim.api.nvim_buf_set_keymap(bufnr, ...)
            end
            local opts = { noremap = true, silent = true }

            buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            buf_set_keymap('n', '<space>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            buf_set_keymap('n', '<space>f', '<Cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
            buf_set_keymap('n', '<space>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
            buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap('n', '<space>q', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts)

            -- JDTLS specific mappings
            buf_set_keymap('n', '<leader>jo', '<Cmd>lua require(\'jdtls\').organize_imports()<CR>', opts)
            buf_set_keymap('n', '<leader>jv', '<Cmd>lua require(\'jdtls\').extract_variable()<CR>', opts)
            buf_set_keymap('n', '<leader>jc', '<Cmd>lua require(\'jdtls\').extract_constant()<CR>', opts)
            buf_set_keymap('v', '<leader>jm', '<Esc><Cmd>lua require(\'jdtls\').extract_method(true)<CR>', opts)
            buf_set_keymap('n', '<leader>jt', '<Cmd>lua require(\'jdtls\').test_class()<CR>', opts)
            buf_set_keymap('n', '<leader>jT', '<Cmd>lua require(\'jdtls\').test_nearest_method()<CR>', opts)
            buf_set_keymap('n', '<leader>ju', '<Cmd>lua require(\'jdtls\').update_project_config()<CR>', opts)
            buf_set_keymap('n', '<leader>jp', '<Cmd>lua require(\'jdtls\').jol()<CR>', opts)

            -- Enable inlay hints if available
            pcall(function()
                if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint(bufnr, true)
                end
            end)

            -- Format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })
            end

            -- Enable code lens if supported
            if client.server_capabilities.codeLensProvider then
                vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.codelens.refresh()
                    end,
                })
            end

            -- Register language specific keymaps
            require("profile.languages.java.mappings").lsp(bufnr)
        end,
        capabilities = capabilities
    }

    -- Start JDTLS
    jdtls.start_or_attach(config)

    -- Create restart command
    vim.api.nvim_create_user_command('JavaRestartServer', function()
        vim.cmd('LspRestart jdtls')
    end, {})
end

return M