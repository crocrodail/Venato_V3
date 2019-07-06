new Vue({
    el : '#app',
    data: {
        interval: {},
        food: 50,
        water: 9,
        fuel: 5,
        carDamage: 57,
        alcool: 25,
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
        console.log("event : "+ JSON.stringify(event.data));
        if(event.data.action === "eat"){
          this.food += event.data.quantity;          
        }
        else if(event.data.action === "drink"){
          this.water += event.data.quantity;          
        }
        else if(event.data.action === "alcool"){
          this.alcool += event.data.quantity;          
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