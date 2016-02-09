local template = {}

function template.compile(source)
	local fragments = {"local strings = {}; "}
	local cursor = 1
	
	while true do
		str, code = string.match(source, "(.-)({{.-}})", cursor)
		if str == nil and code == nil then
			table.insert(fragments, "table.insert(strings, [[")
			table.insert(fragments, string.sub(source, cursor, -1))
			table.insert(fragments, "]]); ")
			
			break
		else
			table.insert(fragments, "table.insert(strings, [[")
			table.insert(fragments, str)
			table.insert(fragments, "]]); ")
			
			if string.sub(code, 3, 3) == "=" then
				table.insert(fragments, "table.insert(strings, tostring(")
				table.insert(fragments, string.sub(code, 4, -3))
				table.insert(fragments, ")); ")
			else
				table.insert(fragments, string.sub(code, 3, -3))
				table.insert(fragments, "; ")
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
