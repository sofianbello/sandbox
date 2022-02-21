#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform sampler2D u_image;
varying vec2 vUv;

void main(){
    vec3 color = vec3(0.0);
    vec2 st = gl_FragCoord.xy / u_resolution;

    color.rg = st*u_mouse;

    gl_FragColor = vec4(color,1.0);
}