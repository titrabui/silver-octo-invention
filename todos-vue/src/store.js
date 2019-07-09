import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'
Vue.use(Vuex)

export const store = new Vuex.Store({
  state: {
    currentUser: {},
    signedIn: false,
    csrf: null,
    // temp
    postManageUserId: null
  },
  getters: {
    isAdmin (state) {
      return state.currentUser && state.currentUser.role === 'admin'
    },
    isManager (state) {
      return state.currentUser && state.currentUser.role === 'manager'
    },
    currentUserId (state) {
      return state.currentUser && state.currentUser.id
    },
    currentUser (state) {
      return state.currentUser
    },
    isSignedIn (state) {
      return state.signedIn
    },
    // temp
    postManageUserId (state) {
      return state.postManageUserId
    }
  },
  mutations: {
    setCurrentUser (state, { currentUser, csrf }) {
      state.currentUser = currentUser
      state.signedIn = true
      state.csrf = csrf
    },
    unsetCurrentUser (state) {
      state.currentUser = {}
      state.signedIn = false
      state.csrf = null
    },
    // temp function, remove next time
    setPostManageUserId (state, { userId }) {
      state.postManageUserId = userId
    }
  },
  plugins: [createPersistedState()]
})
