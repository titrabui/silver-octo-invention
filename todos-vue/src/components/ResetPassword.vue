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
        <el-form :model="resetForm" ref="resetForm" :rules="resetValidates" label-position="top" label-width="100px" size="large" :hide-required-asterisk="true">
          <el-form-item prop="password" label="New Password">
            <el-input v-model="resetForm.password" show-password></el-input>
          </el-form-item>
          <el-form-item prop="password_confirmation" label="Password Confirmation">
            <el-input v-model="resetForm.password_confirmation" show-password></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="success" style="width: 100%" round @click="reset()">Change password</el-button>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
  </el-row>
</template>

<script>
export default {
  name: 'ResetPassword',
  data () {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Password confirmation should not be empty'))
      } else if (this.resetForm.password && value !== this.resetForm.password) {
        callback(new Error('Password confirmation have to be same as new password'))
      } else {
        callback()
      }
    }

    return {
      resetForm: {
        password: '',
        password_confirmation: ''
      },
      error: '',
      resetValidates: {
        password: [
          { required: true, message: 'New password should not be empty', trigger: 'blur' }
        ],
        password_confirmation: [
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      }
    }
  },
  created () {
    this.checkPasswordToken()
  },
  methods: {
    reset () {
      this.$refs['resetForm'].validate((valid) => {
        if (valid) {
          this.$http.plain.patch(`/password_resets/${this.$route.params.token}`, this.resetForm)
            .then(response => this.resetSuccessful(response))
            .catch(error => this.resetFailed(error))
        } else {
          return false
        }
      })
    },
    resetSuccessful (response) {
      this.error = ''
      this.resetForm = {
        password: '',
        password_confirmation: ''
      }
      this.$notify({
        title: 'Change password successful',
        message: 'Your password has been reset successfully! Please sign in with your new password.',
        type: 'success',
        duration: 5000
      })
      this.$router.replace('/signin')
    },
    resetFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
    },
    checkPasswordToken () {
      this.$http.plain.get(`/password_resets/${this.$route.params.token}`)
        .catch(error => {
          this.resetFailed(error)
          this.$router.replace('/')
        })
    }
  }
}
</script>
