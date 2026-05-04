// This shader dither the screen at half resolution and add scanlines.
// This shader is built for 240p games on 480p CRTs, but can also work with other screens and resolutions.

#version 410 core
precision highp float;

in vec2 v_texcoord;
out vec4 fragColor;

uniform sampler2D tex;
uniform int output;

ivec2 get_coord_from_absolute(vec2 coord, ivec2 size)
{
    vec2 f_size = size;
    return ivec2(coord * f_size);
}

vec2 get_coord_from_pixel(ivec2 coord, ivec2 size)
{
    vec2 f_coord = vec2(coord);
    vec2 f_size = vec2(size);

    return f_coord / f_size + (vec2(0.5f, 0.5f) / f_size);
}

void main()
{
	// Get resolution of screen
	ivec2 screen_size = textureSize(tex, 0);

	// Don't run the shader if the display isn't 480 pixels tall.
	if (screen_size.y > 1000)
	{
		fragColor = texture(tex, v_texcoord);
		return;
	}

    vec2 coord = v_texcoord;
    coord.x -= mod(coord.x, 1.0f / 320.0f);
    coord.x += 1.5f;
    coord.x /= 4.0f;
    coord.y += 0.5f / 240.0f;

    fragColor = texture(tex, coord);
}
