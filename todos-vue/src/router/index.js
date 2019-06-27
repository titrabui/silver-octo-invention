import Vue from 'vue'
import Router from 'vue-router'
import { store } from './../store'
import { Notification } from 'element-ui'
import Signin from '@/components/Signin'
import Signup from '@/components/Signup'
import TodosList from '@/components/todos/List'
import UsersList from '@/components/admin/users/List'
import UserTodosList from '@/components/admin/users/todos/List'
import ForgotPassword from '@/components/ForgotPassword'
import ResetPassword from '@/components/ResetPassword'
import UserEdit from '@/components/admin/users/Edit'
import PostsList from '@/components/posts/List'
import PostDetail from '@/components/posts/Detail'
import PostCreate from '@/components/posts/Create'
import PostManage from '@/components/posts/Manage'

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/signin',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },
    {
      path: '/todos',
      name: 'List',
      component: TodosList
    },
    {
      path: '/admin/users',
      name: 'UsersList',
      component: UsersList
    },
    {
      path: '/admin/users/:id/todos',
      name: 'UserTodosList',
      component: UserTodosList
    },
    {
      path: '/forgot_password',
      name: 'ForgotPassword',
      component: ForgotPassword
    },
    {
      path: '/password_resets/:token',
      name: 'ResetPassword',
      component: ResetPassword
    },
    {
      path: '/admin/users/:id',
      name: 'UserEdit',
      component: UserEdit
    },
    {
      path: '/',
      name: 'PostList',
      component: PostsList
    },
    {
      path: '/news/:id',
      name: 'PostDetail',
      component: PostDetail
    },
    {
      path: '/news-create',
      name: 'PostCreate',
      component: PostCreate,
      meta: { requiresAuth: true }
    },
    {
      path: '/news/:id/edit',
      name: 'PostEdit',
      component: PostCreate,
      meta: { requiresAuth: true }
    },
    {
      path: '/news-manage',
      name: 'PostManage',
      component: PostManage,
      meta: { requiresAuth: true }
    }
  ]
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!store.state.signedIn) {
      next({
        path: '/signin',
        query: { redirect: to.fullPath }
      })
      Notification({
        title: 'Login required',
        message: 'Please log in to do this',
        type: 'warning',
        duration: 2000
      })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
