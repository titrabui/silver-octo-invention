<template lang="pug">
  el-row(:gutter="20")
    el-col(:span="12")
      el-form(ref="profileForm" :model="currentUser" label-position="top" label-width="100px" :hide-required-asterisk="true")
        el-form-item(prop="email")
          template(slot="label")
            .setting-item-label Email
          el-input(v-model="currentUser.email" maxlength="255" disabled show-word-limit)
        el-form-item(prop="display_name")
          template(slot="label")
            .setting-item-label Display name (optional)
            .setting-item-description Set a display name. This does not change your username.
          el-input(placeholder="Display name (optional)" maxlength="30" show-word-limit)
        el-form-item(prop="about")
          template(slot="label")
            .setting-item-label About (optional)
            .setting-item-description A brief description of yourself shown on your profile.
          el-input(placeholder="About (optional)" type="textarea" :rows="5" maxlength="200" show-word-limit)
        el-form-item(prop="birthday")
          template(slot="label")
            .setting-item-label Birthday (optional)
            .setting-item-description Set a birthday, then we can happy birthday to you.
          el-date-picker(
            type="date"
            placeholder="Pick a birthday")
      el-divider(content-position="left") Advanced
      .setting-item
        el-row
          .setting-item-label Content Visibility
          .setting-item-description Your profile can be discovered by everyone.
        el-switch(active-color="#13ce66" v-model="content_Visibility")
    el-col(:span="8")
      avatar-uploader(@on-upload="uploadAvatar")
</template>

<script>

import { mapGetters } from 'vuex'
import AvatarUploader from '@/commons/AvatarUploader'

export default {
  name: 'Profile',
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
      error: '',
      user: {},
      content_Visibility: false
    }
  },
  created () {

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
