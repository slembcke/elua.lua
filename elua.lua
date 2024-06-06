local append, join, format = table.insert, table.concat, string.format

-- return a list and a function that appends its arguments into the list
local function appender(lines)
	return lines, function(...) append(lines, join{...}) end
end

local elua = {}

function elua.generate(template)
	-- push an initial line to recieve args from the wrapping closure
	local cursor, fragments, append = 1, appender{"local __elua, _ENV = ...\n"}
	
	while true do
		-- find a code block
		local i0, i1, m1, m2 = template:find("{{(=?)(.-)}}", cursor)
		
		if i0 == nil then
			-- if no code block, append remainder and join
			append("__elua", format("%q", template:sub(cursor, #template)))
			return join(fragments, "; ")
		elseif cursor ~= i0 then
			-- if there is text to output, output it
			append("__elua", format("%q", template:sub(cursor, i0 - 1)))
		end
		
		if m1 == "=" then
			-- append expression
			append("__elua(", m2, ")")
		else
			-- append code
			append(m2)
		end
		
		cursor = i1 + 1
	end
end

function elua.compile(template, name)
	local template_code = elua.generate(template)
	
	-- compile the template's lua code
	local chunk, err = load(template_code, name or "COMPILED TEMPLATE", "t")
	if err then return nil, err end
	
	-- wrap chunk in closure to collect and join it's output fragments
	return function(env)
		local fragments, append = appender{}
		chunk(append, env)
		return join(fragments)
	end
end

function elua.compile_file(filename)
	local file = io.open(filename, "r")
	local source = file:read("a")
	file:close()
	
	return elua.compile(source, filename)
end

return elua
