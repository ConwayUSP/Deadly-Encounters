----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")

----------------------------------------
-- ENUM de Items e Upgrades
----------------------------------------

BUFF_TYPE = {}
BUFF_TYPE.UPGRADE = "upgrade"
BUFF_TYPE.ITEM    = "item"

UPGRADE = {}
UPGRADE.PARRY = "parry"
UPGRADE.SHIELD = "shield"
UPGRADE.DEFIBRILLATOR = "defibrillator"
UPGRADE.REVERSE_CARD = "reverse card"
UPGRADE.LUCK_TOTEM = "luck totem"
UPGRADE.STOPWATCH = "stopwatch"

ITEM = {}
ITEM.FLASHBANG = "flashbang"
ITEM.POTION = "potion"
ITEM.ENERGY_DRINK = "energy drink"

----------------------------------------
-- Entidade Item/Upgrade
----------------------------------------

ItemUpgrade = {}
ItemUpgrade.__index = ItemUpgrade

-- cria um novo buff, o id é um dos enums acima
function ItemUpgrade.new(id, desc, effectFunc, type, quantity, onStart)
	local buff = setmetatable({}, ItemUpgrade)
	buff.id = id
	buff.desc = desc
	buff.activate = effectFunc
	buff.onStart = onStart or false
	buff.type = type
	-- quantidade só faz sentido para itens; upgrades podem ignorar esse campo
	buff.initialQuantity = quantity or 1
	buff.quantity = buff.initialQuantity

	local spritePath = pngPathFormat({ "assets", "buffs", id })
	buff.sprite = love.graphics.newImage(spritePath)

	return buff
end


-- usar um item o coloca na lista de usedItems, o qual será ativado somente na hora do combate
function ItemUpgrade:use(creature)
	-- apenas itens são usados ativamente; upgrades são passivos ou disparados por eventos
	if self.type ~= BUFF_TYPE.ITEM then
		return
	end

	if self.quantity and self.quantity > 0 then
		creature.usedItems = creature.usedItems or {}
		table.insert(creature.usedItems, self)
		self.quantity = self.quantity - 1
	end
end

-- na hora do combate, ativa o efeito do item/upgrade e o discarta
function ItemUpgrade:active(creature, oponente)
	self.activate(creature, oponente)

	-- itens de uso único saem do inventário após ativar
	if self.type == BUFF_TYPE.ITEM then
		creature:discardItem(self)
	-- upgrades específicos que se consomem (como o desfibrilador)
	elseif self.type == BUFF_TYPE.UPGRADE and self.id == UPGRADE.DEFIBRILLATOR then
		creature:discardUpgrade(self)
	end
end
