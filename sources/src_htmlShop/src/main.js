import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import ApiService from './apiService'
import Vuesax from 'vuesax'

import 'vuesax/dist/vuesax.css' //Vuesax styles

Vue.use(Vuesax)
Vue.config.productionTip = false

Vue.prototype.$bus = new Vue()
Vue.prototype.$apiService = ApiService

window.Vue = Vue
window.store = store

/* eslint-disable no-new */
window.APP = new Vue({
  el: '#app',
  store,
  router,
  render: h => h(App)
})
