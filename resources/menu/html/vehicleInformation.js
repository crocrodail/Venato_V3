Vue.component('vehicle-information', {    
    data() {
      return {};
    },
    created() {
      window.addEventListener('message', this.handleMessage)
    },
    destroyed() {
      window.removeEventListener('message', this.handleMessage)
    },
    computed: {
        formatedPrice: function () {
            return this.vehicle.price;
        },
        formatedVPrice: function () {
            return this.vehicle.price_vp;
        }
    },
    methods: {     
    },
    props: {
      vehicle: {
        type: Object,
      },
      color: {
        type: String
      }
    },
});  