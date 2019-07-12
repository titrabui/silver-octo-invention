<template lang="pug">
  el-upload.avatar-uploader(
    action="https://jsonplaceholder.typicode.com/posts/"
    :http-request="uploadSectionFile"
    :show-file-list="false"
    :before-upload="beforeAvatarUpload")
    img.avatar(v-if="imageUrl" :src="imageUrl")
    i.el-icon-plus.avatar-uploader-icon(v-else)
</template>

<script>
export default {
  props: {
    imageUrl: {
      type: String,
      default: () => {
        return ''
      }
    }
  },
  methods: {
    beforeAvatarUpload (file) {
      const isJPG = file.type === 'image/jpeg'
      const isLt2M = file.size / 1024 / 1024 < 2

      if (!isJPG) {
        this.$message.error('Avatar picture must be JPG format!')
      }
      if (!isLt2M) {
        this.$message.error('Avatar picture size can not exceed 2MB!')
      }
      return isJPG && isLt2M
    },
    uploadSectionFile (param) {
      this.$emit('on-upload', param)
    }
  }
}
</script>

<style>
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 250px;
    height: 250px;
    line-height: 250px;
    text-align: center;
  }
  .avatar {
    width: 250px;
    height: 250px;
    display: block;
  }
</style>
