local Metadata = loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/metadata/main/main.lua"))()
return setmetatable({
    discord = Metadata.discord:gsub("https://", ""):gsub("\n", "")
}, {
    __index = function(_, k)
        return Metadata[k]
    end,
})
