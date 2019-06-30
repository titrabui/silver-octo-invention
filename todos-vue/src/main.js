// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import { store } from './store'
import VueAxios from 'vue-axios'
import { securedAxiosInstance, plainAxiosInstance } from './backend/axios'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import CKEditor from '@ckeditor/ckeditor5-vue'
import './styles/app.scss'

Vue.config.productionTip = false
Vue.use(VueAxios, {
  secured: securedAxiosInstance,
  plain: plainAxiosInstance
})
Vue.use(ElementUI, { size: 'small', zIndex: 3000 })
Vue.use(CKEditor)

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  securedAxiosInstance,
  plainAxiosInstance,
  components: { App },
  template: '<App/>'
})
