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
	text.lifetime = lifetime
	text.customUpdate = updateFunc
	text.isOver = false

	return text
end

function Text:update(dt)
	self:customUpdate(dt)
	self.lifetime = self.lifetime - dt
	if self.lifetime <= 0 then
		self.isOver = true
	end
end
