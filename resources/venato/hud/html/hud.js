new Vue({
    el : '#app',
    data: {
        interval: {},
        playerIsInVehicule: false,
        food: 50,
        water: 50,
        fuel: 50,
        carDamage: 50,
        alcool: 0,
        window: {
          width: 0,
          height: 0
        }
    },
    beforeDestroy () {
      clearInterval(this.interval)
    },
    created() {
      window.addEventListener('resize', this.handleResize)
      window.addEventListener('message', this.handleMessage)
      this.handleResize();
    },
    destroyed() {
      window.removeEventListener('resize', this.handleResize)
      window.removeEventListener('message', this.handleMessage)
    },
    mounted () {
    },
    methods: {
      handleResize() {
        this.window.width = window.innerWidth;
        this.window.height = window.innerHeight;
      },
      handleMessage(event) {
        if(event.data.action === "eat"){
          this.food += event.data.quantity;          
        }
        else if(event.data.action === "drink"){
          this.water += event.data.quantity;          
        }
        else if(event.data.action === "alcool"){
          this.alcool += event.data.quantity;          
        }
        else if(event.data.action === "enterCar"){
          this.playerIsInVehicule = true;
        }
        else if(event.data.action === "leaveCar"){
          this.playerIsInVehicule = false;
        }
        else if(event.data.action === "vehiculeStatus"){
          this.fuel = event.data.fuel;
          this.carDamage = Math.round(event.data.carHealth / 10);
        }
        else if(event.data.action === "playerStatus"){
          this.water = event.data.water;
          this.food = event.data.food;
          this.alcool = event.data.alcool;
        }
      }
    },
    computed: {
      progressSize: function() {
        return this.window.width/47;
      },
      progressWidth: function() {
        return this.window.width/256;
      },
    }    
  })