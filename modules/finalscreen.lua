----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")

----------------------------------------
-- Entidade Final Screen (representa Victory Screen e Death Screen)
----------------------------------------


FinalScreen = {}
FinalScreen.__index = FinalScreen

-- caminho da fonte principal do jogo
FinalScreen.fontPath = "assets/fonts"

FinalScreen.fontName = "Cute Dino"

-- fontes usadas no menu
FinalScreen.titleFont = nil
FinalScreen.promptFont = nil


function FinalScreen:new(title, prompt)
	local screen = setmetatable({}, FinalScreen)
	-- caixas de texto a serem exibidas
	screen.title = title
	screen.prompt = prompt
	-- tempo acumulado para animar os textos
	screen.time = 0

	screen:loadFonts()
	return screen
end

local function resolvePath(base, relative, ending)
	local path = base .. "/" .. relative .. (ending or "")
	if love.filesystem.getInfo(path) then
		return path
	else
		return nil
	end
end

function FinalScreen:loadFonts()
	if love.filesystem.getInfo(resolvePath(self.fontPath, self.fontName, ".ttf")) then
		self.titleFont = love.graphics.newFont(resolvePath(self.fontPath, self.fontName, ".ttf"), 64)
		self.promptFont = love.graphics.newFont(resolvePath(self.fontPath, self.fontName, ".ttf"), 32)
	else
		self.titleFont = love.graphics.newFont(64)
		self.promptFont = love.graphics.newFont(32)
	end
end

function FinalScreen:update(dt)
	self.time = self.time + dt
end

function FinalScreen:draw()
	-- fundo em tom bege suave
	love.graphics.clear(0.95, 0.90, 0.80)

	local width, height = love.graphics.getDimensions()

	-- Desenha título
	local titleFont = self.titleFont
	love.graphics.setFont(titleFont)
	local titleWidth = titleFont:getWidth(self.title)
	local titleHeight = titleFont:getHeight()
	love.graphics.setColor(0.15, 0.10, 0.08)
	-- texto gira e escala
	local rotate = math.sin(self.time * 2) * 2
	local scale = 1 + 0.05 * math.sin(self.time * 0.5)
	-- desenha o título com pivô no centro do texto
	local titleX = width / 2
	local titleY = height / 3
	love.graphics.print(self.title, titleX, titleY, math.rad(rotate), scale, scale, titleWidth / 2, titleHeight / 2)

	-- Desenha texto de "press start"
	local promptFont = self.promptFont
	love.graphics.setFont(promptFont)
	local promptWidth = promptFont:getWidth(self.prompt)
	-- texto pisca suavemente
	local alpha = 0.5 + 0.5 * math.sin(self.time * 4)
	love.graphics.setColor(0.15, 0.10, 0.08, alpha)
	love.graphics.print(self.prompt, (width - promptWidth) / 2, height * 0.6)

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function FinalScreen:keypressed(key, scancode, isrepeat)
	if key == "return" or key == "space" then
		GameCtx = CTX.MENU
	end
end
