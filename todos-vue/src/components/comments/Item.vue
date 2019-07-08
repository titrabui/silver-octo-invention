<template lang="pug">
  el-row
    el-card.box-card(shadow="hover" :body-style="{ padding: '0px' }")
      el-row.box-card-header
        span.signin-info
          img.post-user-avatar(src="@/assets/images/avatar_default.png" height="25")
          span.post-user-email {{ comment.author.email }}
          span.time-ago  {{ timesAgo(comment.created_at) }}
      el-row(style="padding: 0 20px")
        el-row(style="margin-top: 5px")
          p(v-html="comment.content")
        el-row
          el-button(type="text" icon="el-icon-star-off") Like
          el-button(type="text" icon="el-icon-chat-dot-square" @click="showCommentEditor = true") Reply
        el-row(v-if="showCommentEditor")
          editor(@on-save="saveComment" @on-cancel="hideCommentEditor" button-name="Comment")
        el-row(v-if="comment.replies")
          el-button(type="text" @click="viewMoreComment(comment.id)" v-if="!isViewMore") View more {{ comment.replies }} reply >>
          comment-list(:comments="replyComments" v-if="isViewMore")
</template>

<script>

import moment from 'moment'
import Editor from '@/commons/Editor'
import CommentList from '../comments/List'
import { mapGetters } from 'vuex'

export default {
  name: 'CommentItem',
  components: {
    Editor,
    'comment-list': CommentList
  },
  computed: {
    ...mapGetters({
      currentUser: 'currentUser'
    })
  },
  props: {
    comment: {
      type: Object,
      default: function () {
        return {
          id: null,
          author: { email: '' },
          content: '',
          replies: 0
        }
      }
    }
  },
  data () {
    return {
      showCommentEditor: false,
      replyComments: [],
      isViewMore: false
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    timesAgo (createdAt) {
      return moment(createdAt).fromNow()
    },
    editPost () {
      this.$router.replace(`/news/${this.postId}/edit`)
    },
    saveComment (content) {
      this.$http.secured.post('/comments', {
        parent_id: null,
        post_id: this.comment.post_id,
        content: content
      }).then(response => {

      }).catch(error => this.setError(error, 'Cannot create comment'))
    },
    hideCommentEditor () {
      this.showCommentEditor = false
    },
    viewMoreComment (commentId) {
      this.$http.plain.get(`/replies/${commentId}`).then(response => {
        this.replyComments = response
        this.isViewMore = true
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
