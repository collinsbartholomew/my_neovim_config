-- PHP debugging configuration
local M = {}

function M.setup()
    -- Setup PHP debugging with nvim-dap
    local status_ok, dap = pcall(require, "dap")
    if not status_ok then
        return
    end
    
    -- Configure PHP debug adapter
    dap.adapters.php = {
        type = "executable",
        command = "php-debug-adapter",
        args = { }
    }
    
    -- Configure PHP debug configurations
    dap.configurations.php = {
        {
            type = "php",
            request = "launch",
            name = "Listen for Xdebug",
            port = 9003,
            log = true,
            pathMappings = {
                ["/var/www/html"] = "${workspaceFolder}"
            }
        },
        {
            type = "php",
            request = "launch",
            name = "Launch Built-in Server",
            program = "index.php",
            cwd = "${workspaceFolder}",
            port = 9003,
            runtimeArgs = {
                "-dxdebug.mode=debug",
                "-dxdebug.start_with_request=yes",
                "-S",
                "localhost:8080"
            },
            env = {
                PHP_IDE_CONFIG = "serverName=localhost"
            }
        }
    }
end

return M