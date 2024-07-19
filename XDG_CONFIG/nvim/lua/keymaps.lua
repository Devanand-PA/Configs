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

keymap("n", "<C-Left>", ":vertical resize +3<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -3<CR>", opts)
keymap("n", "<C-Up>", ":resize +3<CR>", opts)
keymap("n", "<C-Down>", ":resize -3<CR>", opts)
keymap("n", "rf", ":r !find | dmenu -i -l 40<CR>", opts)
keymap("n", "qr", "q", opts)
keymap("n", "T", ":15split | :terminal<CR>", opts)
keymap("n", "q", "", opts)
keymap("n", "qa", ":qa!<CR>", opts)
keymap("n", "B", ":W<CR>", opts)
keymap("n", "W", ":w<CR>", opts)
keymap("n", "ww", ":w<CR>", opts)
keymap("n", "<C-t>", ":tabnew<CR>", opts)
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
keymap("n", "<C-f>", ":call fzf#run({'sink':'e','source': 'find'})<CR>", opts)
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

function ExpandToSelection()
	-- Get the position of the start and end of the selection
	local start_line = vim.fn.getpos("'<")[2]
	local end_line = vim.fn.getpos("'>")[2]
	local start_col = vim.fn.getpos("'<")[3]
	local end_col = vim.fn.getpos("'>")[3]

	-- Get the lines containing the selection
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- If selection spans multiple lines, adjust the last line's column
	if start_line ~= end_line then
		end_col = #lines[#lines] + 1
	end

	-- Concatenate the lines to get the selected text
	local selected_text = table.concat(lines, "\n"):sub(start_col, end_col)

	return selected_text
end

function PrintSelected()
	local selected_text = ExpandToSelection()
	if selected_text then
		print(selected_text)
	else
		print("No text selected")
	end
end

local function is_text_file(filepath)
	-- Extract the file extension
	local ext = string.match(filepath, "%.([^%.]+)$")

	-- List of common text file extensions
	local text_extensions = {
		"txt",
		"md",
		"markdown",
		"lua",
		"c",
		"cpp",
		"h",
		"hpp",
		"py",
		"rb",
		"sh",
		"html",
		"css",
		"js",
		"json",
		-- Add more extensions as needed
	}

	-- Check if the extension is in the list of text file extensions
	for _, text_ext in ipairs(text_extensions) do
		if ext == text_ext then
			return true -- File is a text file
		end
	end

	return false -- File is not a text file
end

function OpenFileWithSelectedText()
	-- Get the selected text
	local selected_text = ExpandToSelection()
	selected_text = vim.fn.expand(selected_text)
	if is_text_file(selected_text) then
		vim.cmd(":e " .. selected_text)
	else
		vim.cmd('!xdg-open "' .. selected_text .. '" &')
	end -- Check the result of the command
end

vim.api.nvim_set_keymap("n", "<C-s>", ":lua RunFileType()<CR>", opts)
vim.api.nvim_set_keymap("v", "|", ":!", opts)

vim.keymap.set("v", "f", ":lua OpenFileWithSelectedText()<CR>")
vim.api.nvim_set_keymap("n", '"o', 'vi":lua OpenFileWithSelectedText()<CR><C-l>', { noremap = true })
vim.api.nvim_set_keymap("n", "'o", "vi':lua OpenFileWithSelectedText()<CR><C-l>", { noremap = true })
vim.api.nvim_set_keymap("n", ")o", "vi):lua OpenFileWithSelectedText()<CR><C-l>", { noremap = true })
