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
MenuState.logoScale = 0

function MenuState:load()
	local width, height = love.graphics.getDimensions()

	GAMESTATE[CTX.BATTLE]:restartGame()

	-- sprites
	self.sprites.bg = love.graphics.newImage("assets/UI/menu/menu_bg.png")
	self.sprites.logo = love.graphics.newImage("assets/UI/menu/logo.png")

	-- texto do prompt
	self.texts.prompt = Text.new(
		"Press Enter or Space to Play",
		36,
		{ 1, 1, 1, 1 },
		{ width / 2, height * 0.9 },
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

	local maxLogoScale = 0.8
	local speed = 3
	if self.logoScale < maxLogoScale then
		self.logoScale = self.logoScale + (maxLogoScale - self.logoScale) * (1 - math.exp(-speed * dt))
		if self.logoScale > maxLogoScale then
			self.logoScale = maxLogoScale
		end
	end

	self.texts.prompt:update(self.timer > 0 and 6 * dt or dt)

	cleanUpTexts(self.texts)
end

function MenuState:draw()
	local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()

		-- background
	local bg = self.sprites.bg
	local bgW, bgH = bg:getWidth(), bg:getHeight()
	local scale = math.max(screenW / bgW, screenH / bgH)
	local drawX = (screenW - bgW * scale) / 2
	local drawY = (screenH - bgH * scale) / 2
	love.graphics.draw(bg, drawX, drawY, 0, scale, scale)

	-- logo
	local logo = self.sprites.logo
	local logoW, logoH = logo:getWidth(), logo:getHeight()
	love.graphics.draw(self.sprites.logo, screenW / 2, screenH * 0.2, 0, self.logoScale, self.logoScale, logoW / 2, logoH / 2)

	for key, text in pairs(self.texts) do
		text:draw()
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function MenuState:keypressed(key, scancode, isrepeat)
	if key == "return" or key == "space" then
		if self.timer <= 0 then
			self.timer = 1.0
			self.sounds.start:play()
		end
	end
end

return MenuState
