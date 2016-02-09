local template = {}

local EQUALS = string.byte("=")
local sub = string.sub

function template.compile(source)
	local fragments = {
		"local _ENV = ... or {};",
		"local __OUT__ = {};",
		"local function __PUSH__(str) __OUT__[#__OUT__ + 1] = str end;"
	}
	
	local cursor = 1
	function push(...) for _, str in ipairs{...} do table.insert(fragments, str) end end
	
	while true do
		str, code = string.match(source, "(.-)({{.-}})", cursor)
		if str == nil and code == nil then
			-- Push the remainder of the string.
			push("__PUSH__[[", sub(source, cursor, -1), "]]; ")
			break
		else
			-- Push the string component.
			push("__PUSH__[[", str, "]]; ")
			
			if string.byte(code, 3) == EQUALS then
				-- Push an evaluation expression {{=...}}
				push("__PUSH__(", sub(code, 4, -3), "); ")
			else
				-- Push a chunk {{...}}
				push(sub(code, 3, -3), "; ")
			end
		end
		
		cursor = cursor + #str + #code
	end
	
	table.insert(fragments, "return __OUT__")
	return table.concat(fragments)
end

function template.load(str, name)
	local compiled = template.compile(str)
	local chunk = load(compiled, name or "COMPILED TEMPLATE", "t")
	
	return function(env)
		local results = chunk(env)
		for i, v in ipairs(results) do results[i] = tostring(v) end
		return table.concat(results)
	end
end

function template.loadFile(filename)
	local file = io.open(filename, "r")
	
	local chunk = template.load(file:read("a"), filename)
	file:close()
	
	return chunk
end

return template
