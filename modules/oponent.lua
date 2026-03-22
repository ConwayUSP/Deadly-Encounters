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
			upgrade:activate(oponent)
		end
	end

	return oponent
end

function Oponent:hasUpgrade(upgradeId)
	for _, upgrade in pairs(self.inventory.upgrades) do
		if upgrade.id == upgradeId then
			return upgrade
		end
	end

	return nil
end

function Oponent:hasItem(itemId)
	for _, item in pairs(self.inventory.items) do
		if item.id == itemId and item.quantity > 0 then
			return true
		end
	end
	return false
end

function Oponent:getItem(buffId)
	local item = self.inventory:get(buffId, BUFF_TYPE.ITEM)
	return item
end

function Oponent:useItem(itemId)
	local item = self:getItem(itemId)
	if not item then
		return
	end
	self:useBuff(item)
end

function Oponent:useBuff(buff)
	if buff.quantity <= 0 then
		return
	end

	buff.quantity = buff.quantity - 1
	self.inventory:addToUsed(buff)
end

function Oponent:draw(pos)
	local animation = self.animations[self.action]
	local quad = animation.frames[animation.currFrame]
	local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}
	local scale = 0.75
	love.graphics.draw(self.spriteSheets[self.action], quad, pos[1], pos[2], 0, scale, scale, offset.x, offset.y)
end

function generateOponentPool()
	local pool = {
		initJoshua(),
		initOZard(),
		initDjabo(),
		initLarry(),
		initSebastiao(),
		initAberration(),
	}

	-- randomiza a ordem dos oponentes
	for i = #pool - 1, 2, -1 do
		local j = math.random(2, i)
		pool[i], pool[j] = pool[j], pool[i]
	end
	return pool
end

return Oponent
