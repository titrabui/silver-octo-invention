<template lang="pug">
  nav.navbar.rounded(style="padding: 0.2rem 1rem")
    ul.navbar
      li.nav-item.home
        router-link.nav-link(to="/")
          img(src="@/assets/images/logo.png" height="40")
    ul.navbar
      li.nav-item
        el-input(
          placeholder="Search news"
          prefix-icon="el-icon-search"
          v-model="newsSearch"
          style="width: 400px")
    ul.navbar.ml-auto
      li.nav-item
        div(v-if="isSignedIn")
          el-tooltip(content="Create news" placement="bottom")
            el-button(type="success" icon="el-icon-edit" @click="redirectToPage('news-create')" round) Create news
          el-dropdown(@command="handleCommand" style="margin-left: 10px; vertical-align: middle;")
            el-button.dropdown-signedin(round)
              span.dropdown-info
                span.signin-info
                  el-avatar(v-if="currentUser.avatar.url" :src="currentUser.avatar.url" shape="square" :size="30")
                  el-avatar(v-else shape="square" :size="30") {{ (currentUser.display_name && currentUser.display_name.charAt(0).toUpperCase()) || (currentUser.email && currentUser.email.charAt(0).toUpperCase()) }}
                  span.user-info
                    span.user-account {{ currentUser.email }}
                    span.user-role {{ currentUser.role }}
                <i class="el-icon-caret-bottom el-icon--right"></i>
            el-dropdown-menu(slot="dropdown")
              el-dropdown-item(command="news-manage" icon="el-icon-platform-eleme") News Management
              el-dropdown-item(v-if="isAdmin || isManager" command="admin/users" icon="el-icon-user-solid") Users Management
              el-dropdown-item(command="settings" icon="el-icon-s-tools") Settings
              el-dropdown-item(command="signout" icon="el-icon-back") Log Out
        div(v-else)
          el-button(@click="redirectToPage('signin')" icon="el-icon-thumb" round) LOG IN
          el-button(@click="redirectToPage('signup')" icon="el-icon-position" round type="primary") SIGN UP
          el-dropdown(@command="handleCommand" style="margin-left: 10px; vertical-align: middle;")
            el-button(round)
              span.dropdown-info
                <i class="el-icon-user-solid"></i>
                <i class="el-icon-caret-bottom el-icon--right"></i>
            el-dropdown-menu(slot="dropdown")
              el-dropdown-item(command="signin" icon="el-icon-thumb") Log In / Sign Up
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'AppHeader',
  computed: {
    ...mapGetters({
      isSignedIn: 'isSignedIn',
      isAdmin: 'isAdmin',
      isManager: 'isManager',
      currentUser: 'currentUser'
    })
  },
  data () {
    return {
      newsSearch: ''
    }
  },
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
    },
    redirectToPage (route) {
      this.$router.replace(`/${route}`)
    },
    handleCommand (command) {
      if (command === 'signout') {
        this.signOut()
      } else {
        this.redirectToPage(command)
      }
    }
  }
}
</script>

<style lang="css" scoped>
  ul {
    list-style-type: none;
  }

  .nav-bar {
    padding: .5rem 0;
  }

  .nav-link {
    padding: 0 1rem;
  }

  .home {
    width: 200px;
  }

  .dropdown-info {
    display: flex;
    align-items: center;
  }

  .signin-info {
    display: flex;
    text-align: left;
    align-items: center;
  }

  .user-info {
    display: block;
    margin-left: 5px
  }

  .user-account {
    font-size: 12px;
    font-weight: 500;
    line-height: 16px;
    color: var(--newCommunityTheme-bodyText);
    display: block;
    white-space: nowrap;
  }

  .user-role {
    font-size: 11px;
    font-weight: 500;
    line-height: 16px;
    color: #a8aaab;
    text-transform: capitalize;
  }

  .dropdown-signedin {
    padding: 3px 10px;
  }
</style>
