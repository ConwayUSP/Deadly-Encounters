-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.text")
local resolvePath = require("modules.engine.path")

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
	-- fontes e textos a serem exibidos
	screen:loadFonts()

	local width, height = love.graphics.getDimensions()

	screen.texts = {}

	-- texto do título (gira levemente e pulsa no tamanho)
	screen.texts.title = Text.new(
		title,
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
	screen.texts.title.font = screen.titleFont

	-- texto do prompt (pisca na transparência)
	screen.texts.prompt = Text.new(
		prompt,
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
	screen.texts.prompt.font = screen.promptFont

	return screen
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
	for _, text in pairs(self.texts or {}) do
		if text.update then
			text:update(dt)
		end
	end
end

function FinalScreen:draw()
	-- fundo em tom bege suave
	love.graphics.clear(0.95, 0.90, 0.80)

	for _, text in pairs(self.texts or {}) do
		local font = text.font or love.graphics.getFont()
		love.graphics.setFont(font)

		local content = text.content or ""
		local width = font:getWidth(content)
		local height = font:getHeight()

		local x = text.pos[1]
		local y = text.pos[2]
		local rotation = text.rotation or 0
		local scale = text.scale or 1
		local ox, oy = 0, 0

		if text.centerOffset then
			ox = width / 2
			oy = height / 2
		end

		local color = text.color or { 1, 1, 1, 1 }
		love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
		love.graphics.print(content, x, y, rotation, scale, scale, ox, oy)
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function FinalScreen:keypressed(key, scancode, isrepeat)
	if key == "return" or key == "space" then
		SetGameCtx(CTX.MENU)
	end
end

return FinalScreen
