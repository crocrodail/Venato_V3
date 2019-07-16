Vue.config.productionTip = false
Vue.component('v-style', {
  render: function (createElement) {
    return createElement('style', this.$slots.default)
  }
})

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
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 5, text: 'Texte' } },
      { title: "Element2", subtitle: "Element2 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 6, text: 'Texte' } },
      { title: "Element3", subtitle: "Element3 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 7, text: 'Texte' } },
      { title: "Element4", subtitle: "Element4 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 8, text: 'Texte' } },
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 9, text: 'Texte' } },
      { title: "Element2", subtitle: "Element2 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 10, text: 'Texte' } },
      { title: "Element3", subtitle: "Element3 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 11, text: 'Texte' } },
      { title: "Element4", subtitle: "Element4 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 12, text: 'Texte' } },
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 13, text: 'Texte' } },
      { title: "Element2", subtitle: "Element2 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 14, text: 'Texte' } },
      { title: "Element3", subtitle: "Element3 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 15, text: 'Texte' } },
      { title: "Element4", subtitle: "Element4 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 16, text: 'Texte' } },
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 17, text: 'Texte' } },
      { title: "Element2", subtitle: "Element2 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 18, text: 'Texte' } },
      { title: "Element3", subtitle: "Element3 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 19, text: 'Texte' } },
      { title: "Element4", subtitle: "Element4 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 20, text: 'Texte' } },
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 21, text: 'Texte' } },
      { title: "Element2", subtitle: "Element2 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 22, text: 'Texte' } },
      { title: "Element3", subtitle: "Element3 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 23, text: 'Texte' } },
      { title: "Element4", subtitle: "Element4 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 24, text: 'Texte' } },
      { title: "Element1", subtitle: "Element1 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 25, text: 'Texte' } },
      { title: "Element2", subtitle: "Element2 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 26, text: 'Texte' } },
      { title: "Element3", subtitle: "Element3 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 27, text: 'Texte' } },
      { title: "Element4", subtitle: "Element4 sous-titre", confirm: "CarShop:confirm", hover: "CarShop:hover", data: { id: 28, text: 'Texte' } },
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
        console.log('open');
        this.open = true;
        this.selectedItem = 0;
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
        this.items.push({ event.data.name, '', event.data.func, event.data.hover, event.data.args})
      } else if (event.data.action == "init") {
        this.title = event.data.title;
        this.subtitle = event.data.subtitle;
        this.color = event.data.color;
        this.background = event.data.background;
      }
    },
    navigateMenuUp() {
      var count = this.items.length;
      if (this.selectedItem === 0) {
        this.selectedItem = count - 1;
        document.getElementById('menuList').scrollTop = 1000000;
      } else {
        this.selectedItem--;
        document.getElementById('menuList').scrollTop = document.getElementById('menuList').querySelector('.selected').offsetTop - 250;
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
      if(this.open){
        var elmnt = this.items[this.selectedItem];
        $.post('http://menu/confirm', JSON.stringify({ data: elmnt }));
        $.post('http://menu/close', JSON.stringify({ data: elmnt }));
      }
    }
  },
  computed: {

  },
  watch: {
    selectedItem: function (val) {  
      if(this.open){    
        var elmnt = this.items[val];      
        $.post('http://menu/callback', JSON.stringify({ data: elmnt }));      
      }
    }
  }
})
