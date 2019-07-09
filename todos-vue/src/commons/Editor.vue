<template lang="pug">
  el-row
    el-row
      ckeditor(:editor="editor" v-model="editorContent" :config="editorConfig")
    el-row.editor-btn
      el-button(round size="mini" @click="onCancel()" v-if="hasCancelBtn") Cancel
      el-button(type="primary" round size="mini" @click="onSave()") {{ buttonName }}
</template>

<script>

import ClassicEditor from '@ckeditor/ckeditor5-build-classic'
import { mapGetters } from 'vuex'

export default {
  name: 'Editor',
  computed: {
    ...mapGetters({
      currentUser: 'currentUser'
    })
  },
  props: {
    buttonName: String,
    hasCancelBtn: {
      type: Boolean,
      default: function () {
        return false
      }
    },
    content: String
  },
  data () {
    return {
      editorContent: this.content || '',
      editor: ClassicEditor,
      editorConfig: {
        placeholder: 'What are your thought?'
      }
    }
  },
  methods: {
    onSave () {
      this.$emit('on-save', this.editorContent)
      this.editorContent = ''
    },
    onCancel () {
      this.$emit('on-cancel')
    }
  }
}
</script>

<style lang="css" scoped>
.ck-content {
  min-height: 200px !important;
}
.editor-btn {
  margin: 5px 0;
  text-align: right;
}
</style>
