import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '@/lib/supabase'

const routes = [
  {
    path: '/',
    component: () => import('@/layouts/PublicLayout.vue'),
    children: [
      { path: '', name: 'Home', component: () => import('@/pages/HomePage.vue') },
    ]
  },
  {
    path: '/admin',
    component: () => import('@/layouts/AdminLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      { path: '', redirect: '/admin/dashboard' },
      { path: 'dashboard', name: 'AdminDashboard', component: () => import('@/pages/admin/DashboardPage.vue') },
      { path: 'settings', name: 'AdminSettings', component: () => import('@/pages/admin/SettingsPage.vue') },
      { path: 'projects', name: 'AdminProjects', component: () => import('@/pages/admin/ProjectsPage.vue') },
      { path: 'skills', name: 'AdminSkills', component: () => import('@/pages/admin/SkillsPage.vue') },
      { path: 'about-cards', name: 'AdminAboutCards', component: () => import('@/pages/admin/AboutCardsPage.vue') },
    ]
  },
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('@/pages/admin/LoginPage.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition
    if (to.hash) return { el: to.hash, behavior: 'smooth' }
    return { top: 0, behavior: 'smooth' }
  }
})

// Navigation guard for admin routes
router.beforeEach(async (to) => {
  if (to.meta.requiresAuth) {
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      return { name: 'AdminLogin' }
    }
  }
})

export default router
