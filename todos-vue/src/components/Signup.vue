<template lang="pug">
  el-row
    el-row.banner-image
      img(style="width: 100%; height: auto;" src="@/assets/images/banner_2.jpg")
    el-row.page-title
      span Sign Up
    el-row(:gutter="20")
      el-col.signin-form(:span="6" :offset="9")
        el-alert(
          v-if="error"
          :title="error"
          type="error"
          effect="dark"
          center
          :closable=false
        )
        el-form(label-position="top" label-width="100px" size="large")
          el-form-item(label="Email address")
            el-input(placeholder="Please input email" v-model="email")
          el-form-item(label="Password")
            el-input(placeholder="Please input password" v-model="password" show-password)
          el-form-item(label="Password Confirmation")
            el-input(placeholder="Please input confirm password" v-model="password_confirmation" show-password)
          el-form-item
            el-button(type="primary" style="width: 100%" round @click="signup()") Sign Up
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
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
        this.$router.replace('/todos')
        this.$notify({
          title: 'Sign up successful',
          message: 'You signed up and loged in successful',
          type: 'success',
          duration: 2000
        })
      }).catch(error => this.signinFailed(error))
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      this.$store.commit('unsetCurrentUser')
    },
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        this.$router.replace('/todos')
      }
    }
  }
}
</script>

<style lang="css">
.form-signup {
  width: 70%;
  max-width: 500px;
  padding: 10% 15px;
  margin: 0 auto;
}
</style>
