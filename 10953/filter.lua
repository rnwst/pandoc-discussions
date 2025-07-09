---Header filter function
---@param header Header
---@return (OrderedList | Header)
function Header(header)
   if header.level == 5 then
      return pandoc.OrderedList(pandoc.Plain(header.content), pandoc.ListAttributes(1, 'LowerAlpha', 'Period'))
   elseif header.level == 6 then
      return pandoc.OrderedList(pandoc.Plain(header.content), pandoc.ListAttributes(1, 'Decimal', 'TwoParens'))
   end
   header.content:insert(1, pandoc.RawInline('html', '<span class="header-section-text">'))
   header.content:insert(pandoc.RawInline('html', '</span>'))
   return header
end
