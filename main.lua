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
	math.randomseed(os.time())

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
	GameState[GameCtx]:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	GameState[GameCtx]:keypressed(key, scancode, isrepeat)
end
