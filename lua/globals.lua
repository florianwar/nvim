--- Print vim.inspect of arguments and return them
--- @param ... any
--- @return ...
P = function(...)
  local args = { ... }
  if #args == 1 then
    print(vim.inspect(args[1]))
    return args[1]
  else
    print(vim.inspect(args))
  end

  return ...
end

--- Notify vim.inspect of arguments and return them
--- @param ... any
--- @return ...
N = function(...)
  local args = { ... }
  if #args == 1 then
    vim.notify(vim.inspect(args[1]), vim.log.levels.WARN)
  else
    vim.notify(vim.inspect(args), vim.log.levels.WARN)
  end

  return ...
end
