----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")

----------------------------------------
-- ENUM de Items e Upgrades
----------------------------------------

BUFF_TYPE = {}
BUFF_TYPE.UPGRADE = "upgrade"
BUFF_TYPE.ITEM = "item"

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
	buff.description = desc
	buff.applyEffect = effectFunc
	buff.onStart = onStart or false
	buff.type = type
	buff.initialQuantity = quantity or 1
	buff.quantity = buff.initialQuantity

	local spritePath = pngPathFormat({ "assets", "buffs", id })
	buff.sprite = love.graphics.newImage(spritePath)

	return buff
end

-- na hora do combate, ativa o efeito do item/upgrade e o discarta
function ItemUpgrade:activate(creature, oponent)
	self.applyEffect(creature, oponent)
	creature.inventory:discardBuff(self)
end
