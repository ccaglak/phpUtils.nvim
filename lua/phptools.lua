-- main module file
require("phptools.funcs")

---@class Config
---@field opt string
local config = {
  ui = {
    enable = true,
    fzf = false,
  },
  toggle_options = {},
  drupal_autoloader = {},
}

local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  require("phptools.toggle").setup(M.config.toggle_options)
  require("phptools.drupal_autoloader").setup(M.config.drupal_autoloader)

  if M.config.ui.enable == true then
    require("phptools.ui").setup()
  end
end

M.method = function()
  require("phptools.method"):run()
end

M.class = function()
  require("phptools.class"):run()
end

M.getset = function()
  require("phptools.getset"):run()
end

M.scripts = function()
  require("phptools.composer"):scripts()
end

M.refactor = function()
  require("phptools.refactor").refactor()
end

M.create = function()
  require("phptools.create"):run()
end

M.namespace = function()
  require("phptools.composer"):resolve()
end

M.drupalautoloader = function()
  require("phptools.drupal_autoloader").update_autoload()
end

return M
