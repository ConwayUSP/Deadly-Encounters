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
function applyAction(attacker, alvo)
	local attackerAction = attacker.action
	local targetAction = alvo.action

	if attackerAction == ACTION.RECHARGE then
		reload(attacker)
	elseif attackerAction == ACTION.ATK then
		if targetAction == ACTION.COUNTER then
			attack(attacker)
		else
			attack(alvo)
			spendAmmo(attacker)
		end
	elseif attackerAction == ACTION.HEAVY_ATK then
		if targetAction == ACTION.COUNTER then
			heavyAttack(attacker)
		else
			heavyAttack(alvo)
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
end

function attack(alvo)
	if alvo.action ~= ACTION.DEFENSE then
		alvo.hp = alvo.hp - 40
	end
end

function heavyAttack(alvo)
	if alvo.action ~= ACTION.DEFENSE then
		alvo.hp = alvo.hp - 80
	else
		alvo.hp = alvo.hp - 30
	end
end

function spendAmmo(creature)
	if creature.action == ACTION.ATK then
		creature.ammo = creature.ammo - 1
	elseif creature.action == ACTION.HEAVY_ATK then
		creature.ammo = creature.ammo - 2
	end
end

function cure(creature)
	creature.hp = creature.hp + 60
end
