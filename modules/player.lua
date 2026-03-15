----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")

----------------------------------------
-- Entidade Player
----------------------------------------

local INITIAL_HP = 100

Player = {}
Player.__index = Player

Player.hp = INITIAL_HP
Player.ammo = 0
Player.action = nil -- apenas indicando a existência
Player.items = {}
Player.upgrades = {}

function Player:resetForBattle()
    Player.hp = INITIAL_HP
    Player.ammo = 0
end

function Player:getItem(item, idx)
    idx = idx or #self.items + 1
    if idx < 1 or idx > 3 then
        return -- limite de itens alcançado
    end

    table.insert(self.items, item)
end

function Player:getUpgrade(upgrade)
    table.insert(self.items, upgrade)
end

return Player
