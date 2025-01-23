#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec2 scenic;

extern PRECISION number dissolve;
extern PRECISION number time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

extern PRECISION float lines_offset;

vec4 dissolve_mask(vec4 final_pixel, vec2 texture_coords, vec2 uv);

#define PI 3.14159265358979

float influence(float fx, float v, float prev) {
    float influence_threshold = 0.02;
    if (v < fx) {
        return 1.0 - prev;
    }
    float gap = v - fx;
    if (gap > influence_threshold) {
        return 0.0;
    }
    return 1.0 - (gap / influence_threshold);
}

float luma(vec3 color) {
    return dot(color, vec3(0.299, 0.587, 0.114));
}

float luma(vec4 color) {
    return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}

float dither2x2(vec2 position, float brightness) {
    int x = int(mod(position.x, 2.0));
    int y = int(mod(position.y, 2.0));
    int index = x + y * 2;
    float limit = 0.0;

    if (x < 8) {
        if (index == 0) limit = 0.25;
        if (index == 1) limit = 0.75;
        if (index == 2) limit = 1.00;
        if (index == 3) limit = 0.50;
    }

    return brightness < limit ? (limit - brightness) / (2 * limit) : 0.5;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
	vec2 calc_uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.zw)/texture_details.zw;
    vec2 uv = vec2(calc_uv.x, 1 - calc_uv.y);

    float prev = 0.0;
    vec3 rgbc = vec3(0.0, 0.0, 0.0);

    float f1 = cos(PI/2.0f*(uv.x - 0.5)) / 5.0f;
    float infl1 = influence(f1, uv.y, prev);
    prev += infl1;
    vec3 color1 = vec3(0.0, 0.616, 0.796);
    rgbc += infl1 * color1;

    float f2 = cos(PI/2.0f*(uv.x - 0.5)) / 10.0f + 0.3;
    float infl2 = influence(f2, uv.y, prev);
    prev += infl2;
    vec3 color2 = vec3(0.898, 0.835, 0.729);
    rgbc += infl2 * color2;

    float f3 = cos(PI/2.0f*(uv.x - 0.5)) / 20.0f + 0.45;
    float infl3 = influence(f3, uv.y, prev);
    prev += infl3;
    vec3 color3 = vec3(0.514, 0.396, 0.224);
    rgbc += infl3 * color3;

    float f4 = 0.6;
    float infl4 = influence(f4, uv.y, prev);
    prev += infl4;
    vec3 color4 = vec3(0.337, 0.490, 0.275);
    rgbc += infl4 * color4;

    float f5 = 1.0;
    float infl5 = influence(f5, uv.y, prev);
    prev += infl5;
    vec3 color5 = vec3(0.529, 0.808, 0.922);
    rgbc += infl5 * color5;

    vec4 resultMask = vec4(
        rgbc,
        dither2x2(uv, 0.1*cos(PI*scenic.x) + 0.5)
    );

    vec4 outputv = tex.a * (vec4((1.0 - resultMask.a) * tex.rgb, 1) + vec4(resultMask.a * resultMask.rgb, 1));

	return dissolve_mask(outputv, texture_coords, calc_uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif