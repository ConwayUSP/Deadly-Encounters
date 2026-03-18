----------------------------------------
-- Classe Text
----------------------------------------

Text = {}
Text.__index = Text

function Text.new(content, size, color, pos, rotation, centerOffset, lifetime, updateFunc)
	local text = setmetatable({}, Text)

	text.content = content
	text.size = size
	text.color = color
	text.pos = pos
	text.rotation = rotation
	text.centerOffset = centerOffset
	text.timer = lifetime
	text.customUpdate = updateFunc
	text.isOver = false

	return text
end

function Text:update(dt)
	self:customUpdate(dt)
	self.timer = self.timer - dt
	if self.timer <= 0 then
		self.isOver = true
	end
end

function cleanUpTexts(texts)
	for k, v in pairs(texts) do
		if v.isOver then
			texts[k] = nil
		end
	end
end

function Text:draw()
	local font = self.font or love.graphics.getFont()
	love.graphics.setFont(font)

	local content = self.content or ""
	local width = font:getWidth(content)
	local height = font:getHeight()

	local x = self.pos[1]
	local y = self.pos[2]
	local rotation = self.rotation or 0
	local scale = self.scale or 1
	local ox, oy = 0, 0

	if self.centerOffset then
		ox = width / 2
		oy = height / 2
	end

	local color = self.color or { 1, 1, 1, 1 }
	love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
	love.graphics.print(content, x, y, rotation, scale, scale, ox, oy)
end
