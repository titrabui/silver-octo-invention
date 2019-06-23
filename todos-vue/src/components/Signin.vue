<template>
  <el-row>
    <el-row class="banner-image">
      <img style="width: 100%; height: auto;" src="@/assets/images/banner_1.jpg">
    </el-row>
    <el-row class="page-title">
      <span>Sign In</span>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="6" :offset="9" class="signin-form">
        <el-form label-position="top" label-width="100px">
          <el-form-item label="Email address">
            <el-input size="large" v-model="email"></el-input>
          </el-form-item>
          <el-form-item label="Password">
            <el-input size="large" v-model="password"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="large" style="width: 100%" round @click="signin()">Sign In</el-button>
          </el-form-item>
          <el-form-item>
            <el-row :gutter="10">
              <el-col :span="12">
                <router-link to="/forgot_password">Forgot Password?</router-link>
              </el-col>
              <el-col :span="12" style="text-align: right">
                <router-link to="/signup">SIGN UP</router-link>
              </el-col>
            </el-row>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
  </el-row>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
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
    signin () {
      this.$http.plain.post('/signin', { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }

      this.$http.plain.get('/me').then(meResponse => {
        this.$store.commit('setCurrentUser', { currentUser: meResponse.data, csrf: response.data.csrf })
        this.error = ''
        this.$router.replace('/todos')
      }).catch(error => this.signinFailed(error))
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
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
.signin-form {
  padding: 20px 20px 0 !important;
  border: dashed 1px #409EFF;
  border-radius: 5px;
  margin-top: 20px;
  background-color: #F2F6FC;
}

.banner-image {
  margin: -19px -20px 30px;
}

.page-title {
  text-align: center;
  font-weight: 500;
  font-size: 25px;
  color: #409EFF;
}
</style>
