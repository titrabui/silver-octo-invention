<template lang="pug">
  el-row
    el-row(v-for="item in comments" :key="item.id" )
      comment-item(:comment="item")
</template>

<script>

import CommentItem from '../comments/Item'
import { mapGetters } from 'vuex'

export default {
  name: 'CommentList',
  components: {
    CommentItem
  },
  props: {
    comments: Array
  },
  computed: {
    ...mapGetters({
      currentUser: 'currentUser'
    })
  },
  data () {
    return {
      error: '',
      postId: null
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    }
  }
}
</script>

<style lang="css" scoped>

</style>
