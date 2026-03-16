----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")

----------------------------------------
-- Entidade Player
----------------------------------------

Player = {}
Player.__index = Player

Player.name = "you"
Player.maxHp = 100
Player.maxCounters = 3
Player.hp = Player.initialHp
Player.ammo = 0
Player.defCount = 0
Player.counters = Player.MaxCounters
Player.action = ACTION.NONE
Player.items = {}
Player.upgrades = {}
Player.usedItems = {}
initCreatureAnimations(Player)

function Player:resetForBattle()
	self.hp = self.maxHp
	self.counters = self.maxCounters
	self.ammo = 0
	self.defCount = 0
	self.usedItems = {}
	self.action = ACTION.NONE
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

-- após um item ser usado, ele precisa ser descartado
-- da lista de items e da lista de items usados
function Player:discardItem(item)
	for k, v in pairs(self.items) do
		if v == item then
			self.items[k] = nil
		end
	end

	for k, v in pairs(self.usedItems) do
		if v == item then
			self.usedItems[k] = nil
		end
	end
end

return Player
