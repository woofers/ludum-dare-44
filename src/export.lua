path = 'ludumdare-44'

function to_html()
   export(path .. "/index.html")
   exit()
end

return { to_html = to_html }
