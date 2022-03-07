#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform sampler2D u_image;
varying vec2 vUv;

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(){
    vec2 st = gl_FragCoord.xy / u_resolution;

    float barX = step(0.4, mod(vUv.x * 10.0 - 0.2, 1.0) ) * step(0.8, mod(vUv.y * 10.0, 1.0));
    float barY = step(0.8, mod(vUv.x * 10.0 , 1.0) ) * step(0.4, mod(vUv.y * 10.0 - 0.2, 1.0));
    float circle = 1.0 - step(0.01, abs( distance(vUv, vec2(0.5)) - 0.25));

    vec2 wavedUv = vec2(
        vUv.x + sin(vUv.x * mod(cos(u_time)*(PI),.0)) * 0.1,
        vUv.y + sin(vUv.x * mod(sin(u_time)*(2.0*PI),.0)) * 0.1
    );

    float anima = 1.0 - step(0.01, abs( distance(wavedUv, vec2(0.5)) - 0.25));
    float strength = barX + anima;

    gl_FragColor = vec4(vec3(strength), 1.0);
}