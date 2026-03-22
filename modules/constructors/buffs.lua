----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.buff")
require("modules.combat")

----------------------------------------
-- Upgrades
----------------------------------------

local buffSounds = {
	-- [UPGRADE.STOPWATCH] = love.audio.newSource("sounds/stopwatch.mp3", "static"),
	[UPGRADE.PARRY] = love.audio.newSource("sounds/parry.mp3", "static"),
	[UPGRADE.LUCKY_TOTEM] = love.audio.newSource("sounds/lucky_totem.mp3", "static"),
	[UPGRADE.DEFIBRILLATOR] = love.audio.newSource("sounds/defibrillator.mp3", "static"),
	[ITEM.FLASHBANG] = love.audio.newSource("sounds/flashbang.mp3", "static"),
	[ITEM.ENERGY_DRINK] = love.audio.newSource("sounds/energy_drink.mp3", "static"),
	[ITEM.POTION] = love.audio.newSource("sounds/potion.mp3", "static"),
}

function initParry()
	--local desc = "Uma defesa bem sucecedida contra o ataque inimigo rouba as munições do oponente para si"
	local desc = "A successful defense against the enemy's attack steals the attack's ammo for yourself"

	-- a verificação da defesa é feita no resultado do combate
	local func = function(criatura, ammo)
		criatura.ammo = criatura.ammo + ammo
		GAMESTATE[CTX.BATTLE]:addPlusAmmoText(criatura, ammo)
		buffSounds[UPGRADE.PARRY]:play()
	end

	return ItemUpgrade.new(UPGRADE.PARRY, desc, func, BUFF_TYPE.UPGRADE)
end

function initShield()
	--local desc = "Reduz o primeiro dano recebido do combate"
	local desc = "Cancels the first damage received in combat"

	local func = function(criatura)
		criatura.shielded = true
	end

	return ItemUpgrade.new(UPGRADE.SHIELD, desc, func, BUFF_TYPE.UPGRADE, nil, true)
end

function initDefibrillator()
	--local desc = "Ressuscita a criatura com 20 HP após ser derrotada"
	local desc = "Ressurects you with 20 HP after being defeated"

	local func = function(criatura)
		criatura.hp = 20
		criatura.defibrilated = true
		criatura.inventory:removeUpgrade(UPGRADE.DEFIBRILLATOR)
		buffSounds[UPGRADE.DEFIBRILLATOR]:play()
	end

	return ItemUpgrade.new(UPGRADE.DEFIBRILLATOR, desc, func, BUFF_TYPE.UPGRADE)
end

function initReverseCard()
	--local desc = "+1 contra-ataque MÁXIMO"
	local desc = "+1 counterattack MAX"

	local func = function(criatura)
		criatura.maxCounters = criatura.maxCounters + 1
		criatura.counters = criatura.maxCounters
	end

	return ItemUpgrade.new(UPGRADE.REVERSE_CARD, desc, func, BUFF_TYPE.UPGRADE, nil, true)
end

function initTotem()
	--local desc = "Há uma chance da munição não ser consumida ao atacar"
	local desc = "There is a chance that your ammo won't be consumed when attacking"

	local CHANCE = 0.25

	local func = function(criatura, ammo)
		if math.random() < CHANCE then
			criatura.ammo = criatura.ammo + ammo
			GAMESTATE[CTX.BATTLE]:addPlusAmmoText(criatura, ammo)
			buffSounds[UPGRADE.LUCKY_TOTEM]:play()
		end
	end

	return ItemUpgrade.new(UPGRADE.LUCKY_TOTEM, desc, func, BUFF_TYPE.UPGRADE)
end

function initStopWatch()
	--local desc = "Aumenta o dano se a habilidade for selecionada perto do tempo acabar"
	local desc = "Increases damage if the ability is selected near the time runs out"

	local func = function(criatura, time)
		if time < 0.5 and not criatura.timedRight then
			criatura.dmgMult = criatura.dmgMult + 0.2
			criatura.timedRight = true
			-- TODO: som disso?
		end
	end

	return ItemUpgrade.new(UPGRADE.STOPWATCH, desc, func, BUFF_TYPE.UPGRADE)
end

----------------------------------------
-- Items
----------------------------------------

function initFlashbang(quantity)
	--local desc = "Cega o oponente, fazendo-o perder seu próximo turno"
	local desc = "Blinds the opponent, making them lose their next turn"
	local qnt = quantity or 1
	local func = function(criatura, alvo)
		alvo.action = ACTION.MISS
		alvo.blinded = true
		buffSounds[ITEM.FLASHBANG]:play()
	end

	return ItemUpgrade.new(ITEM.FLASHBANG, desc, func, BUFF_TYPE.ITEM, qnt)
end

function initPotion(quantity)
	--local desc = "Restaura 10 HP"
	local desc = "Restores 10 HP"
	local qnt = quantity or 3
	local func = function(criatura)
		cure(criatura)
		buffSounds[ITEM.POTION]:play()
	end

	return ItemUpgrade.new(ITEM.POTION, desc, func, BUFF_TYPE.ITEM, qnt)
end

function initEnergyDrink(quantity)
	--local desc = "Deixa o próximo ataque mais forte"
	local desc = "Buffs your next attack"
	local qnt = quantity or 1

	local func = function(criatura)
		criatura.dmgMult = criatura.dmgMult + 0.5
		buffSounds[ITEM.ENERGY_DRINK]:play()
	end

	return ItemUpgrade.new(ITEM.ENERGY_DRINK, desc, func, BUFF_TYPE.ITEM, qnt)
end
