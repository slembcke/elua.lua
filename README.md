# ELua
Extremely simple, ERB inspired templates for Lua. Made for a personal project, but possibly useful to others.

You can embed expressions, control structures, pass an environment, etc. Probably-mostly-sorta straightforward.
An attempt was made so that the generated Lua source for a template has the same line numbers as the original template.

It doesn't provide security at all. My personal use case features neither server programming nor user input.
Bad input can trigger injection attacks. _YOU'VE BEEN WARNED!_

## Example:

example.elua:
```
Let's sing a song!
{{for i = count, 1, -1 do}}
{{= i}} bottles of beer on the wall.
{{= i}} bottles of beer.
Take one down pass it around,
{{= i - 1}} bottles of beer on the wall.
{{end}}
That was fun!
```

example.lua:
```
local elua = require("elua")

local bottles, err = elua.compile_file("example.elua")
if err then error(err) end

local output = bottles{count = 99}
print(output)
```

## License

```
The MIT License (MIT)

Copyright (c) 2016 Scott Lembcke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
