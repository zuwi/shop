import Vue from 'vue'
import Router from 'vue-router'
import Login from '@/components/Login.vue'
import Registration from '@/components/Registration.vue'
import Items from '@/components/items/Items.vue'
import Brands from '@/components/brands/Brands.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'Login',
      component: Login
    },
    {
      path: '/registration',
      name: 'Registration',
      component: Registration
    },
    {
      path: '/items',
      name: 'Items',
      component: Items
    },
    {
      path: '/brands',
      name: 'Brands',
      component: Brands
    }
  ]
})
