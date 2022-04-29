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
      geometry: undefined,
      shader: undefined,

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
      // this.debug.open(false)
      


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
      
      


      /**
       * Renderer
       */
      
      this.renderer = new THREE.WebGLRenderer({alpha: true}); // For Transperancy add: { alpha: true }
      // this.renderer.setClearColor(new THREE.Color(0x151515)); // Set Canvas BG-Color
      this.renderer.setSize(window.innerWidth, window.innerHeight);
      this.renderer.setPixelRatio(window.devicePixelRatio)

      this.orbitControls = new THREE.OrbitControls(this.camera, this.renderer.domElement);
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
      
      const myObjects = { 
        sphere: new THREE.SphereGeometry(18,24,64),
        cube: new THREE.BoxGeometry(24,24,24), 
        torus: new THREE.TorusGeometry(20,7,64, 25)}
      
        this.objectController = { 
        a: myObjects.sphere, 
        b: myObjects.cube, 
        c: myObjects.torus, 
        // cube: new THREE.BoxGeometry(25,25,25),
        // torus: new THREE.TorusGeometry(12,5,64,25)
        }     
        this.shader = new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: vertex,
        fragmentShader: fragment,
        wireframe: false,
        side: THREE.DoubleSide

        })



      // Update u_mouse Value
      window.addEventListener('mousemove', function(e) {
        // this.shader.uniforms.u_mouse.value.set(e.screenX / window.innerWidth, 1 - e.screenY / window.innerHeight)
      })
      

      

      
      // Add Debug Menu

      const objectMenu = this.debug.addFolder('Object Menu')
      console.log(myObjects.sphere);
      objectMenu.add(this.objectController, 'geometry', [myObjects.sphere, myObjects.cube, myObjects.torus ])
      .onChange(this.updateObject)



      // Call animate function
      this.render()
    },
      updateObject(){
        if (this.objectController.geometry === this.objectController.a) {
          if (this.mesh){
            console.log('MESH DETECTED !!!');
            this.clearObject()
          }else {
            console.log('creating a sphere');
            this.mesh = new THREE.Mesh(this.objectController.a,this.shader)
            this.scene.add(this.mesh)
            this.animate()
        }

        }else if (this.objectController.geometry === this.objectController.b) {
          if (this.mesh){
            console.log('MESH DETECTED !!!');
            this.clearObject()
          }else {
            console.log( 'a cube')
            this.mesh = new THREE.Mesh(this.objectController.b,this.shader) 
            this.scene.add(this.mesh)
            this.animate()
          }
        }else{
          if (this.mesh){
            console.log('MESH DETECTED !!!');
            this.clearObject()
          }else {
          this.mesh = new THREE.Mesh(this.objectController.c,this.shader) 
          this.scene.add(this.mesh)
          this.animate()
          }

          }

        
        // this.scene.add(this.mesh)

      },

      clearObject(){
        console.log(this.scene.children[0]);
        this.scene.children[0].dispose()
        this.mesh.material.dispose()
      },


      animate(){
        requestAnimationFrame( this.animate );
        const clock = new THREE.Clock()
        clock.running = true;
        this.uniforms.u_time.value = clock.getElapsedTime();
        const time = this.uniforms.u_time.value;
        this.mesh.rotation.y = time * 0.05;
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
        
        generate(){
          this.mesh = new THREE.Mesh(this.geometry.torus,this.shader);
          this.scene.add(this.mesh)
        },
  },
    

  };
</script>

