----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")
require("modules.inventory")

----------------------------------------
-- Entidade Player
----------------------------------------

Player = {}
Player.__index = Player

Player.name = "you"
Player.maxHp = 100
Player.hp = Player.maxHp
Player.maxCounters = 3
Player.counters = Player.MaxCounters
Player.ammo = 0
Player.defCount = 0
Player.dmgMult = 1
Player.action = ACTION.NONE
Player.inventory = Inventory.new()
initCreatureAnimations(Player)

function Player:resetForBattle()
	self.hp = self.maxHp
	self.counters = self.maxCounters
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
		item.quantity = item.initialQuantity
	end
end

function Player:getBuff(buff)
	self.inventory:insert(buff)
end

function Player:useBuff(buff)
	if buff.quantity <= 0 then
		return
	end

	buff.quantity = buff.quantity - 1
	self.inventory:addToUsed(buff)
end

function Player:draw(pos)
	local animation = self.animations[self.action]
	local quad = animation.frames[animation.currFrame]
	local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}
	love.graphics.draw(self.spriteSheets[self.action], quad, pos[1], pos[2], 0, 1, 1, offset.x, offset.y)
end

return Player
