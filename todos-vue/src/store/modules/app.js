const app = {
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
    updateCurrentUser (state, currentUser) {
      state.currentUser = currentUser
    },
    // temp function, remove next time
    setPostManageUserId (state, { userId }) {
      state.postManageUserId = userId
    }
  },
  actions: {
    updateCurrentUser ({ commit }, currentUser) {
      commit('updateCurrentUser', currentUser)
    }
  }
}

export default app
