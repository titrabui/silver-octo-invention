<template>
  <el-row>
    <el-row class="banner-image">
      <img style="width: 100%; height: auto;" src="@/assets/images/banner_1.jpg">
    </el-row>
    <el-row class="page-title">
      <span>Reset Password</span>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="6" :offset="9" class="signin-form">
        <el-alert
          v-if="error"
          :title="error"
          type="error"
          effect="dark"
          center
          :closable=false>
        </el-alert>
        <el-form :model="forgotForm" ref="forgotForm" :rules="forgotValidates" label-position="top" label-width="100px" size="large" :hide-required-asterisk="true">
          <el-form-item prop="email" label="Email address">
            <el-input placeholder="Please input email" v-model="forgotForm.email"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" style="width: 100%" round @click="reset()">Reset password</el-button>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
  </el-row>
</template>

<script>
export default {
  name: 'ForgotPassword',
  data () {
    return {
      forgotForm: {
        email: ''
      },
      error: '',
      forgotValidates: {
        email: [
          { required: true, message: 'Please input email address', trigger: 'blur' },
          { type: 'email', message: 'Please input correct email address', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    reset () {
      this.$refs['forgotForm'].validate((valid) => {
        if (valid) {
          this.$http.plain.post('/password_resets', { email: this.forgotForm.email })
            .then(() => this.submitSuccessful())
            .catch(error => this.submitFailed(error))
        } else {
          return false
        }
      })
    },
    submitSuccessful () {
      this.error = ''
      this.email = ''
      this.$notify({
        title: 'Reset password successful',
        message: 'Email with password reset instructions had been sent.',
        type: 'success',
        duration: 5000
      })
      this.$router.replace('/signin')
    },
    submitFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
    }
  }
}
</script>
