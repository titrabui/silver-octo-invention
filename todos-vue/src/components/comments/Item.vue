<template lang="pug">
  el-row
    el-card.box-card(:body-style="{ padding: '0px' }")
      el-row.box-card-header
        span.signin-info
          img.post-user-avatar(src="@/assets/images/avatar_default.png" height="25")
          span.post-user-email {{ comment.author.email }}
          span.time-ago  {{ timesAgo(comment.created_at) }}
      el-row(style="padding: 14px 20px")
        p(v-html="comment.content")
      el-row(style="padding: 14px 20px")
        ckeditor(:editor="editor" v-model="commentContent" :config="editorConfig")
        el-button(type="primary" round size="mini" @click="saveComment()") COMMENT
</template>

<script>

import moment from 'moment'
import ClassicEditor from '@ckeditor/ckeditor5-build-classic'
import { mapGetters } from 'vuex'

export default {
  name: 'CommentItem',
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
          author: { email: '' },
          content: ''
        }
      }
    }
  },
  data () {
    return {
      error: '',
      editor: ClassicEditor,
      editorConfig: {
        placeholder: 'What are your thought?'
      },
      commentContent: ''
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
