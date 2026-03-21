----------------------------------------
-- Estado Confronto
----------------------------------------

Combat = {}
Combat.WIN = "vitoria"
Combat.LOSS = "derrota"
Combat.ONGOING = "inacabado"

----------------------------------------
-- Funções de combate
----------------------------------------

-- simula um turno do combate, retornando o resultado do combate após o turno
function simulateTurn(player, oponent, hist)
	oponent.action = oponent:makeDecision(player, hist)

	useItems(player, oponent)
	useItems(oponent, player)

	invalidPlayerAction = validateAction(player, hist)
	invalidOponentAction = validateAction(oponent, hist)

	-- acao player invalida == VACILO
	if invalidPlayerAction then
		player.action = ACTION.MISS
	end

	-- acao oponent invalida == VACILO
	if invalidOponentAction then
		oponent.action = ACTION.MISS
	end

	applyAction(player, oponent)
	applyAction(oponent, player)

	return combatResult(player, oponent)
end

-- retorna true se a ação for inválida, false caso contrário
function validateAction(creature, hist)
	local action = creature.action

	if action == ACTION.ATK then
		-- sem munição suficiente
		if creature.ammo < 1 then
			return true
		end
	elseif action == ACTION.HEAVY_ATK then
		-- sem munição suficiente
		if creature.ammo < 2 then
			return true
		end
	elseif action == ACTION.COUNTER then
		-- sem contra-ataques restantes
		if creature.counters < 1 then
			return true
		end
	elseif action == ACTION.DEFENSE then
		if creature.defCount >= 2 then
			return true
		end
	end

	return false
end

--
function applyAction(attacker, target)
	local attackerAction = attacker.action
	local targetAction = target.action

	if attackerAction == ACTION.RECHARGE then
		reload(attacker)
	elseif attackerAction == ACTION.ATK then
		if targetAction == ACTION.COUNTER then
			attack(attacker, target)
			-- TODO: som contra-ataque

		else
			attack(target, attacker)
			spendAmmo(attacker)
		end
	elseif attackerAction == ACTION.HEAVY_ATK then
		if targetAction == ACTION.COUNTER then
			heavyAttack(attacker, target)
			-- TODO: som contra-ataque
		else
			heavyAttack(target, attacker)
			spendAmmo(attacker)
		end
	elseif attackerAction == ACTION.COUNTER then
		attacker.counters = attacker.counters - 1
	end
end

function combatResult(player, oponent)
	if player.hp <= 0 then
		return Combat.LOSS
	elseif oponent.hp <= 0 then
		return Combat.WIN
	else
		return Combat.ONGOING
	end
end

-- ativa os itens que estão em usedItems
function useItems(creature, oponent)
	for _, buff in pairs(creature.inventory.usedQueue) do
		if buff.type == BUFF_TYPE.ITEM then
			buff:activate(creature, oponent)
		end
	end
end

----------------------------------------
-- Habilidades
----------------------------------------

function reload(creature)
	creature.ammo = creature.ammo + 1
	-- TODO: som recarregar
end

function attack(target, attacker)
	if target.action ~= ACTION.DEFENSE then
		causeDamage(target, 40, attacker)
	else
		local parry = target:hasUpgrade(UPGRADE.PARRY)
		if parry then
			parry:activate(target, 1)
		end
	end
end

function heavyAttack(target, attacker)
	if target.action ~= ACTION.DEFENSE then
		causeDamage(target, 80, attacker)
	else
		local parry = target:hasUpgrade(UPGRADE.PARRY)
		if parry then
			parry:activate(target, 1)
		end
		causeDamage(target, 30, attacker)
	end
end

function spendAmmo(creature)
	local amount = 0

	if creature.action == ACTION.ATK then
		amount = 1
	elseif creature.action == ACTION.HEAVY_ATK then
		amount = 2
	end

	local totem = creature:hasUpgrade(UPGRADE.LUCKY_TOTEM)
	if totem then
		totem:activate(creature, amount)
	end

	creature.ammo = creature.ammo - amount
end

function cure(creature)
	if creature.hp + 60 <= creature.maxHp then
		creature.hp = creature.hp + 60
	else
		creature.hp = creature.maxHp
	end
end

function causeDamage(target, dmg, attacker)
	if target.shielded then
		target.shielded = false
		-- TODO: som escudo quebrado

		return
	end

	dmg = dmg * attacker.dmgMult

	if target.hp - dmg < 0 then
		local defibrillator = target:hasUpgrade(UPGRADE.DEFIBRILLATOR)
		if defibrillator then
			defibrillator:activate(target)
		else 
			target.hp = 0
		end
	else
		target.hp = target.hp - dmg
		-- TODO: som de dano

	end
end
