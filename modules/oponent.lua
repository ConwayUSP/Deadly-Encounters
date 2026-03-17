----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")

----------------------------------------
-- Classe Oponente
----------------------------------------

Oponent = {}
Oponent.__index = Oponent

function Oponent.new(name, maxHP, maxCounters, items, upgrades, strategyFunc)
	local oponent = setmetatable({}, Oponent)

	oponent.name = name
	oponent.maxHp = maxHP
	oponent.maxCounters = maxCounters
	oponent.hp = maxHP
	oponent.counters = maxCounters
	oponent.defCount = 0
	oponent.dmgMult = 1
	oponent.makeDecision = strategyFunc
	oponent.ammo = 0
	oponent.items = items or {}
	oponent.upgrades = upgrades or {}
	oponent.usedItems = {}
	oponent.action = ACTION.NONE
	initCreatureAnimations(oponent)

	return oponent
end

function Oponent:resetForBattle()
	self.hp = self.maxHp or self.hp
	self.counters = self.maxCounters or self.counters
	self.ammo = 0
	self.defCount = 0
	self.dmgMult = 1
	self.usedItems = {}
	self.action = ACTION.NONE

	for _, upgrade in pairs(self.upgrades) do
		if upgrade.onStart then
			upgrade:active(self)
		end
	end

	for _, item in pairs(self.items) do
		if item.initialQuantity ~= nil then
			item.quantity = item.initialQuantity
		end
	end
end

function Oponent:discardItem(item)
	for k, v in pairs(self.usedItems) do
		if v == item then
			self.usedItems[k] = nil
		end
	end
end

function Oponent:discardUpgrade(upgrade)
	for k, v in pairs(self.upgrades) do
		if v == upgrade then
			self.upgrades[k] = nil
		end
	end
end

return Oponent
