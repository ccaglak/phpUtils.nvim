-- main module file
require("phptools.funcs")

---@class Config
---@field opt string
local config = {
  ui = false,
}

local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
  if M.config.ui == true then
    require("phptools.ui")
  end
end

M.method = function()
  require("phptools.method"):run()
end

M.class = function()
  require("phptools.class"):run()
end

M.namespace = function()
  require("phptools.namespace"):run()
end

M.getset = function()
  require("phptools.getset"):run()
end

M.scripts = function()
  require("phptools.composer"):scripts()
end

M.refactor = function()
  require("phptools.refactor"):run()
end

M.artisan = function()
  require("phptools.artisan"):run()
end
M.create = function()
  require("phptools.create"):run()
end

return M
