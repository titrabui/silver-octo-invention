<template>
  <nav class="navbar rounded" style="padding: 0.2rem 1rem">
    <ul class="navbar">
      <li class="nav-item home">
        <router-link class="nav-link" to="/todos">
          <img src="@/assets/images/logo.png" height="40"/>
        </router-link>
      </li>
    </ul>
    <ul class="navbar">
      <li class="nav-item">
        <el-input
          placeholder="Search news"
          prefix-icon="el-icon-search"
          v-model="newsSearch"
          style="width: 400px">
        </el-input>
      </li>
    </ul>
    <ul class="navbar ml-auto">
      <li class="nav-item">
        <el-button v-if="!isSignedIn" @click="redirectToPage('signin')" icon="el-icon-thumb" round>LOG IN</el-button>
        <el-button v-if="!isSignedIn" @click="redirectToPage('signup')" type="primary" icon="el-icon-position" round>SIGN UP</el-button>
        <el-tooltip v-if="isSignedIn" content="Create Post" placement="bottom">
          <el-button type="warning" icon="el-icon-edit" @click="redirectToPage('news-create')" round>Create post</el-button>
        </el-tooltip>
        <el-dropdown @command="handleCommand" style="margin-left: 10px; vertical-align: middle;">
          <el-button v-bind:class="{ 'dropdown-signedin': isSignedIn }" round>
            <span class="dropdown-info">
              <i v-if="!isSignedIn" class="el-icon-user-solid"></i>
              <span class="signin-info" v-if="isSignedIn">
                <img src="@/assets/images/avatar_default.png" height="25" style="margin-right: 5px"/>
                <span class="user-info">
                  <span class="user-account">{{ currentUser.email }}</span>
                  <span class="user-role">{{ currentUser.role }}</span>
                </span>
              </span>
              <i class="el-icon-caret-bottom el-icon--right"></i>
            </span>
          </el-button>
          <el-dropdown-menu slot="dropdown" v-if="!isSignedIn">
            <el-dropdown-item command="signin" icon="el-icon-thumb">Log In / Sign Up</el-dropdown-item>
          </el-dropdown-menu>
          <el-dropdown-menu slot="dropdown" v-if="isSignedIn">
            <el-dropdown-item command="posts" icon="el-icon-platform-eleme">News Management</el-dropdown-item>
            <el-dropdown-item command="users" icon="el-icon-user-solid">Users Management</el-dropdown-item>
            <el-dropdown-item command="setting" icon="el-icon-s-tools">Profile Settings</el-dropdown-item>
            <el-dropdown-item command="signout" icon="el-icon-back">Log Out</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </li>
    </ul>
  </nav>
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
      } else if (command === 'signin') {
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
    font-size: 12px;
    font-weight: 500;
    line-height: 16px;
    color: #a8aaab;
    text-transform: capitalize;
  }

  .dropdown-signedin {
    padding: 3px 10px;
  }
</style>
