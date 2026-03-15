----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")

----------------------------------------
-- Entidade Menu
----------------------------------------

Menu = {}
Menu.__index = Menu

-- tempo acumulado para animar os textos
Menu.time = 0

-- caminho da fonte principal do jogo
Menu.fontPath = "assets/fonts"

Menu.fontName = "Cute Dino"

-- fontes usadas no menu
Menu.titleFont = nil
Menu.promptFont = nil

function resolvePath(base, relative, ending)
  local path = base .. "/" .. relative .. (ending or "")
  if love.filesystem.getInfo(path) then
    return path
  else
    return nil
  end
end

function Menu:loadFonts()
  if love.filesystem.getInfo(resolvePath(self.fontPath, self.fontName, ".ttf")) then
    self.titleFont = love.graphics.newFont(resolvePath(self.fontPath, self.fontName, ".ttf"), 64)
    self.promptFont = love.graphics.newFont(resolvePath(self.fontPath, self.fontName, ".ttf"), 32)
  else
    self.titleFont = love.graphics.newFont(64)
    self.promptFont = love.graphics.newFont(32)
  end
end

function Menu:update(dt)
  self.time = self.time + dt
end

function Menu:draw()
  -- fundo em tom bege suave
  love.graphics.clear(0.95, 0.90, 0.80)

  local width, height = love.graphics.getDimensions()

  local title = "Deadly Encounters"
  local prompt = "Press Enter or Space to Play"

  -- Desenha título
  local titleFont = self.titleFont
  love.graphics.setFont(titleFont)
  local titleWidth = titleFont:getWidth(title)
  local titleHeight = titleFont:getHeight()
  love.graphics.setColor(0.15, 0.10, 0.08)
  -- texto gira e escala
  local rotate = math.sin(self.time * 2) * 2
  local scale = 1 + 0.05 * math.sin(self.time * 0.5)
  -- desenha o título com pivô no centro do texto
  local titleX = width / 2
  local titleY = height / 3
  love.graphics.print(title, titleX, titleY, math.rad(rotate), scale, scale, titleWidth / 2, titleHeight / 2)

  -- Desenha texto de "press start"
  local promptFont = self.promptFont
  love.graphics.setFont(promptFont)
  local promptWidth = promptFont:getWidth(prompt)
  -- texto pisca suavemente
  local alpha = 0.5 + 0.5 * math.sin(self.time * 4)
  love.graphics.setColor(0.15, 0.10, 0.08, alpha)
  love.graphics.print(prompt, (width - promptWidth) / 2, height * 0.6)

  -- reset de cor
  love.graphics.setColor(1, 1, 1, 1)

end

function Menu:keypressed(key, scancode, isrepeat)
  if key == "return" or key == "space" then
    GameCtx = CTX.COMBAT
  end
  
end