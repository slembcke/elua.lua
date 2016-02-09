local template = {}

local EQUALS = string.byte("=")
local sub = string.sub

function template.compile(source)
	local fragments = {"local __OUT, _ENV = ...;"}
	
	local cursor = 1
	function push(...) for _, str in ipairs{...} do table.insert(fragments, str) end end
	
	while true do
		str, code = string.match(source, "(.-)({{.-}})", cursor)
		if str == nil and code == nil then
			-- Push the remainder of the string.
			push("__OUT[[", sub(source, cursor, -1), "]]; ")
			break
		else
			-- Push the string component.
			push("__OUT[[", str, "]]; ")
			
			if string.byte(code, 3) == EQUALS then
				-- Push an evaluation expression {{=...}}
				push("__OUT(", sub(code, 4, -3), "); ")
			else
				-- Push a chunk {{...}}
				push(sub(code, 3, -3), "; ")
			end
		end
		
		cursor = cursor + #str + #code
	end
	
	return table.concat(fragments)
end

function template.load(str, name)
	local compiled = template.compile(str)
	local chunk, err = load(compiled, name or "COMPILED TEMPLATE", "t", nil)
	if err then return nil, err end
	
	return function(env)
		local results = {}
		local function out(value) table.insert(results, tostring(value)) end
		
		chunk(out, env or nil)
		return table.concat(results)
	end
end

function template.loadFile(filename)
	local file = io.open(filename, "r")
	local source = file:read("a")
	file:close()
	
	return template.load(source, filename)
end

return template
