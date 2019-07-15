<template lang="pug">
  el-row
    el-col(:span="12")
      el-row
        .setting-item
          el-row
            .setting-item-label Change password
            .setting-item-description Password must be at least 6 characters long
          el-button(type="success" round) Change
        el-divider
        .setting-item
          span.setting-item-label DEACTIVATE ACCOUNT
          el-button(round icon="el-icon-delete" style="color: #F56C6C") DEACTIVATE ACCOUNT
</template>

<script>
export default {
  name: 'Account'
}
</script>
