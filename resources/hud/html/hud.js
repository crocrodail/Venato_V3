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
        },
        speed: 50,
        showMiniSpeedmeter: false,
        showSpeedmeter: false
    },
    beforeDestroy () {
      clearInterval(this.interval)
    },
    created() {
      window.addEventListener('resize', this.handleResize)
      window.addEventListener('message', this.handleMessage)
      this.handleResize();
      Noty.overrideDefaults({
          layout   : 'topRight',
          theme    : 'sunset',
          id: 'notifVenato',
          animation: {
              open : 'animated fadeInRight',
              close: 'animated fadeOutRight'
          },
          timeout: 3000
      });
      Noty.setMaxVisible(5); 
    },
    destroyed() {
      window.removeEventListener('resize', this.handleResize)
      window.removeEventListener('message', this.handleMessage)
    },
    mounted () {
      google.load('visualization', '1', {packages: ['gauge']}); 
      google.setOnLoadCallback(this.drawChart);
    },
    methods: {
      handleResize() {
        this.window.width = window.innerWidth;
        this.window.height = window.innerHeight;
      },
      handleMessage(event) {
        if(event.data.action === "enterCar"){
          this.playerIsInVehicule = true;
        }
        else if(event.data.action === "leaveCar"){
          this.playerIsInVehicule = false;
        }
        else if(event.data.action === "vehiculeStatus"){
          this.fuel = event.data.fuel;
          this.carDamage = Math.round(event.data.carHealth / 10);
          this.speed = Math.round(event.data.speed);
        }
        else if(event.data.action === "speed"){
          this.speed = Math.round(event.data.speed);
        }
        else if(event.data.action === "playerStatus"){
          this.water = event.data.water;
          this.food = event.data.food;
          this.alcool = event.data.alcool;
        }
        else if(event.data.action === "toggleMiniSpeedmeter"){
          this.showMiniSpeedmeter = event.data.value;
        }
        else if(event.data.action === "toggleSpeedmeter"){
          this.showSpeedmeter = event.data.value;
        }
        else if(event.data.action === "notify"){
          var n = new Noty({
            title : event.data.title,
            type     : event.data.type,
            logo : event.data.logo,
            text     : event.data.message,
            timeout : event.data.timeout
          }); 

          if(event.data.logo){
            n.on('onTemplate',(a) => {
              n.barDom.innerHTML = '<div id="notifVenato" class="noty_bar noty_type__'+n.options.type+' noty_theme__sunset noty_close_with_click noty_has_progressbar"><div class="noty_logo"><img width="50px" src="'+n.options.logo+'"></v-img></div><div class="noty_title">'+n.options.title+'</div><div class="noty_body">'+n.options.text+'</div><div class="noty_progressbar"></div></div>';
            })
          }else if(event.data.title){
            n.on('onTemplate',(a) => {
              n.barDom.innerHTML = '<div id="notifVenato" class="noty_bar noty_type__'+n.options.type+' noty_theme__sunset noty_close_with_click noty_has_progressbar"></div><div class="noty_title">'+n.options.title+'</div><div class="noty_body">'+n.options.text+'</div><div class="noty_progressbar"></div></div>';
            })
          } 
          n.show();
        }
      },
      drawChart() {

        var data = google.visualization.arrayToDataTable([
          ['Label', 'Value'],
          ['Vitesse', 80]
        ]);

        var chart = new google.visualization.Gauge(document.getElementById('chart_div'));
        
        var options = {
          animation: {
            duration: 0, easing: "linear"
          },
          forcelFrame: true,
          width: 400, height: 120,
          min: 0, max: 240,
          redFrom: 180, redTo: 240,
          minorTicks: 5, majorTicks: 10
        };

        setInterval(function() {
          data.setValue(0, 1, document.getElementById('speed').value);
          chart.draw(data, options)
        }, 50);
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
