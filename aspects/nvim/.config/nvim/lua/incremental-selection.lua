-- Incremental selection using treesitter
-- Extracted from: https://github.com/MeanderingProgrammer/treesitter-modules.nvim

local M = {}

---@class Range
---@field private range integer[] 0-based inclusive [srow, scol, erow, ecol]
local Range = {}
Range.__index = Range

---@param range integer[]
---@return Range
function Range.new(range)
	local self = setmetatable({}, Range)
	self.range = range
	return self
end

---@param node TSNode
---@return Range
function Range.node(node)
	local srow, scol, erow, ecol = node:range()
	if ecol == 0 then
		erow = erow - 1
		local line = vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1]
		ecol = math.max(#line, 1)
	end
	ecol = ecol - 1
	return Range.new({ srow, scol, erow, ecol })
end

---@return Range
function Range.visual()
	local _, srow, scol, _ = unpack(vim.fn.getpos("."))
	local _, erow, ecol, _ = unpack(vim.fn.getpos("v"))
	srow, scol, erow, ecol = srow - 1, scol - 1, erow - 1, ecol - 1
	if srow < erow or (srow == erow and scol <= ecol) then
		return Range.new({ srow, scol, erow, ecol })
	else
		return Range.new({ erow, ecol, srow, scol })
	end
end

---@param other Range
---@return boolean
function Range:same(other)
	return vim.deep_equal(self.range, other.range)
end

---@return integer[]
function Range:cursor_start()
	return { self.range[1] + 1, self.range[2] }
end

---@return integer[]
function Range:cursor_end()
	return { self.range[3] + 1, self.range[4] }
end

---@return integer[]
function Range:ts()
	return { self.range[1], self.range[2], self.range[3], self.range[4] + 1 }
end

---@class NodeStack
---@field private entries table<integer, { tick: integer, nodes: TSNode[] }>
local NodeStack = {}
NodeStack.__index = NodeStack

function NodeStack.new()
	local self = setmetatable({}, NodeStack)
	self.entries = {}
	return self
end

---@param buf integer
---@return TSNode[]
function NodeStack:get(buf)
	local entry = self.entries[buf]
	local tick = vim.api.nvim_buf_get_changedtick(buf)
	if not entry or entry.tick ~= tick then
		entry = { tick = tick, nodes = {} }
		self.entries[buf] = entry
	end
	return entry.nodes
end

---@param buf integer
---@param node TSNode
function NodeStack:push(buf, node)
	local nodes = self:get(buf)
	nodes[#nodes + 1] = node
end

---@param buf integer
---@return TSNode?
function NodeStack:pop(buf)
	local nodes = self:get(buf)
	if #nodes > 0 then
		nodes[#nodes] = nil
	end
	return nodes[#nodes]
end

---@param buf integer
---@return TSNode?
function NodeStack:last(buf)
	local nodes = self:get(buf)
	return nodes[#nodes]
end

---@param buf integer
function NodeStack:clear(buf)
	self.entries[buf] = nil
end

-- Module state
local node_stack = NodeStack.new()

---@param language string
---@return boolean
local function has_locals_query(language)
	return #vim.treesitter.query.get_files(language, "locals") > 0
end

---@param buf integer
---@param language string
---@return vim.treesitter.LanguageTree?
local function parse(buf, language)
	local has, parser = pcall(vim.treesitter.get_parser, buf, language)
	if not has or not parser then
		return nil
	end
	local first, last = vim.fn.line("w0"), vim.fn.line("w$")
	parser:parse({ first - 1, last })
	return parser
end

---@param node TSNode
local function select_node(node)
	local range = Range.node(node)
	if vim.api.nvim_get_mode().mode ~= "v" then
		vim.cmd.normal({ "v", bang = true })
	end
	vim.api.nvim_win_set_cursor(0, range:cursor_start())
	vim.cmd.normal({ "o", bang = true })
	vim.api.nvim_win_set_cursor(0, range:cursor_end())
end

---@param buf integer
---@param language string
---@param root TSNode
---@return TSNode[]
local function get_scopes(buf, language, root)
	if not has_locals_query(language) then
		return {}
	end
	local query = vim.treesitter.query.get(language, "locals")
	if not query then
		return {}
	end
	local result = {}
	local start, _, stop, _ = root:range()
	for _, match in query:iter_matches(root, buf, start, stop + 1) do
		for id, nodes in pairs(match) do
			local capture = query.captures[id]
			if capture == "local.scope" then
				for _, node in ipairs(nodes) do
					result[#result + 1] = node
				end
			end
		end
	end
	return result
end

---@param buf integer
---@param language string
---@param parent fun(parser: vim.treesitter.LanguageTree, node: TSNode): TSNode?
local function incremental(buf, language, parent)
	local parser = parse(buf, language)
	if not parser then
		return
	end

	local range = Range.visual()
	local last = node_stack:last(buf)
	local node = nil

	if not last or not range:same(Range.node(last)) then
		node = parser:named_node_for_range(range:ts(), { ignore_injections = false })
		node_stack:clear(buf)
	else
		parser = parser:language_for_range(range:ts())
		while parser and not node do
			node = parser:named_node_for_range(range:ts())
			while node and range:same(Range.node(node)) do
				node = parent(parser, node)
			end
			parser = parser:parent()
		end
	end

	if node then
		node_stack:push(buf, node)
		select_node(node)
	end
end

--- Initialize selection at cursor position
function M.init_selection()
	local buf = vim.api.nvim_get_current_buf()
	local parser = parse(buf, vim.bo[buf].filetype)
	if not parser then
		return
	end
	local node = vim.treesitter.get_node({ bufnr = buf, ignore_injections = false })
	if node then
		node_stack:push(buf, node)
		select_node(node)
	end
end

--- Expand selection to parent node
function M.node_incremental()
	local buf = vim.api.nvim_get_current_buf()
	local language = vim.bo[buf].filetype
	incremental(buf, language, function(_, node)
		return node:parent()
	end)
end

--- Expand selection to surrounding scope
function M.scope_incremental()
	local buf = vim.api.nvim_get_current_buf()
	local language = vim.bo[buf].filetype
	incremental(buf, language, function(parser, node)
		if language ~= parser:lang() then
			return nil
		end
		local scopes = get_scopes(buf, language, parser:trees()[1]:root())
		if #scopes == 0 then
			return nil
		end
		local result = node:parent()
		while result and not vim.tbl_contains(scopes, result) do
			result = result:parent()
		end
		assert(result ~= node, "infinite loop")
		return result
	end)
end

--- Shrink selection to previous node
function M.node_decremental()
	local buf = vim.api.nvim_get_current_buf()
	local node = node_stack:pop(buf)
	if node then
		select_node(node)
	end
end

--- Setup keymaps (optional convenience function)
---@param opts? { init?: string, increment?: string, scope?: string, decrement?: string }
function M.setup(opts)
	opts = opts or {}
	local init = opts.init or "gnn"
	local increment = opts.increment or "grn"
	local scope = opts.scope or "grc"
	local decrement = opts.decrement or "grm"

	if init then
		vim.keymap.set("n", init, M.init_selection, { desc = "Start incremental selection" })
	end
	if increment then
		vim.keymap.set("x", increment, M.node_incremental, { desc = "Expand selection to parent node" })
	end
	if scope then
		vim.keymap.set("x", scope, M.scope_incremental, { desc = "Expand selection to scope" })
	end
	if decrement then
		vim.keymap.set("x", decrement, M.node_decremental, { desc = "Shrink selection" })
	end
end

return M
