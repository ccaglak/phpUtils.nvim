local tree = require("phptools.treesitter")
local Etter = {}
function Etter:new()
  local t = setmetatable({}, { __index = Etter })
  return t
end

local function flatten_symbols(symbols, result)
  result = result or {}
  for _, symbol in ipairs(symbols) do
    table.insert(result, symbol)
    if symbol.children then
      flatten_symbols(symbol.children, result)
    end
  end
  return result
end
--
--
function Etter:run()
  local M = Etter:new()
  M:get_position()
  if M.parent == nil then
    return
  end

  vim.ui.select({ "Set", "Get", "Get/Set" }, { prompt = "Select Method:" }, function(choice)
    if choice == nil then
      return
    end

    -- Todo find something better
    local vari = {}
    if choice == "Get" then
      vari = {
        Get = "get" .. string.ucfirst(string.dltfirst(M.variable.text)),
      }
    end
    if choice == "Set" then
      vari = {
        Set = "set" .. string.ucfirst(string.dltfirst(M.variable.text)),
      }
    end

    if choice == "Get/Set" then
      vari = {
        Get = "get" .. string.ucfirst(string.dltfirst(M.variable.text)),
        Set = "set" .. string.ucfirst(string.dltfirst(M.variable.text)),
      }
    end

    local params = vim.lsp.util.make_position_params()
    local results_lsp = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, 5000)

    if not results_lsp or vim.tbl_isempty(results_lsp) then
      print("No results")
      return
    end

    local vbool = false
    for gn, gs in pairs(vari) do
      for _, response in ipairs(results_lsp) do
        if response.result then
          for _, result in ipairs(flatten_symbols(response.result)) do
            if result.name == gs then
              vbool = true
            end
          end
        end
      end

      if vbool == false then
        local tmpl = M:template_builder(string.ucfirst(gn))
        M:add_to_buffer(tmpl)
      end
    end
  end)
end

--
--
--
function Etter:template_builder(choice)
  local var = self.variable.text
  local type = self.union.text
  local name = string.ucfirst(self.variable.text:sub(2))
  local vname = self.variable.text:sub(2)
  local tmpl = {}
  if choice == "Set" or choice == "Get/Set" then
    table.insert(tmpl, "    public function set" .. name .. "(" .. type .. " " .. var .. "):void{")
    table.insert(tmpl, "       $this->" .. vname .. " = " .. var .. ";")
    table.insert(tmpl, "    }")
  end
  if choice == "Get" or choice == "Get/Set" then
    table.insert(tmpl, "    public function get" .. name .. "():" .. type .. "{")
    table.insert(tmpl, "       return $this->" .. vname .. ";")
    table.insert(tmpl, "    }")
  end
  return tmpl
end

--
--
--
function Etter:add_to_buffer(lines)
  local lastline = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_buf_set_lines(0, lastline - 1, lastline - 1, true, lines)
  vim.api.nvim_buf_call(0, function()
    vim.cmd("silent! write! | edit")
  end)
end

--
--
--
function Etter:get_position()
  self.parent = tree.parent("property_declaration")
  if self.parent == nil then
    self.parent = tree.parent("property_promotion_parameter")
    if self.parent == nil then
      return
    end
  end

  -- self.visibility = tree.child_type(self.parent.node, "visibility_modifier")
  -- if self.visibility.node == nil then
  --   return
  -- end

  self.union = tree.children(self.parent.node, "optional_type")
  if self.union == nil then
    self.union = tree.children(self.parent.node, "primitive_type")
    if self.union == nil then
      self.union = tree.children(self.parent.node, "union_type")
      if self.union == nil then
        self.union = tree.children(self.parent.node, "named_type")
        if self.union == nil then
          return
        end
      end
    end
  end
  if self.parent.type ~= "property_promotion_parameter" then
    self.property = tree.children(self.parent.node, "property_element")
    if self.property.node == nil then
      return
    end
    self.variable = tree.children(self.property.node, "variable_name")
    if self.variable.node == nil then
      return
    end
    return
  end
  self.variable = tree.children(self.parent.node, "variable_name")
  if self.variable.node == nil then
    return
  end
end

return Etter
