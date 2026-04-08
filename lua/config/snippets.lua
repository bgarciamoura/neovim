-- Custom snippets using vim.snippet (built-in)
-- Trigger: type the prefix and press <C-l> to expand

local snippets = {
  typescript = {
    ['fn'] = 'function ${1:name}(${2:params}): ${3:void} {\n\t$0\n}',
    ['afn'] = 'const ${1:name} = (${2:params})${3: => {\n\t$0\n\\}}',
    ['imp'] = "import { $1 } from '${2:module}'$0",
    ['impt'] = "import type { $1 } from '${2:module}'$0",
    ['us'] = 'const [${1:state}, set${2:State}] = useState($3)$0',
    ['ue'] = 'useEffect(() => {\n\t$0\n}, [${1:deps}])',
    ['cl'] = 'console.log($0)',
    ['trycatch'] = 'try {\n\t$1\n} catch (${2:error}) {\n\t$0\n}',
  },
  typescriptreact = 'typescript', -- inherit from typescript
  javascript = 'typescript',
  javascriptreact = 'typescript',

  python = {
    ['def'] = 'def ${1:name}(${2:self}${3:, params}):\n\t${0:pass}',
    ['cls'] = 'class ${1:Name}:\n\tdef __init__(self${2:, params}):\n\t\t${0:pass}',
    ['ifmain'] = "if __name__ == '__main__':\n\t${0:pass}",
    ['fori'] = 'for ${1:i} in ${2:range(n)}:\n\t$0',
    ['with'] = 'with ${1:expression} as ${2:var}:\n\t$0',
    ['lc'] = '[${1:x} for ${2:x} in ${3:iterable}]$0',
    ['impnp'] = 'import numpy as np',
    ['imppd'] = 'import pandas as pd',
    ['impplt'] = 'import matplotlib.pyplot as plt',
    ['trycatch'] = 'try:\n\t$1\nexcept ${2:Exception} as ${3:e}:\n\t$0',
  },

  dart = {
    ['stl'] = 'class ${1:Name} extends StatelessWidget {\n\tconst ${1:Name}({super.key});\n\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn ${0:Container()};\n\t}\n}',
    ['stf'] = 'class ${1:Name} extends StatefulWidget {\n\tconst ${1:Name}({super.key});\n\n\t@override\n\tState<${1:Name}> createState() => _${1:Name}State();\n}\n\nclass _${1:Name}State extends State<${1:Name}> {\n\t@override\n\tWidget build(BuildContext context) {\n\t\treturn ${0:Container()};\n\t}\n}',
    ['build'] = '@override\nWidget build(BuildContext context) {\n\treturn ${0:Container()};\n}',
    ['init'] = '@override\nvoid initState() {\n\tsuper.initState();\n\t$0\n}',
  },

  lua = {
    ['fn'] = 'function ${1:name}(${2:params})\n\t$0\nend',
    ['lfn'] = 'local function ${1:name}(${2:params})\n\t$0\nend',
    ['req'] = "local ${1:mod} = require('${2:module}')",
    ['if'] = 'if ${1:cond} then\n\t$0\nend',
  },
}

-- Resolve inheritance (e.g., typescriptreact -> typescript)
local function get_snippets(ft)
  local ft_snippets = snippets[ft]
  if type(ft_snippets) == 'string' then
    return snippets[ft_snippets] or {}
  end
  return ft_snippets or {}
end

-- Get word before cursor
local function get_word_before_cursor()
  local col = vim.fn.col('.') - 1
  if col == 0 then return '' end
  local line = vim.api.nvim_get_current_line()
  local word_start = col
  while word_start > 0 and line:sub(word_start, word_start):match('[%w_]') do
    word_start = word_start - 1
  end
  return line:sub(word_start + 1, col)
end

-- Expand snippet at cursor
vim.keymap.set('i', '<C-l>', function()
  local word = get_word_before_cursor()
  local ft_snippets = get_snippets(vim.bo.filetype)

  if ft_snippets[word] then
    -- Delete the trigger word
    local col = vim.fn.col('.')
    local row = vim.fn.line('.') - 1
    vim.api.nvim_buf_set_text(0, row, col - #word - 1, row, col - 1, {})
    -- Expand the snippet
    vim.snippet.expand(ft_snippets[word])
  end
end, { desc = 'Expand snippet' })
