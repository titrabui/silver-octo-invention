<template lang="pug">
  el-row
    el-card.box-card
      el-row.box-card-header
        span.box-header-title
          i(class="el-icon-s-tools")
          span  Settings
      el-row
        el-tabs(v-model="activeTab" @tab-click="handleClick")
          el-tab-pane(label="Account" name="account")
            Account
          el-tab-pane(label="Profile" name="profile")
            Profile
</template>

<script>

import Account from './Account'
import Profile from './Profile'

export default {
  name: 'Create',
  components: {
    Account,
    Profile
  },
  data () {
    return {
      activeTab: 'account'
    }
  },
  methods: {
    handleClick (tab, event) {
      console.log(tab, event)
    }
  }
}
</script>
