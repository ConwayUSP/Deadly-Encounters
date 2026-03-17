----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.actions")
require("modules.gamectx")
require("modules.gamestate")
require("modules.oponent")
require("modules.menu")
require("modules.finalscreen")

local player = require("modules.player")

GameCtx = CTX.MENU
GameState = GAMESTATE.MENU

local victoryScreen = FinalScreen:new(GAMESTATE.VICTORY_SCREEN.texts.title, GAMESTATE.VICTORY_SCREEN.texts.prompt)
local deathScreen = FinalScreen:new(GAMESTATE.DEATH_SCREEN.texts.title, GAMESTATE.DEATH_SCREEN.texts.prompt)

function love.load()
	love.window.setMode(1920, 1080)

	Menu:loadFonts()
end

function love.update(dt)
	if GameCtx == CTX.MENU then
		Menu:update(dt)
	elseif GameCtx == CTX.COMBAT then

	elseif GameCtx == CTX.SHOP then

	elseif GameCtx == CTX.VICTORY_SCREEN then
		victoryScreen:update(dt)
	elseif GameCtx == CTX.DEATH_SCREEN then
		deathScreen:update(dt)
	end
end

function love.draw()
	if GameCtx == CTX.MENU then
		Menu:draw()
	elseif GameCtx == CTX.COMBAT then
		Combat:draw()
	elseif GameCtx == CTX.SHOP then
		Shop:draw()
	elseif GameCtx == CTX.VICTORY_SCREEN then
		victoryScreen:draw()
	elseif GameCtx == CTX.DEATH_SCREEN then
		deathScreen:draw()
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if GameCtx == CTX.MENU then
		Menu:keypressed(key, scancode, isrepeat)
	elseif GameCtx == CTX.COMBAT then
		Combat:keypressed(key, scancode, isrepeat)
	elseif GameCtx == CTX.SHOP then

	elseif GameCtx == CTX.VICTORY_SCREEN then
		victoryScreen:keypressed(key, scancode, isrepeat)
	elseif GameCtx == CTX.DEATH_SCREEN then
		deathScreen:keypressed(key, scancode, isrepeat)
	end
end
