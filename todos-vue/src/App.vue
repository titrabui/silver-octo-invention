<template>
  <el-container>
    <el-header>
      <AppHeader></AppHeader>
    </el-header>
    <el-container>
      <el-aside v-if="showSideBarMenu()" width="auto" max-width="200px">
        <AppSideBar></AppSideBar>
      </el-aside>
      <el-container>
        <el-main>
          <router-view></router-view>
        </el-main>
      </el-container>
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
