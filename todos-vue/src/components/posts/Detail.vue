<template lang="pug">
  el-row
    el-col(:span="12" :offset="6")
      el-card.box-card(:body-style="{ padding: '0px' }" v-if="Object.keys(post).length")
        el-row.box-card-header
          span.signin-info
            img.post-user-avatar(src="@/assets/images/avatar_default.png" height="25")
            span.post-user-email {{ post.user.email }}
            span.post-header-comment
              span {{ ' | '}}
              <i class="el-icon-chat-dot-square"></i> {{ comments.length }} Comments
            span.time-ago , posted {{ timesAgo(post.created_at) }}
          span(style="float: right")
            el-button(type="warning" icon="el-icon-edit-outline" round size="mini" @click="editPost()") EDIT
            el-button(type="primary" icon="el-icon-back" round size="mini" @click="backHome()") BACK
        el-row(style="padding: 14px 20px")
          span.post-title {{ post.title }}
        el-row(style="padding: 14px 20px")
          span.post-sub-title {{ post.sub_title }}
        el-row(style="padding: 14px 20px")
          p(v-html="post.description")
        el-row(style="padding: 14px 20px")
          ckeditor(:editor="editor" v-model="commentContent" :config="editorConfig")
          el-button(type="primary" round size="mini" @click="saveComment()") COMMENT
        el-row(style="padding: 14px 20px" v-if="comments.length")
          el-row(v-for="item in comments" :key="item.id" )
            comment-item(:comment="item")
</template>

<script>

import moment from 'moment'
import ClassicEditor from '@ckeditor/ckeditor5-build-classic'
import CommentItem from '../comments/Item'
import { mapGetters } from 'vuex'

export default {
  name: 'Detail',
  components: {
    CommentItem
  },
  computed: {
    ...mapGetters({
      currentUser: 'currentUser'
    })
  },
  data () {
    return {
      post: {},
      comments: [],
      error: '',
      postId: null,
      editor: ClassicEditor,
      editorConfig: {
        placeholder: 'What are your thought?'
      },
      commentContent: ''
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
    fetchComments () {
      this.$http.plain.get(`/comments_by_post`, { params: { post_id: this.postId } })
        .then(response => { this.comments = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    },
    saveComment () {
      this.$http.secured.post('/comments', {
        parent_id: null,
        post_id: this.postId,
        content: this.commentContent
      }).then(response => {
        this.commentContent = ''
      }).catch(error => this.setError(error, 'Cannot create comment'))
    }
  }
}
</script>

<style lang="css" scoped>
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
  font-size: 30px;
  font-weight: bold;
  line-height: 22px;
}
.post-sub-title {
  overflow-wrap: break-word;
  font-size: 16px;
  font-weight: 600;
  line-height: 22px;
}
.post-header-comment {
  font-size: 12px;
  font-weight: 700;
  line-height: 16px;
  color: rgb(135, 138, 140);
}
.ck-content {
  min-height: 200px !important;
}
</style>
