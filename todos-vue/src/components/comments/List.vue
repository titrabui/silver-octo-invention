<template lang="pug">
  el-row
    el-row(v-for="item in comments" :key="item.id" )
      comment-item(:comment="item" @on-delete-comment="deleteComment")
</template>

<script>

export default {
  name: 'CommentList',
  beforeCreate: function () {
    this.$options.components.CommentItem = require('./Item').default
  },
  props: {
    comments: Array
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
    },
    deleteComment (id) {
      this.$http.secured.delete(`/comments/${id}`).then(response => {
        const newComments = this.comments.filter(item => item.id !== id)
        this.comments = newComments
      }).catch(error => this.setError(error, 'Cannot delete comment'))
    }
  }
}
</script>
