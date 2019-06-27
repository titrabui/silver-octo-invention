<template lang="pug">
  el-row
    el-col(:span="10" :offset="7")
      el-card.box-card(v-for="post in posts" :key="post.id" :body-style="{ padding: '0px' }" shadow="hover")
        el-row.box-card-header
          span.signin-info
            img.post-user-avatar(src="@/assets/images/avatar_default.png" height="25")
            span.post-user-email {{ post.user.email }}
            span.post-comment
              span {{ ' | '}}
              <i class="el-icon-chat-dot-square"></i> {{ post.comments.length }} Comments
            span.time-ago , posted {{ timesAgo(post.created_at) }}
          el-button(style="float: right" type="primary" icon="el-icon-circle-plus" round size="mini" @click="showPost(post.id)") JOIN
        el-row(style="padding: 14px")
          span.post-title {{ post.title }}
          br
          span.post-sub-title {{ post.sub_title }}
        el-row
          img.image(:src="post.image_url")
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

<style lang="css" scoped>
.box-card {
  margin-bottom: 15px;
}
.box-card-header {
  padding: 14px;
  background-color: #faebd775;
}
.post-user-avatar {
  margin-right: 5px;
  border-radius: 50%;
}
.post-user-email {
  font-size: 12px;
  font-weight: 700;
  color: rgb(28, 28, 28);
  line-height: 20px;
}
.time-ago {
  color: rgb(120, 124, 126);
  font-size: 12px;
  font-weight: 100;
}
.image {
  width: 100%;
  display: block;
}
.post-title {
  overflow-wrap: break-word;
  font-size: 18px;
  font-weight: bold;
  line-height: 22px;
}
.post-sub-title {
  overflow-wrap: break-word;
  font-size: 16px;
  font-weight: 500;
  line-height: 22px;
}
.post-comment {
  font-size: 12px;
  font-weight: 700;
  line-height: 16px;
  color: rgb(135, 138, 140);
}
</style>
