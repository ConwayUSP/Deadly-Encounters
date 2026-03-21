----------------------------------------
-- Enum Acoes
----------------------------------------

ACTION = {}
ACTION.NONE = "none"
ACTION.RECHARGE = "recarregar"
ACTION.ATK = "ataque"
ACTION.HEAVY_ATK = "ataque_pesado"
ACTION.DEFENSE = "defesa"
ACTION.COUNTER = "contra_ataque"
ACTION.MISS = "vacilo"

ACTION_IDX = {}
ACTION_IDX[1] = ACTION.ATK
ACTION_IDX[2] = ACTION.DEFENSE
ACTION_IDX[3] = ACTION.RECHARGE
ACTION_IDX[4] = ACTION.HEAVY_ATK
ACTION_IDX[5] = ACTION.COUNTER
ACTION_IDX[6] = ACTION.MISS
