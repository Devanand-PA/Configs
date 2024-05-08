homedir = os.getenv("HOME")

local PluginToggle = "<C-p>"
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Diagnostic keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

keymap("n", "qr", "q", opts)
keymap("n", "q", "", opts)
keymap("n", "qa", ":qa!<CR>", opts)
keymap("n", "B", ":W<CR>", opts)
keymap("n", "W", ":w<CR>", opts)
keymap("n", "qq", ":bd<CR>", opts)
keymap("n", "wa", ":w<CR>", opts)
keymap("n", "wq", ":wq<CR>", opts)
keymap("n", "<Down>", "gjzz", opts)
keymap("n", "<Up>", "gkzz", opts)
keymap("n", "j", "jzz", opts)
keymap("n", "G", "Gzz", opts)
keymap("n", "<S-Right>", ":bnext<CR>", opts)
keymap("n", "<S-Left>", ":bprevious<CR>", opts)
keymap("n", "w<Left>", "<C-w><Left>", opts)
keymap("n", "w<Right>", "<C-w><Right>", opts)
keymap("n", "w<Up>", "<C-w><Up>", opts)
keymap("n", "w<Down>", "<C-w><Down>", opts)
keymap("n", "bl", ":buffers<CR>", opts)
keymap("n", PluginToggle .. "u", ":UndotreeToggle<CR>", opts)
keymap("n", PluginToggle .. "f", ":NERDTreeToggle<CR>", opts)
keymap("n", PluginToggle .. "m", ":MinimapToggle<CR>", opts)
keymap("n", "ff", ":call fzf#run({'sink':'e','source': 'find'})<CR>", opts)
--keymap("n", "ff", ":Files<CR>",opts)
keymap("n", PluginToggle .. "i", ":setl noai nocin nosi inde=<CR>", opts)

function RunFileType()
	local filetype = vim.bo.filetype
	if filetype == "lua" then
		print("lua")
	elseif filetype == "python" then
		vim.cmd([[
		write
		silent! !st -e python3 % 
		]])
	elseif filetype == "tex" then
		vim.cmd([[
		write
		silent! !pdflatex % 
		silent! !biber % 
		silent! !pdflatex %
		]])
	elseif filetype == "markdown" then
		vim.cmd([[
		write
		silent! !pandoc -i % -o %.pdf
		]])
	end
end

function PipeSelectedTextToCommandWithInput()
	-- Prompt the user for a command
	local command = vim.fn.input("Enter command: ")

	if command ~= "" then
		-- Save the current buffer and window state
		local bufnr = vim.api.nvim_get_current_buf()
		local winnr = vim.api.nvim_get_current_win()

		-- Get the selected text
		local selected_text = vim.api.nvim_buf_get_lines(bufnr, vim.fn.line("'<") - 1, vim.fn.line("'>"), false)

		-- Execute the command with the selected text as input
		local output = vim.fn.systemlist(command, selected_text)

		-- Replace the selected text with the output
		vim.api.nvim_buf_set_lines(bufnr, vim.fn.line("'<") - 1, vim.fn.line("'>"), false, output)

		-- Restore the cursor position
		vim.api.nvim_set_current_win(winnr)
	end
end

vim.api.nvim_set_keymap("n", "<C-s>", ":lua RunFileType()<CR>", opts)
vim.api.nvim_set_keymap("v", "|", ":lua PipeSelectedTextToCommandWithInput()<CR>", opts)
