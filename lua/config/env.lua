-- Load secrets from <config>/.env into the process environment.
--
-- Used for API keys (e.g. GROQ_API_KEY) consumed by AI plugins. The file is
-- gitignored; variables already present in the environment are never
-- overridden, so a shell-level export still wins.
--
-- Format: one KEY=value per line, `#` comments and blank lines ignored,
-- optional surrounding single/double quotes on the value.

local env_file = vim.fs.joinpath(vim.fn.stdpath('config'), '.env')

if vim.uv.fs_stat(env_file) == nil then return end

local ok, lines = pcall(vim.fn.readfile, env_file)
if not ok then
  vim.notify('config.env: could not read ' .. env_file, vim.log.levels.WARN)
  return
end

for _, line in ipairs(lines) do
  line = vim.trim(line)
  if line ~= '' and not line:match('^#') then
    local key, value = line:match('^export%s+([%w_]+)%s*=%s*(.*)$')
    if not key then
      key, value = line:match('^([%w_]+)%s*=%s*(.*)$')
    end
    if key then
      -- Strip matching surrounding quotes
      value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
      if vim.env[key] == nil then
        vim.env[key] = value
      end
    end
  end
end
