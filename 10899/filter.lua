---@param tbl Table
---@return Table
local function flatten_table(tbl)
   if #tbl.bodies == 1 then
      local body = tbl.bodies[1].body
      if #body == 1 then
         local cells = body[1].cells
         if #cells == 1 then
            local cell_contents = cells[1].contents
            if #cell_contents == 1 and cell_contents[1].tag == 'Table' then
               local wrapped_table = cell_contents[1]
               ---@cast wrapped_table Table
               return flatten_table(wrapped_table)
            end
         end
      end
   end
   return tbl
end

---@type Filter
return {
   {
      Div = function(div)
         -- flatten Divs
         return div.content
      end,
   },
   {
      traverse = 'topdown',
      Table = flatten_table,
   },
}
