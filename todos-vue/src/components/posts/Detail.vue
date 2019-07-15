<template lang="pug">
  el-row
    el-col(:span="12" :offset="6")
      el-card.box-card(:body-style="{ padding: '0px' }" v-if="Object.keys(post).length")
        el-row.box-card-header(:gutter="5")
          el-col.post-info-container(:span="16")
            el-avatar(v-if="post.author.avatar" :src="post.author.avatar" shape="square" :size="30")
            el-avatar(v-else shape="square" :size="30") {{ (post.author.display_name && post.author.display_name.charAt(0).toUpperCase()) || (post.author.email && post.author.email.charAt(0).toUpperCase()) }}
            span.post-user-email {{ post.author.display_name || post.author.email }}
            el-divider(direction="vertical")
            span.post-time-ago posted {{ timesAgo(post.created_at) }}
          el-col(:span="8" align="right")
            el-button(v-if="canEditPost()" type="warning" icon="el-icon-edit-outline" round size="mini" @click="editPost()") EDIT
            el-button(type="primary" icon="el-icon-back" round size="mini" @click="backHome()") BACK
        el-row.box-card-body
          el-row
            p.post-title {{ post.title }}
            p.post-sub-title {{ post.sub_title }}
            p(v-html="post.description")
          el-row
            span.post-comment
              <i class="el-icon-chat-dot-square"></i> {{ post.comments }} Comments
            el-button(type="text" icon="el-icon-star-off" style="margin-left: 10px") Share
            el-button(type="text" icon="el-icon-star-off") Report
          el-row
            el-divider
            editor(v-if="isSignedIn" @on-save="saveComment" :has-cancel-btn="false" button-name="Comment")
            el-row(v-else :gutter="5")
              el-col(:span="12")
                span What are your thoughts? Log in or Sign up
              el-col(:span="12" align="right")
                el-button(@click="$router.replace('/signin')" icon="el-icon-thumb" round) LOG IN
                el-button(@click="redirectToPage('/signup')" type="primary" icon="el-icon-position" round) SIGN UP
          el-row(v-if="comments.length")
            el-divider
            comment-list(:comments="comments")
</template>

<script>

import moment from 'moment'
import Editor from '@/commons/Editor'
import CommentList from '../comments/List'
import { mapGetters } from 'vuex'

export default {
  name: 'Detail',
  components: {
    Editor,
    CommentList
  },
  computed: {
    ...mapGetters({
      isSignedIn: 'isSignedIn',
      currentUser: 'currentUser'
    })
  },
  data () {
    return {
      post: {},
      comments: [],
      error: '',
      postId: null
    }
  },
  created () {
    this.fetchPosts()
    this.fetchComments()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    timesAgo (createdAt) {
      return moment(createdAt).fromNow()
    },
    backHome () {
      this.$router.replace('/')
    },
    fetchPosts () {
      this.postId = this.$route.params.id
      this.$http.plain.get(`/posts/${this.postId}`)
        .then(response => { this.post = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    },
    editPost () {
      this.$router.replace(`/news/${this.postId}/edit`)
    },
    canEditPost () {
      return this.currentUser && this.currentUser.id === this.post.author.id
    },
    fetchComments () {
      this.$http.plain.get(`/comments_by_post`, { params: { post_id: this.postId } })
        .then(response => { this.comments = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    },
    saveComment (content) {
      this.$http.secured.post('/comments', {
        parent_id: null,
        post_id: this.postId,
        content: content
      }).then(response => {
        this.fetchComments()
      }).catch(error => this.setError(error, 'Cannot create comment'))
    }
  }
}
</script>
