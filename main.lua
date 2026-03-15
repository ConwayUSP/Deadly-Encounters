----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.actions")
require("modules.gamectx")
require("modules.oponent")
require("modules.menu")
local player = require("modules.player")

GameCtx = CTX.MENU

function love.load()
    love.window.setMode(1920, 1080)

    Menu:loadFonts()
end

function love.update(dt)
    if GameCtx == CTX.MENU then
        Menu:update(dt)
    elseif GameCtx == CTX.COMBAT then
    
    elseif GameCtx == CTX.SHOP then

    end
end

function love.draw()
    if GameCtx == CTX.MENU then
        Menu:draw()
    elseif GameCtx == CTX.COMBAT then
        
    elseif GameCtx == CTX.SHOP then

    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    if GameCtx == CTX.MENU then
        Menu:keypressed(key, scancode, isrepeat)
    elseif GameCtx == CTX.COMBAT then

    elseif GameCtx == CTX.SHOP then

    end
end
