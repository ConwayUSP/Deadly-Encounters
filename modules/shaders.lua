brightnessShader = love.graphics.newShader([[
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{
			vec4 texcolor = Texel(texture, texture_coords);
			return texcolor + vec4(0.2, 0.2, 0.2, 0.0);
	}
]])

darknessShader = love.graphics.newShader([[
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{
		vec4 texcolor = Texel(texture, texture_coords);
		return texcolor - vec4(0.1, 0.3, 0.3, 0.0);
	}
]])

redBordersShader = love.graphics.newShader([[
	uniform float playerHP;
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{
		float playerHPNormal = playerHP / 200.0;
		float centerDist = sqrt(pow(screen_coords.x - 960.0, 2.0) + pow(screen_coords.y - 580.0, 2.0));
		float redness = centerDist - 800.0;
		redness = redness / 300.0;
		redness = pow(redness, 2.0);
		redness = redness - playerHPNormal;
		if(redness < 0.0) {
			redness = 0.0;
		}
		
		vec4 texcolor = Texel(texture, texture_coords);

		if(centerDist < 800.0) {
			return texcolor;
		} else {
			return texcolor - vec4(redness / 3.0, redness, redness, 0.0);
		}
	}
]])

whiteShader = love.graphics.newShader([[
	uniform vec4 fillColor;

	// passa por cada pixel da imagem e decide a cor final
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 pixel = Texel(texture, texture_coords);
		float a = pixel.a;

		if (a <= 0.0) return vec4(0.0);

		return vec4(fillColor.rgb, fillColor.a * a) * color;
	}

]])
