brightnessShader = love.graphics.newShader[[
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{
			vec4 texcolor = Texel(texture, texture_coords);
			return texcolor + vec4(0.2, 0.2, 0.2, 0.0);
	}
]]