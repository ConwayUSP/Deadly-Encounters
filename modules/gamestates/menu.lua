----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.fs")
require("modules.utils")

----------------------------------------
-- Estado do Menu
----------------------------------------

local MenuState = {}
MenuState.__index = MenuState

MenuState.sprites = {}
MenuState.texts = {}

MenuState.titleFont = nil
MenuState.promptFont = nil
MenuState.sounds = {}
MenuState.timer = 0

function MenuState:load()
	local width, height = love.graphics.getDimensions()

	GAMESTATE[CTX.BATTLE]:restartGame()

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

	-- sounds
	self.sounds.start = love.audio.newSource("sounds/start.mp3", "static")
	self.sounds.start:setVolume(0.5)
end

function MenuState:update(dt)
	if self.timer > 0 then
		self.timer = self.timer - dt
		if self.timer <= 0 then
			SetGameCtx(CTX.BATTLE)
		end
	end

	self.texts.title:update(dt)
	self.texts.prompt:update(self.timer > 0 and 6 * dt or dt)

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
		if self.timer <= 0 then
			self.timer = 2.5
			self.sounds.start:play()
		end
	end
end

return MenuState
