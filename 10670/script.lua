-- read Markdown file
local mdpath = 'subdir/doc.md'
local doc = pandoc.read(select(2, pandoc.mediabag.fetch(mdpath)))

-- run filter to make image paths relative to working dir
doc = doc:walk {
   ---@type fun(img: Image): Image
   Image = function(img)
      img.src = pandoc.path.join { pandoc.path.directory(mdpath), img.src }
      return img
   end,
}

-- render doc
print(pandoc.write(doc, 'html'))
