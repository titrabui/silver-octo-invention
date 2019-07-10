<template lang="pug">
  el-row
    el-col(:span="12" :offset="6")
      el-card.box-card(:body-style="{ padding: '0px' }")
        el-row.box-card-header
          span.box-header-title
            i(class="el-icon-s-tools")
            span  Profile Settings
        el-row(style="padding: 14px 20px")
          el-col(:span="8" align="center")
            avatar-uploader(@on-upload="uploadAvatar")
          el-col(:span="16")
            el-form(ref="profileForm" :model="currentUser" label-position="top" label-width="100px" :hide-required-asterisk="true")
              el-form-item(label="Email" prop="email")
                el-input(v-model="currentUser.email" maxlength="255" disabled show-word-limit)
              el-form-item(label="Full Name" prop="full_name")
                el-input(placeholder="Please input full name" maxlength="255" show-word-limit)
              el-form-item
                el-row(style="float: right")
                  el-button(type="primary" icon="el-icon-check" round @click="savePost()") Update
</template>

<script>

import { mapGetters } from 'vuex'
import AvatarUploader from '@/commons/AvatarUploader'

export default {
  name: 'Create',
  components: {
    AvatarUploader
  },
  computed: {
    ...mapGetters({
      currentUser: 'currentUser'
    })
  },
  data () {
    return {
      error: ''
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    uploadAvatar (param) {
      const form = new FormData()
      form.append('file', param.file)

      this.$http.secured.post('/upload', form)
        .catch(error => this.setError(error, 'Cannot upload avatar'))
    }
  }
}
</script>
