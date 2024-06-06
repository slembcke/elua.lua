print(package.path)
dbg = require 'debugger'
dbg.auto_where = 3

local template = [====[
{{
  local NAME = "Hai there!"
}}
<htlm>
  <naim>{{io.write(NAME)}}</naim>
  <bahdee>
    <p>
      Put some shtuff in {{io.write("here")}}
      Wrap code with {{{these}}
    </p>
  </bahdee>
</htlm>
]====]


local function parse(template, cursor)
  local chunks = {}

  local cursor = 1
  while true do
    local next = template:find("{{.", cursor) or #template
    if cursor ~= next then
      local chunk = string.format("io.write(template:sub(%d, %d))", cursor, next - 1)
      table.insert(chunks, chunk)
    end

    if next == #template then break end
    cursor = next
  
    local match = template:sub(cursor, cursor + 2)
    if match == "{{{" then
      table.insert(chunks, "io.write('{{{')")
      cursor = cursor + 3
    elseif match == "{{=" then
      local next = template:find("}}", cursor)
      table.insert(chunks, template:sub(cursor + 2, next - 1))
      cursor = next + 2
    else
      local next = template:find("}}", cursor)
      table.insert(chunks, template:sub(cursor + 2, next - 1))
      cursor = next + 2
    end
  end

  print(table.concat(chunks, "\n"))
  local env = {io = io, template = template}
  env = _ENV
  print("env")
  for k,_ in pairs(env) do
    print(k)
  end
  print(_ENV.template)
  local func, err = load(table.concat(chunks, "\n"), "template", "t", env)
  func()
end

dbg.call(parse, template, 1)
