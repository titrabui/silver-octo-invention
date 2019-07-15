<template lang="pug">
  el-row
    el-card.box-card(shadow="hover" :body-style="{ padding: '0px' }")
      el-row.comment-header-container
        el-avatar(v-if="comment.author.avatar" :src="comment.author.avatar" shape="square" :size="30")
        el-avatar(v-else shape="square" :size="30") {{ (comment.author.display_name && comment.author.display_name.charAt(0).toUpperCase()) || (comment.author.email && comment.author.email.charAt(0).toUpperCase()) }}
        span.comment-author-name {{ comment.author.display_name || comment.author.email }}
        el-divider(direction="vertical")
        span.comment-time-ago  {{ timesAgo(comment.created_at) }}
      el-row(style="padding-left: 20px")
        el-row(style="margin-top: 5px")
          p.comment-content(v-if="!isEditComment" v-html="comment.content")
          editor(v-if="isEditComment" @on-save="editReply" @on-cancel="hideEditEditor" :has-cancel-btn="true" :content="comment.content" button-name="Edit" style="margin-right: 5px")
        el-row
          el-badge(:value="comment.likes" type="primary" :hidden="comment.likes === 0")
            el-button(type="text" icon="el-icon-star-off" :disabled="!isSignedIn" style="color: #909399") Like
          el-badge(:value="comment.replies" :hidden="comment.replies === 0" style="margin-left: 20px")
            el-button(type="text" icon="el-icon-chat-dot-square" @click="showCommentEditor = true" :disabled="!isSignedIn" style="color: #909399") Reply
          span(v-if="canEditOrDelete()" style="margin-left: 20px")
            el-button(type="text" @click="isEditComment = true" style="color: #E6A23C") Edit
            span /
            el-button(type="text" @click="onDeleteComment()" style="color: #F56C6C") Delete
        el-row(v-if="showCommentEditor" style="margin-right: 5px")
          editor(@on-save="saveReply" @on-cancel="hideCommentEditor" :has-cancel-btn="true" button-name="Comment")
        el-row(v-if="comment.replies")
          el-button(type="text" @click="viewMoreComment(comment.id)" v-if="!isViewMore") View more {{ comment.replies }} replies >>
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
    CommentList
  },
  computed: {
    ...mapGetters({
      isSignedIn: 'isSignedIn',
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
          replies: 0,
          likes: 0
        }
      }
    }
  },
  data () {
    return {
      showCommentEditor: false,
      replyComments: [],
      isViewMore: false,
      isEditComment: false
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    timesAgo (createdAt) {
      return moment(createdAt).fromNow()
    },
    saveReply (content) {
      this.$http.secured.post('/comments', {
        parent_id: this.comment.id,
        post_id: this.comment.post_id,
        content: content,
        replies: this.comment.replies + 1
      }).then(response => {
        this.viewMoreComment(this.comment.id)
        this.hideCommentEditor()
        this.comment.replies = this.comment.replies + 1
      }).catch(error => this.setError(error, 'Cannot create comment'))
    },
    hideCommentEditor () {
      this.showCommentEditor = false
    },
    editReply (content) {
      this.$http.secured.patch(`/comments/${this.comment.id}`, { content: content })
        .then(response => {
          this.hideEditEditor()
          this.comment.content = content
        }).catch(error => this.setError(error, 'Cannot create comment'))
    },
    hideEditEditor () {
      this.isEditComment = false
    },
    viewMoreComment (commentId) {
      this.$http.plain.get(`/replies/${commentId}`).then(response => {
        this.replyComments = response.data
        this.isViewMore = true
      }).catch(error => this.setError(error, 'Cannot create comment'))
    },
    canEditOrDelete () {
      return this.currentUser && this.currentUser.id === this.comment.author.id
    },
    onDeleteComment () {
      this.$emit('on-delete-comment', this.comment.id)
    }
  }
}
</script>
