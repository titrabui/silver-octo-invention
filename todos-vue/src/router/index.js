import Vue from 'vue'
import Router from 'vue-router'
import { store } from './../store'
import { Notification } from 'element-ui'
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
import UserSettings from '@/components/settings/Index'

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/todos',
      name: 'List',
      component: TodosList
    },
    {
      path: '/settings',
      name: 'UserSettings',
      component: UserSettings,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/users',
      name: 'UsersList',
      component: UsersList,
      meta: { requiresAuth: true, roles: ['admin', 'manager'] }
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
      component: UserEdit,
      meta: { requiresAuth: true }
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
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)

  if (requiresAuth) {
    const requiresRoles = to.matched.some(record => record.meta.roles)

    if (!store.state.app.signedIn) {
      next({
        path: '/signin',
        query: { redirect: to.fullPath }
      })
      Notification({
        title: 'Login required',
        message: 'Please log in to do this',
        type: 'error',
        duration: 2000
      })
    } else if (requiresRoles) {
      const roles = to.matched.map(record => record.meta.roles)[0]
      if (store.state.app.currentUser && !roles.includes(store.state.app.currentUser.role)) {
        next({
          path: '/',
          query: { redirect: to.fullPath }
        })
      } else {
        next()
      }
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
