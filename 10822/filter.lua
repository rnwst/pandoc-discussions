local html_entities = pandoc.List {
   ['\u{00A0}'] = '&nbsp;',
   ['\u{2026}'] = '&hellip;',
}

local char_str = ''

for k in pairs(html_entities) do
   char_str = char_str .. k
end

---Replace appropriate Unicode glyphs with HTML entitites.
---@param str Str
---@return List<(Str | RawInline)>, false
---@overload fun(str: Str): nil
function Str(str)
   local inlines = pandoc.List {}
   local text = str.text
   repeat
      local start, _end = re.find(text, '([^' .. char_str .. ']+) / ([' .. char_str .. ']+)')
      if start then
         local segment = text:sub(start, _end)
         text = text:sub(_end + 1)
         if re.find(segment, '[' .. char_str .. ']') then
            for entity in pairs(html_entities) do
               segment = segment:gsub(entity, html_entities)
            end
            inlines:insert(pandoc.RawInline('html', segment))
         else
            inlines:insert(pandoc.Str(segment))
         end
      end
   until not (start or _end)
   if #inlines > 0 then return inlines, false end
end
