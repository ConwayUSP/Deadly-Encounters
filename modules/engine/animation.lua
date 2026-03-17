----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")

----------------------------------------
-- Classe Animation
----------------------------------------

Animation = {}
Animation.__index = Animation

-- cria uma animação com as configurações passadas como argumento
function Animation.new(frames, frameDur, looping, loopFrame, frameDim)
	local animation = setmetatable({}, Animation)

	animation.frames = frames
	animation.frameDur = frameDur
	animation.looping = looping
	animation.loopFrame = loopFrame
	animation.frameDim = frameDim
	animation.currFrame = 1
	animation.timer = 0
	animation.onFinish = nil

	return animation
end

-- atualiza o timer, o frame atual, e chama o callback `onFinish`
-- se for a hora
function Animation:update(dt)
	self.timer = self.timer + dt
	if self.timer > self.frameDur then
		self.timer = 0
		self.currFrame = self.currFrame + 1

		if self.currFrame > #self.frames then
			if self.looping then
				self.currFrame = self.loopFrame
			else
				self.currFrame = #self.frames
				if self.onFinish then
					self.onFinish(self)
				end
			end
		end
	end
end

-- volta a animação ao primeiro frame
function Animation:reset()
	self.currFrame = 1
end

----------------------------------------
-- Funções Globais
----------------------------------------

-- cria uma animação com o spritesheet na localização indicada
-- por `path` e as configurações dadas por `settings`
function newAnimation(path, settings)
	local sheetImg = love.graphics.newImage(path)
	local frames = {}
	local gap = 4
	local sWidth = sheetImg:getWidth()
	local sHeight = sheetImg:getHeight()
	local qWidth = settings.quadSize.width
	local qHeight = settings.quadSize.height
	local i = 0

	for y = 0, sHeight - qHeight, qHeight + gap do
		for x = 0, sWidth - qWidth, qWidth + gap do
			i = i + 1
			if i > settings.numFrames then
				goto createanimation
			end

			table.insert(frames, love.graphics.newQuad(x, y, qWidth, qHeight, sWidth, sHeight))
		end
	end

	::createanimation::
	return Animation.new(frames, settings.frameDur, settings.looping, settings.loopFrame, settings.quadSize)
end

-- cria uma cofiguração de animação, usada para criar novas animações
function newAnimSetting(numFrames, quadSize, frameDur, looping, loopFrame)
	return {
		numFrames = numFrames,
		quadSize = quadSize,
		frameDur = frameDur,
		looping = looping,
		loopFrame = loopFrame,
	}
end

-- atrela uma animação com configuração `setting` à ação
-- `action` da entidade `entity`. `path` é o caminho para
-- o sprite sheet da animação
function addAnimation(entity, path, action, settings)
	local animation = newAnimation(path, settings)
	entity.animations[action] = animation
	entity.spriteSheets[action] = love.graphics.newImage(path)
end

function pathlizeName(s)
	local str = string.lower(string.gsub(s, " ", "_"))
	return string.gsub(str, "'", "_")
end

-- transforma uma lista de pastas e um nome de arquivo em um caminho para o arquivo
function pngPathFormat(parts)
	local path = ""
	for i, v in ipairs(parts) do
		if i ~= #parts then
			path = path .. pathlizeName(v) .. "/"
		else
			path = path .. pathlizeName(v) .. ".png"
		end
	end
	return path
end

-- inicializa as "animações" de um player ou oponente
function initCreatureAnimations(creature)
	creature.animations = {}
	creature.spriteSheets = {}
	-- todos os spritesheets terão o mesmo tamanho e apenas 1 frame
	local spriteSize = { width = 256, height = 512 }
	local animSettings = newAnimSetting(1, spriteSize, 0.1, true, 1)

	-- adiciona os sprites e animações de cada ação (NONE vale como idle)
	for k, state in pairs(ACTION) do
		local path = pngPathFormat({ "assets", creature.name, state })
		addAnimation(creature, path, state, animSettings)
	end
end

return Animation
