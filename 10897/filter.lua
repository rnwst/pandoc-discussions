---Check whether the given block is a delimiter of the given type.
---@param block Block
---@param type ('opening' | 'closing')
---@return boolean
local function is_delimiter(block, type)
   if block.tag == 'Para' then
      local para = block
      ---@cast para Para
      if #para.content == 1 and para.content[1].tag == 'Str' then
         local str = para.content[1]
         ---@cast str Str
         if type == 'opening' and str.text == '§' then
            return true
         elseif type == 'closing' and str.text == '\\§' then
            return true
         end
      end
   end
   return false
end

---Blocks filter function.
---@param blocks (Blocks | Block[])
---@return Blocks
function Blocks(blocks)
   -- go back to front to avoid issues with changing indices
   for i = #blocks, 1, -1 do
      if is_delimiter(blocks[i], 'opening') then
         for j = i, #blocks do
            if is_delimiter(blocks[j], 'closing') then
               local md_blocks = pandoc.Blocks { table.unpack(blocks, i + 1, j - 1) }
               local inlines = pandoc.utils.blocks_to_inlines(md_blocks)
               local md = pandoc.write(pandoc.Pandoc(pandoc.Plain(inlines)), 'plain', { wrap_text = 'none' })
               local new_blocks = pandoc.read(md, 'markdown').blocks
               blocks = pandoc.Blocks { table.unpack(blocks, 1, i - 1) }
                  .. new_blocks
                  .. pandoc.Blocks { table.unpack(blocks, j + 1) }
               break
            end
         end
      end
   end
   return blocks
end
