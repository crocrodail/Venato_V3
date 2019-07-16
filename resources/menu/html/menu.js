Vue.config.productionTip = false
Vue.component('v-style', {
  render: function (createElement) {
    return createElement('style', this.$slots.default)
  }
})

Vue.filter('toCurrency', function (value) {
  if (typeof value !== "number") {
    return value;
  }
  var formatter = new Intl.NumberFormat('fr-FR');
  return formatter.format(value);
});

new Vue({
  el: '#app',
  data: {
    window: {
      width: 0,
      height: 0
    },
    background: 'https://www.numerama.com/content/uploads/2017/06/epicerie-magasin-fruit-legume-bio.jpg',
    color: 'rgba(40,162,160,0.65)',
    isDark: true,
    open: false,
    selectedItem: 0,
    title: 'Concessionnaire',
    subtitle: 'Choisissez votre prochaine voiture',
    maxItemsShow: 5,
    items: [
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 1, text: 'Texte' } },
      { title: "Element2", subtitle: "Element2 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 2, text: 'Texte' } },
      { title: "Element3", subtitle: "Element3 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 3, text: 'Texte' } },
      { title: "Element4", subtitle: "Element4 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 4, text: 'Texte' } },
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 5, text: 'Texte' } }
    ],
    showVehicleInformation: false,
    showShopAdmin: false,
    vehicle: {
      name: "Test Aventador 2018",
      price: 100000000,
      price_vp: 2500,
      vp_enabled: true,
      vp_only: true,
      speed: 85,
      acceleration: 45,
      braking: 75,
      handling: 12
    },
    headers: [
      {
        text: 'Dessert (100g serving)',
        align: 'left',
        sortable: false,
        value: 'name'
      },
      { text: 'Calories', value: 'calories' },
      { text: 'Fat (g)', value: 'fat' },
      { text: 'Carbs (g)', value: 'carbs' },
      { text: 'Protein (g)', value: 'protein' },
      { text: 'Iron (%)', value: 'iron' }
    ],
    desserts: [
      {
        name: 'Frozen Yogurt',
        calories: 159,
        fat: 6.0,
        carbs: 24,
        protein: 4.0,
        iron: '1%'
      },
      {
        name: 'Ice cream sandwich',
        calories: 237,
        fat: 9.0,
        carbs: 37,
        protein: 4.3,
        iron: '1%'
      },
      {
        name: 'Eclair',
        calories: 262,
        fat: 16.0,
        carbs: 23,
        protein: 6.0,
        iron: '7%'
      },
      {
        name: 'Cupcake',
        calories: 305,
        fat: 3.7,
        carbs: 67,
        protein: 4.3,
        iron: '8%'
      },
      {
        name: 'Gingerbread',
        calories: 356,
        fat: 16.0,
        carbs: 49,
        protein: 3.9,
        iron: '16%'
      },
      {
        name: 'Jelly bean',
        calories: 375,
        fat: 0.0,
        carbs: 94,
        protein: 0.0,
        iron: '0%'
      },
      {
        name: 'Lollipop',
        calories: 392,
        fat: 0.2,
        carbs: 98,
        protein: 0,
        iron: '2%'
      },
      {
        name: 'Honeycomb',
        calories: 408,
        fat: 3.2,
        carbs: 87,
        protein: 6.5,
        iron: '45%'
      },
      {
        name: 'Donut',
        calories: 452,
        fat: 25.0,
        carbs: 51,
        protein: 4.9,
        iron: '22%'
      },
      {
        name: 'KitKat',
        calories: 518,
        fat: 26.0,
        carbs: 65,
        protein: 7,
        iron: '6%'
      }
    ]
  },
  beforeDestroy() {
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
  mounted() {
  },
  methods: {
    handleResize() {
      this.window.width = window.innerWidth;
      this.window.height = window.innerHeight;
    },
    handleMessage(event) {
      if (event.data.action == "open") {
        this.selectedItem = 0;
        this.open = true;
      } else if (event.data.action == "close") {
        this.open = false;
        this.selectedItem = 0;
      } else if (event.data.action == "up") {
        this.navigateMenuUp()
      } else if (event.data.action == "down") {
        this.navigateMenuDown()
      } else if (event.data.action == "enter") {
        this.confirmNavigation()
      } else if (event.data.action == "clear") {
        this.items = [];
      } else if (event.data.action == "addButton") {
        this.items.push({ title: event.data.name, subtitle: '', confirm: event.data.func, hover: event.data.hover, data: event.data.args })
      } else if (event.data.action == "init") {
        this.title = event.data.title;
        this.subtitle = event.data.subtitle;
        this.color = event.data.color;
        this.background = event.data.background;
      } else if (event.data.action == "title") {
        this.title = event.data.title;
        this.subtitle = event.data.subtitle;
      } else if (event.data.action == "showVehicleInfo") {
        this.vehicle = event.data.vehicle;
        this.showVehicleInformation = true
      } else if (event.data.action == "hideVehicleInfo") {
        this.showVehicleInformation = false
      } else if (event.data.action == "showShopAdmin") {
        this.showShopAdmin = true
      } else if (event.data.action == "hideShopAdmin") {
        this.showShopAdmin = false
      }
    },
    navigateMenuUp() {
      var count = this.items.length;
      if (this.selectedItem === 0) {
        this.selectedItem = count - 1;
        document.getElementById('menuList').scrollTop = 1000000;
      } else {
        this.selectedItem--;
        document.getElementById('menuList').scrollTop = document.getElementById('menuList').querySelector('.selected').offsetTop - 500;
      }
    },
    navigateMenuDown() {
      var count = this.items.length;
      if (this.selectedItem === count - 1) {
        this.selectedItem = 0;
        document.getElementById('menuList').scrollTop = 0;
      } else {
        this.selectedItem++;
        document.getElementById('menuList').scrollTop = document.getElementById('menuList').querySelector('.selected').offsetTop - 250;
      }
    },
    confirmNavigation() {
      if (this.open && this.items.length) {
        var elmnt = this.items[this.selectedItem];
        $.post('http://menu/confirm', JSON.stringify({ data: elmnt }));
      }
    }
  },
  computed: {
    formatedPrice: function () {
      return this.vehicle.price;
    },
    formatedVPrice: function () {
      return this.vehicle.price_vp;
    }
  },
  watch: {
    selectedItem: function (val) {
      if (this.open && this.items.length > 0) {
        var elmnt = this.items[val];
        $.post('http://menu/callback', JSON.stringify({ data: elmnt }));
      }
    }
  }
})
