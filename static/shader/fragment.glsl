#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform sampler2D u_image;
varying vec2 vUv;

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
    return vec2(
      cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
      cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}

void main(){
    vec2 st = gl_FragCoord.xy / u_resolution;
    /**
    * Type A
    */
    float barX = mod(vUv.x * 10.0-0.2, 1.0);
    float barY = step(0.5, mod(vUv.y * 10.0, 1.0)) * step(0.4, mod(vUv.y *10.0-0.2, 1.0));
    float typeA1 = barX;
    float typeA2 = barY;
    float typeA3 = barX+barY;
    
    /**
    * Type B
    */
    
    vec2 gridUv = vec2(floor(vUv.x * 10.0) / 10.0, floor(vUv.y  * 10.0) / 10.0);
    float typeB = random(gridUv);
    /**
    * Type C
    */

    vec2 rotatedUv = rotate(vUv, PI * 0.25, vec2(0.5));
    float typeC = 0.025 / (distance(vec2(rotatedUv.x, (rotatedUv.y-0.5) * 5.0+0.5), vec2(0.5)));
    typeC *= 0.35 / (distance(vec2(rotatedUv.y, (rotatedUv.x-0.5) * 5.0+0.5), vec2(0.5)));
    
    gl_FragColor = vec4(vec3(typeA3),1.0);
}