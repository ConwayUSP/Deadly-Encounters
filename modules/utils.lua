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

function capitalize(string)
  return string:gsub("^%l", string.upper)
end

-- Compare two floats with a precisio of epsilon
function compareFloats(a, b, epsilon)
    return math.abs(a - b) < epsilon
end
