<template lang="pug">
  el-row
    el-col(:span="12" :offset="6")
      el-card.box-card(:body-style="{ padding: '0px' }" v-if="Object.keys(post).length")
        el-row.box-card-header
          span.box-header-title {{ isUpdating() ? 'Update News' : 'Create a News' }}
          el-button(style="float: right" type="primary" icon="el-icon-back" round size="mini" @click="backHome()") BACK
        el-row(style="padding: 14px 20px")
          el-form(ref="postForm" :rules="postValidates" :model="post" label-position="top" label-width="100px" :hide-required-asterisk="true")
            el-form-item(label="Title" prop="title")
              el-input(placeholder="Please input title" v-model="post.title" maxlength="255" show-word-limit)
            el-form-item(label="Sub title" prop="sub_title")
              el-input(placeholder="Please input sub title" type="textarea" :rows="2" v-model="post.sub_title" maxlength="255" show-word-limit)
            el-form-item(label="Text" prop="description")
              ckeditor(:editor="editor" v-model="post.description" :config="editorConfig")
            el-form-item
              el-row(style="float: right")
                el-button(icon="el-icon-close" round @click="backHome()") Cancel
                el-button(type="primary" icon="el-icon-s-promotion" round @click="savePost()") Ship it
</template>

<script>

import ClassicEditor from '@ckeditor/ckeditor5-build-classic'

export default {
  name: 'Create',
  data () {
    return {
      post: {
        title: '',
        sub_title: '',
        description: ''
      },
      editor: ClassicEditor,
      editorConfig: {
        placeholder: 'Type some text...'
      },
      postValidates: {
        title: [
          { required: true, message: 'Please input title', trigger: 'blur' }
        ],
        sub_title: [
          { required: true, message: 'Please input sub title', trigger: 'blur' }
        ],
        description: [
          { required: true, message: 'Please input news text', trigger: 'blur' }
        ]
      },
      postId: null,
      error: ''
    }
  },
  created () {
    this.postId = this.$route.params.id
    if (this.postId) {
      this.$http.plain.get(`/posts/${this.postId}`)
        .then(response => { this.post = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    backHome () {
      this.$router.go(-1)
    },
    savePost () {
      this.$refs['postForm'].validate((valid) => {
        if (valid) {
          if (this.isUpdating()) {
            this.updatePost()
          } else {
            this.createPost()
          }
        } else {
          return false
        }
      })
    },
    createPost () {
      this.$http.secured.post('/posts', { post: this.post })
        .then(response => {
          this.post = {
            title: '',
            subTitle: '',
            description: ''
          }
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot create post'))
    },
    updatePost () {
      this.$http.secured.patch(`/posts/${this.postId}`, { post: this.post })
        .then(response => {
          this.post = {
            title: '',
            subTitle: '',
            description: ''
          }
          this.$router.go(-1)
        })
        .catch(error => this.setError(error, 'Cannot update post'))
    },
    isUpdating () {
      return !!this.postId
    }
  }
}
</script>

<style lang="css" scoped>
.ck-content {
  min-height: 200px !important;
}
</style>
