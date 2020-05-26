import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import VueTimeago from './TimeAgo'
import PhoneAPI from './PhoneAPI'
import ApiService from './apiService'
import Notification from './Notification'
import Vuesax from 'vuesax'

import AutoFocus from './directives/autofocus'
import 'vuesax/dist/vuesax.css' //Vuesax styles

Vue.use(VueTimeago)
Vue.use(Notification)
Vue.use(Vuesax)
Vue.config.productionTip = false

Vue.prototype.$bus = new Vue()
Vue.prototype.$phoneAPI = PhoneAPI
Vue.prototype.$apiService = ApiService

window.VueTimeago = VueTimeago
window.Vue = Vue
window.store = store

Vue.directive('autofocus', AutoFocus)

/* eslint-disable no-new */
window.APP = new Vue({
  el: '#app',
  store,
  router,
  render: h => h(App)
})
