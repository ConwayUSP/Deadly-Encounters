----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.constructors.oponents")
require("modules.inventory")
require("modules.constructors.oponents")

----------------------------------------
-- Classe Oponente
----------------------------------------

Oponent = {}
Oponent.__index = Oponent

function Oponent.new(name, maxHP, maxCounters, items, upgrades, strategyFunc)
	local oponent = setmetatable({}, Oponent)

	oponent.name = name
	oponent.maxHp = maxHP
	oponent.hp = maxHP
	oponent.maxCounters = maxCounters
	oponent.counters = maxCounters
	oponent.defCount = 0
	oponent.dmgMult = 1
	oponent.makeDecision = strategyFunc
	oponent.ammo = 0
	oponent.inventory = Inventory.new(items, upgrades)
	oponent.action = ACTION.NONE
	initCreatureAnimations(oponent)

	-- ativa os upgrades para o oponente já surgir buffado
	for _, upgrade in pairs(oponent.inventory.upgrades) do
		if upgrade.onStart then
			upgrade:active(oponent)
		end
	end

	return oponent
end

function Oponent:useBuff(buff)
	if buff.quantity <= 0 then
		return
	end

	buff.quantity = buff.quantity - 1
	self.inventory:addToUsed(buff)
end

function generateOponentPool()
	local pool = {
		initAberration(),
		initArchibald(),
		initDjabo(),
		initJoshua(),
		initOZard(),
		initLarry(),
		initSebastiao(),
	}

	-- randomiza a ordem dos oponentes
	local len = #pool
	for i = len, 2, -1 do
		local j = math.random(i)
		pool[i], pool[j] = pool[j], pool[i]
	end
	return pool
end

return Oponent
