<template>
  <nav class="navbar rounded">
    <ul class="navbar">
      <li class="nav-item home">
        <router-link class="nav-link" to="/todos">Home</router-link>
      </li>
    </ul>
    <ul class="navbar ml-auto">
      <li class="nav-item">
        <a class="nav-link" v-if="showAdminLink()">Admin</a>
      </li>
      <li class="nav-item sign-out">
        <a class="nav-link" @click="signOut">Sign out</a>
      </li>
    </ul>
  </nav>
</template>

<script>
export default {
  name: 'AppHeader',
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signOut () {
      this.$http.secured.delete('/signin')
        .then(response => {
          this.$store.commit('unsetCurrentUser')
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    },
    showAdminLink () {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    }
  }
}
</script>
