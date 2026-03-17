function returnFont(size)
  local path = "assets/fonts/"
  local name = "Cute Dino"
  local fontPath = path .. name .. ".ttf"

  if love.filesystem.getInfo(fontPath) then
    return love.graphics.newFont(fontPath, size)
  else
    return love.graphics.newFont(size)
  end
end