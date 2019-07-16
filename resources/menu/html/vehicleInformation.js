Vue.component('vehicle-information', {    
    data() {
      return {};
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