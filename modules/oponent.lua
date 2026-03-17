----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.inventory")

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
	oponent.inventory = Inventory.new(items, upgrades)
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
	self.action = ACTION.NONE

	for _, upgrade in pairs(self.inventory.upgrades) do
		if upgrade.onStart then
			upgrade:active(self)
		end
	end

	for _, item in pairs(self.inventory.items) do
		if item.initialQuantity ~= nil then
			item.quantity = item.initialQuantity
		end
	end
end

function Oponent:useBuff(buff)
	if buff.quantity <= 0 then
		return
	end

	buff.quantity = buff.quantity - 1
	self.inventory:addToUsed(buff)
end

return Oponent
