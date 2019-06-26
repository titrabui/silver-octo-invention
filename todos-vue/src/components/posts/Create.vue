<template lang="pug">
  el-row
    el-col(:span="12" :offset="6")
      el-card.box-card(:body-style="{ padding: '0px' }" v-if="Object.keys(post).length")
        el-row.box-card-header
          span.box-header-title Create a News
          el-button(style="float: right" type="primary" icon="el-icon-back" round size="mini" @click="backHome()") BACK
        el-row(style="padding: 14px 20px")
          el-form(ref="postForm" :rules="postValidates" label-position="top" label-width="100px")
            el-form-item(label="Title" prop="title")
              el-input(placeholder="Please input title" v-model="post.title")
            el-form-item(label="Sub title" prop="sub_title")
              el-input(placeholder="Please input sub title" type="textarea" :rows="2" v-model="post.subTitle")
            el-form-item(label="Text" prop="description")
              ckeditor(:editor="editor" v-model="post.description" :config="editorConfig")
            el-form-item
              el-row(style="float: right")
                el-button(icon="el-icon-close" round @click="backHome()") Cancel
                el-button(type="primary" icon="el-icon-s-promotion" round @click="createPost()") Ship it
</template>

<script>

import ClassicEditor from '@ckeditor/ckeditor5-build-classic'

export default {
  name: 'Create',
  data () {
    return {
      post: {
        title: '',
        subTitle: '',
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
          { required: true, message: 'Please input description', trigger: 'blur' }
        ]
      },
      error: ''
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    backHome () {
      this.$router.replace('/')
    },
    createPost () {
      this.$refs['postForm'].validate((valid) => {
        if (valid) {
          this.$http.secured.post('/posts', { post: this.post })
            .then(response => {
              this.$router.replace('/')
              this.post = {
                title: '',
                subTitle: '',
                description: ''
              }
            })
            .catch(error => this.setError(error, 'Cannot create post'))
        } else {
          return false
        }
      })
    }
  }
}
</script>

<style lang="css">
.box-card {
  margin-bottom: 15px;
}
.box-card-header {
  padding: 14px;
  background-color: #faebd775;
}
.box-header-title {
  font-weight: bold;
  font-size: 18px;
}
.ck-content {
  min-height: 200px !important;
}
</style>
