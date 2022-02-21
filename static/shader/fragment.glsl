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

    gl_FragColor = vec4(st.x,st.y,0.0,1.0);
}