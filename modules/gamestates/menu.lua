----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.fs")

----------------------------------------
-- Estado do Menu
----------------------------------------

local MenuState = {}
MenuState.__index = MenuState

MenuState.sprites = {}
MenuState.texts = {}

-- caminho da fonte principal do jogo
MenuState.fontPath = "assets/fonts"
MenuState.fontName = "Cute Dino"

MenuState.titleFont = nil
MenuState.promptFont = nil

function MenuState:load()
	-- carrega fontes
	if resolvePath(self.fontPath, self.fontName, ".ttf") then
		self.titleFont = love.graphics.newFont(resolvePath(self.fontPath, self.fontName, ".ttf"), 64)
		self.promptFont = love.graphics.newFont(resolvePath(self.fontPath, self.fontName, ".ttf"), 32)
	else
		self.titleFont = love.graphics.newFont(64)
		self.promptFont = love.graphics.newFont(32)
	end

	local width, height = love.graphics.getDimensions()

	-- texto do título
	self.texts.title = Text.new(
		"Deadly Encounters",
		64,
		{ 0.15, 0.10, 0.08, 1 },
		{ width / 2, height / 3 },
		0,
		true,
		math.huge,
		function(text, dt)
			text.time = (text.time or 0) + dt
			local rotateDeg = math.sin(text.time * 2) * 2
			text.rotation = math.rad(rotateDeg)
			text.scale = 1 + 0.05 * math.sin(text.time * 0.5)
		end
	)
	self.texts.title.font = self.titleFont

	-- texto do prompt
	self.texts.prompt = Text.new(
		"Press Enter or Space to Play",
		32,
		{ 0.15, 0.10, 0.08, 1 },
		{ width / 2, height * 0.6 },
		0,
		true,
		math.huge,
		function(text, dt)
			text.time = (text.time or 0) + dt
			local alpha = 0.5 + 0.5 * math.sin(text.time * 4)
			text.color[4] = alpha
		end
	)
	self.texts.prompt.font = self.promptFont
end

function MenuState:update(dt)
	for _, text in pairs(self.texts) do
		if text.update then
			text:update(dt)
		end
	end
	cleanUpTexts(self.texts)
end

function MenuState:draw()
	-- fundo em tom bege suave
	love.graphics.clear(0.95, 0.90, 0.80)

	for key, text in pairs(self.texts) do
		text:draw()
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function MenuState:keypressed(key, scancode, isrepeat)
	if key == "return" or key == "space" then
		SetGameCtx(CTX.BATTLE)
	end
end

return MenuState
