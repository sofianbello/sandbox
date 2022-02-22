#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform sampler2D u_image;
varying vec2 vUv;

void main(){
    vec2 st = gl_FragCoord.xy / u_resolution;
    float strength = mod(vUv.x*10.0,1.0);
    strength = step(0.5, strength);
    gl_FragColor = vec4(vec3(strength),1.0);
}