-- Indent guides and highlights of the word under the cursor. Other snacks
-- modules stay off: their jobs are covered by telescope, fidget and friends.

local ok, snacks = pcall(require, 'snacks')
if not ok then return end

snacks.setup({
  indent = { enabled = true },
  words = { enabled = true },
})
