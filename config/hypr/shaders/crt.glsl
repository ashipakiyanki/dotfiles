// This shader dither the screen at half resolution and add scanlines.
// This shader is built for 240p games on 480p CRTs, but can also work with other screens and resolutions.

#version 410 core
precision highp float;

#define SCANLINE_OPACITY 	0.000
#define CONTRAST_INCREASE	0.100

in vec2 v_texcoord;
out vec4 fragColor;

uniform sampler2D tex;
uniform int output;

vec4 get_bilinear(vec2 coord, ivec2 screen_size)
{
    return texture(tex, coord + vec2(0.5f / screen_size.x, 0.5f / screen_size.y));
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

	// Sample a pixel and its neighbor to the right, top, and top-right in 240p.
	vec4 colors[2] = vec4[](
		get_bilinear(v_texcoord, screen_size),
		get_bilinear(v_texcoord + vec2(2.0f / screen_size.x, 0), screen_size)
    );

	// Blend the sampled colors
	fragColor = (colors[0] + colors[1]) / 2;
	
	// Add additional contrast to counteract scanlines darkening the screen.
	fragColor *= 1.0 * (1.0 + CONTRAST_INCREASE * (1.0 - SCANLINE_OPACITY));

	// Set the opacity of odd lines to emulate scanlines.
	if (ivec2(v_texcoord * screen_size).y % 2 == 1)
	{
		fragColor = vec4(fragColor.xyz * SCANLINE_OPACITY, 1);
	}
}
