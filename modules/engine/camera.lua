Camera = {}
Camera.__index = Camera

function Camera.new()
  local self = setmetatable({}, Camera)

  self.x = 0
  self.y = 0

  self.rotation = 0
  self.scale = 1

  self.shakeEnabled = true

  self.shakeIntensity = 0
  self.shakeDuration = 0
  self.shakeTimer = 0

  self.shakeX = 0
  self.shakeY = 0

  return self
end

function Camera:update(dt)
  if self.shakeTimer > 0 then
    self.shakeTimer = self.shakeTimer - dt

    self.shakeX = love.math.random(-self.shakeIntensity, self.shakeIntensity)

    self.shakeY = love.math.random(-self.shakeIntensity, self.shakeIntensity)

    if self.shakeTimer <= 0 then
      self.shakeX = 0
      self.shakeY = 0
    end
  end
end

function Camera:isShakeEnabled()
  return self.shakeEnabled
end

function Camera:toggleShake()
  self.shakeEnabled = not self.shakeEnabled
end

function Camera:shake(intensity, duration)
  if not self.shakeEnabled then
    return
  end

  self.shakeIntensity = intensity
  self.shakeDuration = duration
  self.shakeTimer = duration
end

function Camera:attach()
  love.graphics.push()

  love.graphics.translate( -self.x + self.shakeX, -self.y + self.shakeY )

  love.graphics.rotate(self.rotation)

  love.graphics.scale(self.scale, self.scale)
end

function Camera:detach()
  love.graphics.pop()
end