<template lang="pug">
  el-row
    el-row(v-for="item in childComments" :key="item.id" )
      comment-item(:comment="item" @on-delete-comment="deleteComment")
</template>

<script>

export default {
  name: 'CommentList',
  beforeCreate: function () {
    this.$options.components.CommentItem = require('./Item').default
  },
  computed: {
    childComments () {
      return this.refreshComment()
    }
  },
  props: {
    comments: Array
  },
  data () {
    return {
      error: '',
      deletedItem: null
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    deleteComment (id) {
      this.$http.secured.delete(`/comments/${id}`).then(response => {
        this.deletedItem = id
      }).catch(error => this.setError(error, 'Cannot delete comment'))
    },
    refreshComment () {
      return this.comments.filter(item => item.id !== this.deletedItem)
    }
  }
}
</script>
