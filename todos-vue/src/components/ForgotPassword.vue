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
          v-if="notice"
          :title="notice"
          type="success"
          effect="dark"
          center
          :closable=false>
        </el-alert>
        <el-alert
          v-if="error"
          :title="error"
          type="error"
          effect="dark"
          center
          :closable=false>
        </el-alert>
        <el-form :model="resetForm" ref="resetForm" :rules="resetValidates" label-position="top" label-width="100px" size="large" :hide-required-asterisk="true">
          <el-form-item prop="email" label="Email address">
            <el-input placeholder="Please input email" v-model="resetForm.email"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" style="width: 100%" round @click="reset()">Reset Password</el-button>
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
      resetForm: {
        email: ''
      },
      error: '',
      notice: '',
      resetValidates: {
        email: [
          { required: true, message: 'Please input email address', trigger: 'blur' },
          { type: 'email', message: 'Please input correct email address', trigger: ['blur', 'change'] }
        ]
      }
    }
  },
  methods: {
    reset () {
      this.$refs['resetForm'].validate((valid) => {
        if (valid) {
          this.$http.plain.post('/password_resets', { email: this.resetForm.email })
            .then(() => this.submitSuccessful())
            .catch(error => this.submitFailed(error))
        } else {
          return false
        }
      })
    },
    submitSuccessful () {
      this.notice = 'Email with password reset instructions had been sent.'
      this.error = ''
      this.email = ''
    },
    submitFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
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
