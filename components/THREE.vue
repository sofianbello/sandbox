<template>
    <div id="three" ref="threeElement">
    </div>
</template>

<script>
import * as THREE from "three-full";
import GUI from 'lil-gui';
import vertex from '../static/shader/vertex.glsl'
import fragment from '../static/shader/fragment.glsl'


export default {
  components: {},
  data() {
    return {

      /** 
       * Set  "this." Variables
       * Strictly necessary
      */

      container: undefined,
      scene: undefined,
      textureCube: undefined,
      camera: undefined,
      renderer: undefined,
      uniforms: undefined,

      /** 
       * Optional
      */

      debug: undefined,
      mesh: undefined,
      sizeX: undefined,
      sizeY: undefined,
      mouseX: undefined,
      mouseY: undefined,
      loader: undefined,
      orbitControls: undefined,
    };
  },
mounted() {      //Initial Function (Will be executed immeadiatly on page load)
    this.setup(); // Setup Environment
    this.$refs.threeElement.appendChild(this.renderer.domElement); // hook the renderer to our <div id="three" ref="threeElement">
  },
  methods: {
    setup() {

      /** 
       * Assign Variables
      */

      this.sizeX = window.innerHeight;
      this.sizeY = window.innerHeight1;
      this.mouseX = 0;
      this.mouseY = 0;

      /**
       * Event Listeners
      */

      document.addEventListener('mousemove', this.onDocumentMouseMove)

      /** 
       * Scene
      */ 

      this.container = document.getElementById( 'three' );
      this.scene = new THREE.Scene();

      /**
       * Debug
       */

      this.debug = new GUI()
      this.debug.open(false)

      /**
       * Camera
       */

      this.camera = new THREE.PerspectiveCamera(
        75,
        window.innerWidth / window.innerHeight,
        0.1,
        1000
      );
      this.camera.position.z = 50;
      const camera= this.debug.addFolder('Camera')
      camera.add(this.camera.position, 'x').name('Position X')
      camera.add(this.camera.position, 'y').name('Position Y')
      camera.add(this.camera.position, 'z').name('Position Z')
      camera.add(this.camera.rotation, 'x').name('Rotation X')
      camera.add(this.camera.rotation, 'y').name('Rotation Y')
      camera.add(this.camera.rotation, 'z').name('Rotation Z')

      /**
       * Renderer
       */

      this.renderer = new THREE.WebGLRenderer({alpha: true}); // For Transperancy add: { alpha: true }
      // this.renderer.setClearColor(new THREE.Color(0x151515)); // Set Canvas BG-Color
      this.renderer.setSize(window.innerWidth, window.innerHeight);
      this.renderer.setPixelRatio(window.devicePixelRatio)

      this.objects();
    },

    objects(){

      /**
       * Loaders
       */

      this.loader = new THREE.TextureLoader()

      /**
       * Textures
      */

      const imgTx = this.loader.load('./textures/grass/grasslight-big.jpg');
 
      /**
       * Uniforms
      */
      
      this.uniforms = {
        u_time: { type: 'f', value: 0.0},
        u_mouse: {type: 'v2', value: new THREE.Vector2(0.0, 0.0)},
        u_resolution: {type: 'v2', value: new THREE.Vector2(window.innerWidth, window.innerHeight)
                        .multiplyScalar(window.devicePixelRatio)},
        u_image: {type: 't', value: imgTx},
      }

      /**
       * Mesh
       */

      const geometry = new THREE.BoxBufferGeometry(25,25,25)     
      const shader = new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: vertex,
        fragmentShader: fragment,
        wireframe: false,
        side: THREE.DoubleSide

        })

      // Update u_mouse Value
      window.addEventListener('mousemove', function(e) {
        shader.uniforms.u_mouse.value.set(e.screenX / window.innerWidth, 1 - e.screenY / window.innerHeight)
      })
      
      this.mesh = new THREE.Mesh(geometry,shader)

      // Add Debug Menu
      const object1 = this.debug.addFolder('Mesh')
      object1.add(this.mesh.position, 'x').name('Position X')
      object1.add(this.mesh.position, 'y').name('Position Y')
      object1.add(this.mesh.position, 'z').name('Position Z')
      object1.add(this.mesh.rotation, 'x').name('Rotation X')
      object1.add(this.mesh.rotation, 'y').name('Rotation Y')
      object1.add(this.mesh.rotation, 'z').name('Rotation Z')
      this.scene.add(this.mesh)

      // Call animate function
      this.animate()
    },

      animate(){
        requestAnimationFrame( this.animate );
        const clock = new THREE.Clock()
        clock.running = true;
        this.uniforms.u_time.value = clock.getElapsedTime();
        const timer = this.uniforms.u_time.value;
        this.mesh.rotation.y = Math.PI *timer*0.125;
        this.camera.lookAt( this.scene.position );
				this.render();      
      },

      render(){
        
        
        this.renderer.render( this.scene, this.camera );
        window.addEventListener( 'resize', this.onWindowResize );
        
      },

      onDocumentMouseMove( event ) {
        
        this.mouseX = ( event.clientX - this.sizeX ) / 100;
          this.mouseY = 1 - ( event.clientY - this.sizeY ) / 100;
  
      },
      onWindowResize() {
        
        this.sizeX = window.innerWidth/2
        this.sizeY = window.innerHeight/2
  
        this.camera.aspect = window.innerWidth / window.innerHeight;
        this.camera.updateProjectionMatrix();
  
        this.renderer.setSize( window.innerWidth, window.innerHeight );
        this.render()
  
        },
  },
    

  };
</script>

