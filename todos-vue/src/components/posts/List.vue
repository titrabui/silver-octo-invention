<template lang="pug">
  el-row
    el-col(:span="10" :offset="7")
      el-card.box-card(v-for="post in posts" :key="post.id" shadow="hover" :body-style="{ padding: '0px' }")
        el-row.box-card-header(:gutter="5")
          el-col.post-info-container(:span="20")
            el-avatar(v-if="post.user.url" :src="post.user.url" shape="square" :size="25")
            el-avatar(v-else shape="square" :size="25") {{ post.user.email.charAt(0).toUpperCase() }}
            span.post-user-email {{ post.user.email }}
            el-divider(direction="vertical")
            span.post-comment
              i.el-icon-chat-dot-square
              span  {{ post.comments }} comments
            span.post-time-ago , posted {{ timesAgo(post.created_at) }}
          el-col(:span="4" align="right")
            el-button(type="primary" icon="el-icon-circle-plus" round size="mini" @click="showPost(post.id)") JOIN
        el-row.post-description
          span.post-title {{ post.title }}
          p.post-sub-title {{ post.sub_title }}
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
