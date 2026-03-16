----------------------------------------
-- Estado Confronto
----------------------------------------

Combat = {}
Combat.WIN = "vitoria"
Combat.LOSS = "derrota"
Combat.DRAW = "empate"
Combat.ONGOING = "inacabado"

----------------------------------------
-- Funções de combate
----------------------------------------

function iniciaConfronto(player, oponente)
  player:resetForBattle()
  oponente:resetForBattle()
end

-- simula um confronto entre o player e o oponente, atualizando o historico do combate
function simulaConfronto(player, oponente, historico) 
  local resultadoTurno = simulaTurno(player, oponente, historico)
  -- TODO: adicionar ao historico player e oponente

  if resultadoTurno == Combat.ONGOING then
    return
  end
  
  if resultadoTurno == Combat.WIN then
    GameCtx = CTX.SHOP
  elseif resultadoTurno == Combat.LOSS then
    GameCtx = CTX.MENU
  elseif resultadoTurno == Combat.DRAW then
    GameCtx = CTX.MENU
  end

end

-- simula um turno do combate, retornando o resultado do combate após o turno
function simulaTurno(player, oponente, historico)
  oponente.action = oponente:makeDecision(player, historico)

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
  if player.hp <= 0 and oponente.hp <= 0 then
    return Combat.DRAW
  elseif player.hp <= 0 then
    return Combat.LOSS
  elseif oponente.hp <= 0 then
    return Combat.WIN
  else
    return Combat.ONGOING
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