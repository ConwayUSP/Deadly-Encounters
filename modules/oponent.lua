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
	oponent.hp = maxHP
	oponent.counters = maxCounters
	oponent.defCount = 0
	oponent.makeDecision = strategyFunc
	oponent.ammo = 0
	oponent.items = items or {}
	oponent.upgrades = upgrades or {}
	oponent.usedItems = {}
	oponent.action = ACTION.NONE
	initCreatureAnimations(oponent)

	return oponent
end

return Oponent
