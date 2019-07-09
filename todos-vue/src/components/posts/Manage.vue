<template lang="pug">
  el-row
    el-col(:span="20" :offset="2")
      el-card.box-card(:body-style="{ padding: '0px' }")
        el-row.box-card-header
          span.box-header-title
            i(class="el-icon-news")
            span  News Management
        el-row(style="padding: 10px 20px; text-align: right")
          el-input(
            placeholder="Search news"
            prefix-icon="el-icon-search"
            v-model="search"
            style="width: 400px"
          )
        el-row(style="padding: 14px 20px")
          el-table(:data="posts.filter(data => !search || data.title.toLowerCase().includes(search.toLowerCase())).slice((currentPage - 1) * pageSize, (currentPage - 1) * pageSize + pageSize)" style="width: 100%" empty-text="No data")
            el-table-column(type="expand")
              template(slot-scope="props")
                p(v-html="props.row.description")
            el-table-column(label="News ID" prop="id" width="80")
            el-table-column(label="Image" width="80")
              template(slot-scope="scope")
                img(:src="scope.row.image_url" style="width: 100%")
            el-table-column(label="Title" prop="title" width="400")
            el-table-column(label="Sub Title" prop="sub_title" width="400")
            el-table-column(label="Comments" align="right" width="100")
              template(slot-scope="scope")
                span {{ (scope.row.comments && scope.row.comments.length) || 0 }}
            el-table-column(label="Author" min-width="150")
              template(slot-scope="scope")
                span {{ scope.row.user.email }}
            el-table-column(label="Created At" width="150")
              template(slot-scope="scope")
                span {{ createdAt(scope.row.created_at) }}
            el-table-column(fixed="right" label="Operations" width="120")
              template(slot-scope="scope")
                el-tooltip(content="Edit")
                  el-button(@click="editPost(scope.row.id)" type="warning" icon="el-icon-edit" circle)
                el-tooltip(content="Delete")
                  el-button(@click="deletePost(scope.row.id)" type="danger" icon="el-icon-delete" circle)
        el-row(style="padding: 14px 20px; text-align: center;")
          el-pagination(
            background
            layout="prev, pager, next"
            :current-page.sync="currentPage"
            :page-size="pageSize"
            :pager-count="5"
            :total="posts.length"
          )
</template>

<script>

import moment from 'moment'
import { mapGetters } from 'vuex'

export default {
  name: 'Manage',
  computed: {
    ...mapGetters({
      isAdmin: 'isAdmin',
      isManager: 'isManager',
      currentUserId: 'currentUserId',
      postManageUserId: 'postManageUserId'
    })
  },
  data () {
    return {
      posts: [],
      search: '',
      currentPage: 1,
      pageSize: 10,
      error: ''
    }
  },
  created () {
    this.fetchPosts()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createdAt (createdAt) {
      return moment(createdAt).format('DD - MM - YYYY H:mm:ss')
    },
    backHome () {
      this.$router.replace('/')
    },
    editPost (postId) {
      this.$router.replace(`/news/${postId}/edit`)
    },
    deletePost (postId) {
      this.$confirm('This will permanently delete the news. Continue?', 'Warning', {
        confirmButtonText: 'OK',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        this.$http.secured.delete(`/posts/${postId}`)
          .then(response => {
            this.$notify({
              type: 'success',
              message: 'Delete completed'
            })
            this.fetchPosts()
          })
          .catch(error => this.setError(error, 'Cannot update post'))
      }).catch(() => {})
    },
    fetchPosts () {
      if (this.isAdmin || this.isManager) {
        if (this.postManageUserId) {
          this.$http.secured.get('/posts_by_user', { params: { user_id: this.postManageUserId } })
            .then(response => { this.posts = response.data })
            .catch(error => this.setError(error, 'Something went wrong'))
        } else {
          this.$http.plain.get('/posts')
            .then(response => { this.posts = response.data })
            .catch(error => this.setError(error, 'Something went wrong'))
        }
      } else {
        this.$http.secured.get('/posts_by_user', { params: { user_id: this.currentUserId } })
          .then(response => { this.posts = response.data })
          .catch(error => this.setError(error, 'Something went wrong'))
      }
    }
  }
}
</script>
