---Parse given raw HTML tags into given AST elements, modifies Inlines in place.
---@param inlines         Inlines
---@param tag             string
---@param InlineConstructor fun(inlines: table): Inline
local function parse_tags(inlines, tag, InlineConstructor)
   -- go back to front to avoid problems with changing indices
   for i = #inlines, 1, -1 do
      if inlines[i].tag == 'RawInline' and inlines[i].text == '<' .. tag .. '>' then
         for j = i + 1, #inlines, 1 do
            if inlines[j].tag == 'RawInline' and inlines[j].text == '</' .. tag .. '>' then
               inlines[i] = InlineConstructor { table.unpack(inlines, i + 1, j - 1) }
               for _ = i + 1, j, 1 do
                  inlines:remove(i + 1)
               end
               break
            end
         end
      end
   end
end

---@param inlines Inlines
---@return Inlines | nil
function Inlines(inlines)
   parse_tags(inlines, 'u', pandoc.Underline)
   parse_tags(inlines, 'i', pandoc.Emph)
   return inlines
end
