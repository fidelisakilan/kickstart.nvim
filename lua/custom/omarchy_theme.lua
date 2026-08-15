local M = {}

local SPEC_PATH = vim.fn.expand '~/.local/state/omarchy/current/theme/neovim.lua'

local function module_name(entry)
  if entry.name then
    return entry.name
  end
  return (entry[1]:match '([^/]+)$'):gsub('%.nvim$', ''):gsub('%-nvim$', '')
end

local function repo_url(repo)
  return 'https://github.com/' .. repo .. '.git'
end

function M.apply()
  if vim.fn.filereadable(SPEC_PATH) == 0 then
    return false
  end

  local ok, spec = pcall(dofile, SPEC_PATH)
  if not ok or type(spec) ~= 'table' then
    return false
  end

  local colorscheme
  for _, entry in ipairs(spec) do
    if entry[1] == 'LazyVim/LazyVim' then
      colorscheme = entry.opts and entry.opts.colorscheme
    end
  end
  if not colorscheme then
    return false
  end

  vim.cmd 'highlight clear'
  if vim.fn.exists 'syntax_on' == 1 then
    vim.cmd 'syntax reset'
  end
  vim.o.background = 'dark' -- light themes set this themselves on apply

  for _, entry in ipairs(spec) do
    if entry[1] and entry[1] ~= 'LazyVim/LazyVim' then
      for _, dep in ipairs(entry.dependencies or {}) do
        pcall(vim.pack.add, { repo_url(dep) })
      end
      pcall(vim.pack.add, { repo_url(entry[1]) })

      if entry.config then
        pcall(entry.config)
      elseif entry.opts then
        pcall(function() require(module_name(entry)).setup(entry.opts) end)
      end
    end
  end

  local applied = pcall(vim.cmd.colorscheme, colorscheme)
  if applied then
    vim.g.colors_name = colorscheme
  end
  return applied
end

return M
