<template lang="pug">
  el-dialog(:visible.sync="dialogVisible" width="60%")
    el-row.signin-container(:gutter="40")
      el-col.signin-form(:span="12")
        .signin-dialog-title Sign Up
        el-alert(
          v-if="error"
          :title="error"
          type="error"
          effect="dark"
          center
          :closable=false
        )
        el-form(label-position="top" label-width="100px")
          el-form-item
            template(slot="label")
              .signin-item-label Email address
            el-input(placeholder="Please input email" v-model="email")
          el-form-item
            template(slot="label")
              .signin-item-label Password
            el-input(placeholder="Please input password" v-model="password" show-password)
          el-form-item
            template(slot="label")
              .signin-item-label Confirm Password
            el-input(placeholder="Please input confirm password" v-model="password_confirmation" show-password)
          el-form-item
            el-button(type="primary" style="width: 100%" round @click="signup()" size="large") Sign Up
      el-col(:span="12" align="middle")
        el-form(size="large")
          el-form-item
            el-button.btn-signin.btn-google(round @click="signupWithGoogle()")
              font-awesome-icon(:icon="['fab', 'google']")
              el-divider(direction="vertical")
              span Sign up with Google
          el-form-item
            el-button.btn-signin.btn-facebook(round @click="signupWithFacebook()")
              font-awesome-icon(:icon="['fab', 'facebook-f']")
              el-divider(direction="vertical")
              span Sign up with Facebook
          el-form-item
            el-button.btn-signin.btn-twitter(round @click="signupWithTwitter()")
              font-awesome-icon(:icon="['fab', 'twitter']")
              el-divider(direction="vertical")
              span Sign up with Twitter

</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: '',
      dialogVisible: false
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signup () {
      this.$http.plain.post('/signup', { email: this.email, password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }

      this.$http.plain.get('/me').then(meResponse => {
        this.$store.commit('setCurrentUser', { currentUser: meResponse.data, csrf: response.data.csrf })
        this.error = ''
        this.$router.replace('/')
        this.$notify({
          title: 'Sign up successful',
          message: 'You signed up and loged in successful',
          type: 'success',
          duration: 2000
        })
      }).catch(error => this.signupFailed(error))
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      this.$store.commit('unsetCurrentUser')
    },
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        this.$router.replace('/')
      }
    },
    authorizationCode (authCode, provider) {
      this.$http.plain.post('/oauth/google', { auth_code: authCode, provider: provider })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupWithGoogle () {
      this.$gAuth.getAuthCode()
        .then(authCode => {
          this.authorizationCode(authCode, 'google')
        })
        .catch(error => this.signupFailed(error))
    },
    signupWithFacebook () {

    },
    signupWithTwitter () {

    }
  }
}
</script>
