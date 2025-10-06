-- Enhanced LSP progress reporting
local M = {}

local progress_clients = {}

-- Progress handler with modern API
local function progress_handler(_, result, ctx)
	local client_id = ctx.client_id
	local client = vim.lsp.get_client_by_id(client_id)
	if not client then
		return
	end

	local token = result.token
	local value = result.value

	if not progress_clients[client_id] then
		progress_clients[client_id] = {}
	end

	if value.kind == "begin" then
		progress_clients[client_id][token] = {
			title = value.title,
			message = value.message,
			percentage = value.percentage,
		}

		-- Show notification for significant operations
		if value.title and (value.title:match("Indexing") or value.title:match("Loading")) then
			vim.notify(string.format("%s: %s", client.name, value.title), vim.log.levels.INFO, {
				title = "LSP Progress",
				timeout = 1000,
			})
		end
	elseif value.kind == "report" then
		if progress_clients[client_id][token] then
			progress_clients[client_id][token].message = value.message
			progress_clients[client_id][token].percentage = value.percentage
		end
	elseif value.kind == "end" then
		if progress_clients[client_id][token] then
			local task = progress_clients[client_id][token]
			if task.title and (task.title:match("Indexing") or task.title:match("Loading")) then
				vim.notify(string.format("%s: %s completed", client.name, task.title), vim.log.levels.INFO, {
					title = "LSP Progress",
					timeout = 500,
				})
			end
		end
		progress_clients[client_id][token] = nil
	end
end

-- Setup progress handler
vim.lsp.handlers["$/progress"] = progress_handler

-- Function to get current progress for statusline
function M.get_progress()
	local messages = {}
	for client_id, tokens in pairs(progress_clients) do
		local client = vim.lsp.get_client_by_id(client_id)
		if client then
			for _, progress in pairs(tokens) do
				local msg = string.format("%s", client.name)
				if progress.percentage then
					msg = msg .. string.format(" %d%%", progress.percentage)
				end
				if progress.message then
					msg = msg .. string.format(" %s", progress.message)
				end
				table.insert(messages, msg)
			end
		end
	end
	return table.concat(messages, " | ")
end

return M

