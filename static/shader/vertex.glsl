uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
varying vec2 vUv;
void main(){
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4((position.x),position.y,position.z, 1.0);
}