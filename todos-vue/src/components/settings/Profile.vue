<template lang="pug">
  el-row(:gutter="20")
    el-col(:span="12")
      el-form(ref="profileForm" :model="user" label-position="top" label-width="100px" :hide-required-asterisk="true")
        el-form-item(prop="email")
          template(slot="label")
            .setting-item-label Email
          el-input(v-model="user.email" maxlength="255" disabled show-word-limit)
        el-form-item(prop="display_name")
          template(slot="label")
            .setting-item-label Display name (optional)
            .setting-item-description Set a display name. This does not change your username.
          el-input(v-model="user.display_name" @blur="updateProfile()" placeholder="Display name (optional)" maxlength="30" show-word-limit)
        el-form-item(prop="about")
          template(slot="label")
            .setting-item-label About (optional)
            .setting-item-description A brief description of yourself shown on your profile.
          el-input(v-model="user.about" @blur="updateProfile()" placeholder="About (optional)" type="textarea" :rows="5" maxlength="200" show-word-limit)
        el-form-item(prop="birthday")
          template(slot="label")
            .setting-item-label Birthday (optional)
            .setting-item-description Set a birthday, then we can happy birthday to you.
          el-date-picker(
            v-model="user.birthday" @blur="updateProfile()"
            format="dd-MM-yyyy"
            type="date"
            placeholder="Pick a birthday")
      el-divider(content-position="left") Advanced
      .setting-item
        el-row
          .setting-item-label Content Visibility
          .setting-item-description Your profile can be discovered by everyone.
        el-switch(@change="updateProfile()" active-color="#13ce66" v-model="user.content_visibility")
    el-col(:span="8")
      .setting-item-label(style="margin-bottom: 19px") Avatar
      avatar-uploader(@on-upload="uploadAvatar" :image-url="currentUser.avatar.url || ''")
</template>

<script>

import { mapGetters, mapActions } from 'vuex'
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
      user: {}
    }
  },
  created () {
    this.user = this.currentUser
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    uploadAvatar (param) {
      const form = new FormData()
      form.append('file', param.file)

      this.$http.secured.post('/upload', form)
        .then(response => {
          this.$notify({
            title: 'Uploaded avatar',
            type: 'success',
            duration: 2000
          })
          this.updateCurrentUser(response.data)
        })
        .catch(error => this.setError(error, 'Cannot upload avatar'))
    },
    updateProfile () {
      const params = {
        display_name: this.user.display_name,
        about: this.user.about,
        birthday: this.user.birthday,
        content_visibility: this.user.content_visibility
      }

      this.$http.secured.patch(`/users/${this.user.id}`, params)
        .then(response => {
          this.$notify({
            title: 'Saved changes',
            type: 'success',
            duration: 2000
          })
          this.updateCurrentUser(response.data)
        })
        .catch(error => this.setError(error, 'Cannot save changes'))
    },
    ...mapActions({
      updateCurrentUser: 'updateCurrentUser'
    })
  }
}
</script>
