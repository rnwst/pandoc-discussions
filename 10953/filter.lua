---Header filter function
---@param header Header
---@return Header?
function Header(header)
   if header.level < 5 then
      header.content:insert(1, pandoc.RawInline('html', '<span class="header-section-text">'))
      header.content:insert(pandoc.RawInline('html', '</span>'))
      return header
   end
end

---Blocks filter function
---@param blocks (Blocks | Block[])
---@return Blocks
function Blocks(blocks)
   local i = 1
   while i <= #blocks do
      if blocks[i].tag == 'Header' and blocks[i].level >= 5 then
         local first_header = blocks[i]
         ---@cast first_header Header
         local list_attributes = first_header.level == 5 and pandoc.ListAttributes(1, 'LowerAlpha', 'Period')
            or pandoc.ListAttributes(1, 'Decimal', 'TwoParens')
         local ol = pandoc.OrderedList({ pandoc.Plain(first_header.content) }, list_attributes)
         local j = i + 1
         while blocks[j] and blocks[j].tag == 'Header' and blocks[j].level == first_header.level do
            ol.content:insert(pandoc.Plain(blocks[j].content))
            blocks:remove(j)
         end
         blocks[i] = ol
      end
      i = i + 1
   end
   return blocks
end
