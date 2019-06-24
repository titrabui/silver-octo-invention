<template>
  <el-container>
    <el-header style="border-bottom: 1px solid #ced4da">
      <AppHeader></AppHeader>
    </el-header>
    <el-container>
      <el-container>
        <el-main>
          <router-view></router-view>
        </el-main>
      </el-container>
      <!-- <el-aside>
        <AppSideBar></AppSideBar>
      </el-aside> -->
    </el-container>
  </el-container>
</template>

<script>

import AppHeader from '@/components/AppHeader'
import AppSideBar from '@/components/AppSideBar'

export default {
  name: 'App',
  components: {
    AppHeader,
    AppSideBar
  },
  methods: {
    showSideBarMenu () {
      return this.$store.getters.isAdmin || this.$store.getters.isManager
    }
  }
}
</script>

<style>
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>
