import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import app from './modules/app'
import users from './modules/users'
Vue.use(Vuex)

export const store = new Vuex.Store({
  modules: {
    app,
    users
  },
  plugins: [createPersistedState()]
})
