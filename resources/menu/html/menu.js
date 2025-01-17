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
    background: '',
    color: 'rgba(40,162,160,0.65)',
    isDark: true,
    open: false,
    selectedItem: 0,
    oldSelectedItem: 0,
    oldItemsLength: 0,
    title: 'Concessionnaire',
    subtitle: 'Choisissez votre prochaine voiture',
    maxItemsShow: 5,
    items: [
    ],
    showVehicleInformation: false,
    showShopAdmin: false,
    vehicle: {},
    headers: [],
    desserts: [],
    commands: [
      { id:"gnrMenus", title: 'Menus' },
      { id:"interaction", command: 'F1', icon: 'https://i.ibb.co/n7YJR7m/icons8-communication-48px.png', text: 'Intéractions' },
      { id:"phone", command: 'F2', icon: 'https://i.ibb.co/fnN5J8D/icons8-android-48px.png', text: 'Téléphone (nécessite d\'en posséder un)' }      ,
      { id:"enterprise", command: 'F7', icon: 'https://i.ibb.co/TPb9r86/icons8-briefcase-48px.png', text: 'Menu gestion d\'entreprise' }      ,
      { id:"inventory", command: 'K', icon: 'https://i.ibb.co/mhY6QRY/icons8-backpack-48px.png', text: 'Inventaire' }      ,
      { id:"gnrMenuEnd", divider: true }, 
      { id:"gnrCommand", title: 'Commandes' },   
      { id:"speakArea", command: 'F6', icon: 'https://i.ibb.co/sPkSd0K/icons8-voice-48px.png', text: 'Changer volume voix' }      ,  
      { id:"layDown", command: 'CTRL', text: 'S\'allonger au sol / Se relever' }      ,  
      { id:"crouch", command: 'C', text: 'S\'accroupir / Se relever' }      ,  
      { id:"sit", command: 'SHIFT+E', text: 'S\'assoir / Se relever (à coté d\'un siège)' }      ,  
      { id:"cover", command: 'A', icon:'https://i.ibb.co/5FsSN5x/icons8-exit-sign-48px.png', text: 'Se mettre à couvert / Se relever' }      ,  
      { id:"point", command: 'B', icon: 'https://i.ibb.co/8r8G6Wv/icons8-hand-right-48px.png', text: 'Pointer du doigt' }      ,  
      { id:"handUp", command: 'X', icon: 'https://i.ibb.co/pb6fHhL/icons8-hand-48px.png', text: 'Lever les mains' }      ,  
      { id:"gnrCommandEnd", divider: true }, 
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
        this.oldItemsLength = this.items.length;
        this.items = [];
        this.oldSelectedItem = this.selectedItem;
        this.selectedItem = 0;
      } else if (event.data.action == "addButton") {
        this.items.push({ title: event.data.name, subtitle: '', confirm: event.data.func, hover: event.data.hover, data: event.data.args, avatar: undefined })
      } else if (event.data.action == "addItemButton") {
        this.items.push({ title: event.data.name, subtitle: '', confirm: event.data.func, hover: event.data.hover, data: event.data.args, avatar: event.data.picture })
      } else if (event.data.action == "genMenu") {
        var obj = JSON.parse(event.data[1]);
        for (var i = 0; i < obj.length; i++) {
          if (!obj[i].isShopItem) {
            this.items.push({ title: obj[i].name, subtitle: '', confirm: obj[i].func, hover: obj[i].hover, data: obj[i].args, avatar: obj[i].avatar })
          } else {
            this.items.push({ title: obj[i].name, subtitle: obj[i].stock, confirm: obj[i].func, data: obj[i].args, avatar: obj[i].avatar, price: obj[i].price, isShopItem: obj[i].isShopItem })
          }
        };
        this.selectedItem = this.oldItemsLength != this.items.length ? 0 : this.oldSelectedItem;
      } else if (event.data.action == "init") {
        this.title = event.data.title;
        this.subtitle = event.data.subtitle;
        this.color = event.data.color;
        this.background = event.data.background;
      } else if (event.data.action == "title") {
        this.title = event.data.title;
      } else if (event.data.action == "subtitle") {
        this.subtitle = event.data.subtitle;
      } else if (event.data.action == "showVehicleInfo") {
        this.showVehicleInformation = false;
        this.vehicle = event.data.vehicle;
        this.showVehicleInformation = true
      } else if (event.data.action == "hideVehicleInfo") {
        this.showVehicleInformation = false
      } else if (event.data.action == "showShopAdmin") {
        this.showShopAdmin = true
      } else if (event.data.action == "hideShopAdmin") {
        this.showShopAdmin = false
      } else if (event.data.action == "addCommand") {
        if(this.commands.map(c => c.id).indexOf(event.data.command.id) === -1){
          this.commands.push(event.data.command);
        }
      } else if (event.data.action == "addRangeCommand") {
        event.data.commands.forEach(c => {
          if(this.commands.map(c => c.id).indexOf(c) === -1){
            this.commands.push(c);
          }
        });
      } else if (event.data.action == "removeCommand") {
        this.commands = this.commands.filter(c => c.id !== event.data.commandId);
      } else if (event.data.action == "removeRangeCommand") {
        this.commands = this.commands.filter(c => !event.data.commands.map(cmd=>cmd.id).includes(c.id));
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
        if (document.getElementById('menuList').querySelector('.selected') != null) {
          document.getElementById('menuList').scrollTop = document.getElementById('menuList').querySelector('.selected').offsetTop - 250;
        }
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
