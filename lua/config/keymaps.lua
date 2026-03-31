local map = vim.keymap.set

-- ============================================================================
-- Core keymaps (no plugin dependency)
-- ============================================================================

-- Exit insert mode with jk
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Quit Neovim
map("n", "<C-q>", "<cmd>qa<cr>", { desc = "Quit Neovim" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Save file
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save file" })

-- Navigate splits
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Stay in visual mode after indent
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move to left split" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move to lower split" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move to upper split" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move to right split" })

-- ============================================================================
-- Find (Telescope) <leader>f
-- ============================================================================

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Todo comments" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Grep word under cursor" })

-- ============================================================================
-- Explorer (Neo-tree) <leader>e
-- ============================================================================

map("n", "<leader>ee", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer" })
map("n", "<leader>ef", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file" })
map("n", "<leader>eg", "<cmd>Neotree git_status<cr>", { desc = "Git status" })
map("n", "<leader>eb", "<cmd>Neotree buffers<cr>", { desc = "Buffers" })

-- ============================================================================
-- LSP <leader>l
-- ============================================================================

map("n", "<leader>ld", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
map("n", "<leader>ln", function() vim.lsp.buf.rename() end, { desc = "Rename" })
map("n", "<leader>la", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
map("n", "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lh", function() vim.lsp.buf.hover() end, { desc = "Hover" })
map("n", "<leader>ls", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
map("n", "<leader>ll", function() vim.diagnostic.open_float() end, { desc = "Line diagnostics" })

-- Diagnostics navigation (non-leader)
map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Previous diagnostic" })

-- ============================================================================
-- Git <leader>g
-- ============================================================================

map("n", "<leader>gg", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
    end,
  })
  lazygit:toggle()
end, { desc = "Lazygit" })

map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle blame" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })

-- Hunk navigation (non-leader)
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous hunk" })

-- ============================================================================
-- Debug <leader>d
-- ============================================================================

map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step into" })
map("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step over" })
map("n", "<leader>dO", function() require("dap").step_out() end, { desc = "Step out" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
map("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run last" })
map("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })

-- ============================================================================
-- Terminal <leader>t
-- ============================================================================

map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })

-- ============================================================================
-- Tests (neotest) <leader>n
-- ============================================================================

map("n", "<leader>nr", function() require("neotest").run.run() end, { desc = "Run nearest test" })
map("n", "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
map("n", "<leader>ns", function() require("neotest").run.run({ suite = true }) end, { desc = "Run test suite" })
map("n", "<leader>no", function() require("neotest").output.open({ enter = true }) end, { desc = "Open output" })
map("n", "<leader>nS", function() require("neotest").summary.toggle() end, { desc = "Toggle summary" })
map("n", "<leader>nw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, { desc = "Watch file" })

-- ============================================================================
-- Run (Bruno + Overseer) <leader>r
-- ============================================================================

map("n", "<leader>rb", "<cmd>BrunoRun<cr>", { desc = "Bruno run" })
map("n", "<leader>re", "<cmd>BrunoEnv<cr>", { desc = "Bruno environment" })
map("n", "<leader>rs", "<cmd>BrunoSearch<cr>", { desc = "Bruno search" })
map("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Overseer toggle" })
map("n", "<leader>rr", "<cmd>OverseerRun<cr>", { desc = "Overseer run" })

-- ============================================================================
-- Session <leader>s
-- ============================================================================

map("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "Save session" })
map("n", "<leader>sr", "<cmd>SessionRestore<cr>", { desc = "Restore session" })
map("n", "<leader>sd", "<cmd>SessionDelete<cr>", { desc = "Delete session" })

-- ============================================================================
-- Buffers <leader>b
-- ============================================================================

map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bD", "<cmd>%bdelete<cr>", { desc = "Delete all buffers" })

-- ============================================================================
-- Markdown <leader>m
-- ============================================================================

map("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview" })
map("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop preview" })
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle render" })

-- ============================================================================
-- Notebook (Molten) <leader>o
-- ============================================================================

map("n", "<leader>oi", "<cmd>MoltenInit<cr>", { desc = "Initialize Molten" })
map("n", "<leader>or", "<cmd>MoltenEvaluateOperator<cr>", { desc = "Evaluate operator" })
map("v", "<leader>or", ":<C-u>MoltenEvaluateVisual<cr>gv", { desc = "Evaluate visual" })
map("n", "<leader>ol", "<cmd>MoltenEvaluateLine<cr>", { desc = "Evaluate line" })
map("n", "<leader>oa", "<cmd>MoltenReevaluateAll<cr>", { desc = "Re-evaluate all" })
map("n", "<leader>on", "<cmd>MoltenNext<cr>", { desc = "Next cell" })
map("n", "<leader>op", "<cmd>MoltenPrev<cr>", { desc = "Previous cell" })
map("n", "<leader>od", "<cmd>MoltenDelete<cr>", { desc = "Delete cell" })

-- ============================================================================
-- Docker <leader>k
-- ============================================================================

map("n", "<leader>kl", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazydocker = Terminal:new({
    cmd = "lazydocker",
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
    end,
  })
  lazydocker:toggle()
end, { desc = "LazyDocker" })
