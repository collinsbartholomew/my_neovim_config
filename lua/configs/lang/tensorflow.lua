local M = {}

function M.setup()
	-- TensorFlow C/C++ and Python Development Support
	-- TensorFlow C++ project detection
	local tf_patterns = {
		'tensorflow/**/*.cc',
		'tensorflow/**/*.h',
		'**/BUILD',
		'WORKSPACE',
		'*.bzl'
	}

	vim.api.nvim_create_autocmd('BufRead', {
		pattern = tf_patterns,
		callback = function()
			vim.b.clangd_extra_flags = {
				'-std=c++17',
				'-DTF_LITE_STATIC_MEMORY',
				'-DTENSORFLOW_LITE_MCU_DEBUG_LOG',
				'-I/usr/local/include/tensorflow',
				'-I/usr/local/include/eigen3',
			}
			vim.notify('TensorFlow C++ project detected', vim.log.levels.INFO)
		end,
	})

	-- Python TensorFlow/ML environment detection
	vim.api.nvim_create_autocmd('BufRead', {
		pattern = '*.py',
		callback = function()
			local lines = vim.api.nvim_buf_get_lines(0, 0, math.min(50, vim.api.nvim_buf_line_count(0)), false)
			local tf_imports = {
				'import tensorflow',
				'import torch',
				'import keras',
				'import numpy',
				'import pandas',
				'import sklearn',
				'from tensorflow',
				'from torch',
				'from keras'
			}
			for _, line in ipairs(lines) do
				for _, pattern in ipairs(tf_imports) do
					if line:match(pattern) then
						vim.b.is_ml_project = true
						vim.opt_local.colorcolumn = '88'
						return
					end
				end
			end
		end,
	})

	-- TensorFlow-specific keymaps
	vim.keymap.set('n', '<leader>tf', function()
		local filetype = vim.bo.filetype
		if filetype == 'python' then
			vim.cmd('terminal python -c "import tensorflow as tf; print(f\\\"TensorFlow version: {tf.__version__}\\\")"')
		elseif filetype == 'cpp' or filetype == 'c' then
			vim.cmd('terminal bazel build //tensorflow/...')
		end
	end, { desc = 'TensorFlow build/test' })
end

return M

