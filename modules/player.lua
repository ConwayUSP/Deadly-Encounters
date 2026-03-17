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

	for _, upgrade in pairs(self.upgrades) do
		if upgrade.onStart then
			upgrade:active(self)
		end
	end

	for _, item in pairs(self.items) do
		item.quantity = item.initialQuantity
	end
end

function Player:getItem(item, idx)
	idx = idx or #self.items + 1
	if idx < 1 or idx > 3 then
		return -- limite de itens alcançado
	end

	table.insert(self.items, item)
end

function Player:getUpgrade(upgrade)
	table.insert(self.upgrades, upgrade)
end

-- discarta item da lista de itens usados, para que ele não seja ativado mais de uma vez
function Player:discardItem(item)
	for k, v in pairs(self.usedItems) do
		if v == item then
			self.usedItems[k] = nil
		end
	end
end

-- discarta um upgrade (caso ele seja de uso único)
function Player:discardUpgrade(upgrade)
	for k, v in pairs(self.upgrades) do
		if v == upgrade then
			self.upgrades[k] = nil
		end
	end
end

return Player
