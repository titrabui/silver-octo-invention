<template lang="pug">
  el-row
    el-col(:span="10" :offset="7")
      el-card.box-card(v-for="post in posts" :key="post.id" :body-style="{ padding: '0px' }" shadow="hover")
        el-row.box-card-header
          span.signin-info
            img.post-user-avatar(src="@/assets/images/avatar_default.png" height="25")
            span.post-user-email {{ post.user.email }}
            span.post-header-comment
              span {{ ' | '}}
              <i class="el-icon-chat-dot-square"></i> {{ post.comments }} Comments
            span.time-ago , posted {{ timesAgo(post.created_at) }}
          el-button(style="float: right" type="primary" icon="el-icon-circle-plus" round size="mini" @click="showPost(post.id)") JOIN
        el-row(style="padding: 14px")
          span.post-title {{ post.title }}
          br
          span.post-sub-title {{ post.sub_title }}
        el-row
          img.post-image(:src="post.image_url")
</template>

<script>

import moment from 'moment'

export default {
  name: 'List',
  data () {
    return {
      posts: [],
      error: ''
    }
  },
  created () {
    this.$http.plain.get('/posts')
      .then(response => { this.posts = response.data })
      .catch(error => this.setError(error, 'Something went wrong'))
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    timesAgo (createdAt) {
      return moment(createdAt).fromNow()
    },
    showPost (postId) {
      this.$router.replace(`/news/${postId}`)
    }
  }
}
</script>
