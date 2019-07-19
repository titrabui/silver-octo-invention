import { securedAxiosInstance } from '@/backend/axios'
import { successNotifier, errorNotifier } from '@/utils/notifier'

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
    },
    deleteUser (state, userId) {
      state.users = state.users.filter(item => {
        return item.id !== userId
      })
    }
  },
  actions: {
    fetchUsers ({ commit }) {
      securedAxiosInstance.get('/admin/users')
        .then(response => { commit('setUsers', response.data) })
        .catch(error => errorNotifier(error, 'Something went wrong'))
    },
    deleteUser ({ commit }, userId) {
      securedAxiosInstance.delete(`admin/users/${userId}`)
        .then(_ => {
          commit('deleteUser', userId)
          successNotifier('', 'Delete completed')
        })
        .catch(error => errorNotifier(error, 'Cannot update user'))
    }
  }
}

export default users
