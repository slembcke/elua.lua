local template = {}

function template.compile(source)
	local fragments = {"local strings = {}; "}
	function push(...) for _, str in ipairs{...} do table.insert(fragments, str) end end
	local sub = string.sub
	
	local eq = string.byte("=")
	
	local cursor = 1
	
	while true do
		str, code = string.match(source, "(.-)({{.-}})", cursor)
		if str == nil and code == nil then
			-- Push the remainder of the string.
			push("table.insert(strings, [[", sub(source, cursor, -1), "]]); ")
			break
		else
			-- Push the string component.
			push("table.insert(strings, [[", str, "]]); ")
			
			if string.byte(code, 3) == eq then
				-- Push an evaluation expression {{=...}}
				push("table.insert(strings, tostring(", sub(code, 4, -3), ")); ")
			else
				-- Push a chunk {{...}}
				push(sub(code, 3, -3), "; ")
			end
		end
		
		cursor = cursor + #str + #code
	end
	
	table.insert(fragments, "return table.concat(strings)")
	return table.concat(fragments)
end

function template.load(str, name, env)
	local compiled = template.compile(str)
	return load(compiled, name or "COMPILED TEMPLATE", "t", env or _ENV)
end

function template.loadFile(filename, env)
	local file = io.open(filename, "r")
	
	local chunk = template.load(file:read("a"), filename, env)
	file:close()
	
	return chunk
end

return template
