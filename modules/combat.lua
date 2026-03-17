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
function simulaTurno(player, oponente, historico)
	oponente.action = oponente:makeDecision(player, historico)

	usaItems(player, oponente)
	usaItems(oponente, player)

	acao_player_invalida = validaAcao(player, historico)
	acao_oponente_invalida = validaAcao(oponente, historico)

	-- acao player invalida == VACILO
	if acao_player_invalida then
		player.action = ACTION.MISS
	end

	-- acao oponente invalida == VACILO
	if acao_oponente_invalida then
		oponente.action = ACTION.MISS
	end

	realizaAcao(player, oponente)
	realizaAcao(oponente, player)

	return resultadoCombate(player, oponente)
end

-- retorna true se a ação for inválida, false caso contrário
function validaAcao(criatura, historico)
	local acao = criatura.action

	if acao == ACTION.ATK then
		-- sem munição suficiente
		if criatura.ammo < 1 then
			return true
		else
			return false
		end
	elseif acao == ACTION.HEAVY_ATK then
		-- sem munição suficiente
		if criatura.ammo < 2 then
			return true
		else
			return false
		end
	elseif acao == ACTION.COUNTER then
		-- sem contra-ataques restantes
		if criatura.counters < 1 then
			return true
		else
			return false
		end
	elseif acao == ACTION.DEFENSE then
		-- TODO: analisar historico para valdar defesa
		return false
	end

	return false
end

--
function realizaAcao(atacante, alvo)
	local acaoAtacante = atacante.action
	local acaoAlvo = alvo.action

	if acaoAtacante == ACTION.RECHARGE then
		recarga(atacante)
	elseif acaoAtacante == ACTION.ATK then
		if acaoAlvo == ACTION.COUNTER then
			ataque(atacante)
		else
			ataque(alvo)
			gastaMunicao(atacante)
		end
	elseif acaoAtacante == ACTION.HEAVY_ATK then
		if acaoAlvo == ACTION.COUNTER then
			ataquePesado(atacante)
		else
			ataquePesado(alvo)
			gastaMunicao(atacante)
		end
	elseif acaoAtacante == ACTION.COUNTER then
		atacante.counters = atacante.counters - 1
	end
end

function resultadoCombate(player, oponente)
	if player.hp <= 0 then
		return Combat.LOSS
	elseif oponente.hp <= 0 then
		return Combat.WIN
	else
		return Combat.ONGOING
	end
end

-- ativa os itens que estão em usedItems
function usaItems(criatura, oponente)
	for _, item in pairs(criatura.usedItems) do
		item:activate(criatura, oponente)
	end
end

----------------------------------------
-- Habilidades
----------------------------------------

function recarga(criatura)
	criatura.ammo = criatura.ammo + 1
end

function ataque(alvo)
	if alvo.action ~= ACTION.DEFENSE then
		alvo.hp = alvo.hp - 10
	end
end

function ataquePesado(alvo)
	if alvo.action ~= ACTION.DEFENSE then
		alvo.hp = alvo.hp - 20
	else
		alvo.hp = alvo.hp - 10
	end
end

function gastaMunicao(criatura)
	if criatura.action == ACTION.ATK then
		criatura.ammo = criatura.ammo - 1
	elseif criatura.action == ACTION.HEAVY_ATK then
		criatura.ammo = criatura.ammo - 2
	end
end

function cura(criatura)
	criatura.hp = criatura.hp + 15
end
