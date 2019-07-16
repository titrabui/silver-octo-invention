import { securedAxiosInstance } from '@/backend/axios'
import { errorNotifier } from '@/utils/error'

const users = {
  namespaced: true,
  state: {
    users: []
  },
  getters: {
    users (state) {
      return state.users
    }
  },
  mutations: {
    setUsers (state, users) {
      state.users = users
    }
  },
  actions: {
    fetchUsers ({ commit }) {
      securedAxiosInstance.get('/admin/users')
        .then(response => { commit('setUsers', response.data) })
        .catch(error => errorNotifier(error, 'Something went wrong'))
    }
  }
}

export default users
