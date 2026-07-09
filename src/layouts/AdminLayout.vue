<template>
  <div class="min-h-screen bg-gray-950 text-white flex">
    <!-- Sidebar -->
    <aside class="w-64 bg-gray-900 border-r border-gray-800 flex flex-col fixed h-screen">
      <div class="p-6 border-b border-gray-800">
        <RouterLink to="/" class="flex items-center gap-2 group">
          <span class="text-2xl font-black text-gradient">GP</span>
          <div>
            <p class="text-xs font-semibold text-gray-300">Admin Panel</p>
            <p class="text-xs text-gray-500">Portfolio V2</p>
          </div>
        </RouterLink>
      </div>

      <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
        <RouterLink
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          class="flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm text-gray-400 hover:text-white hover:bg-gray-800 transition-all duration-200"
          active-class="bg-gradient-to-r from-violet-600/20 to-indigo-600/20 !text-violet-300 border-r-2 border-violet-500"
        >
          <component :is="item.icon" class="w-4 h-4" />
          {{ item.label }}
        </RouterLink>
      </nav>

      <div class="p-4 border-t border-gray-800">
        <div class="flex items-center gap-3 mb-3">
          <div class="w-8 h-8 rounded-full bg-gradient-to-br from-violet-500 to-indigo-600 flex items-center justify-center text-xs font-bold">
            A
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-xs font-medium text-gray-300 truncate">{{ userEmail }}</p>
            <p class="text-xs text-gray-500">Administrator</p>
          </div>
        </div>
        <button @click="logout" class="w-full flex items-center gap-2 px-3 py-2 text-sm text-red-400 hover:text-red-300 hover:bg-red-900/20 rounded-lg transition-all duration-200">
          <LogOut class="w-4 h-4" />
          Logout
        </button>
      </div>
    </aside>

    <!-- Main content -->
    <div class="flex-1 ml-64 flex flex-col">
      <header class="sticky top-0 z-10 bg-gray-950/80 backdrop-blur-sm border-b border-gray-800 px-6 py-3 flex items-center justify-between">
        <h1 class="text-sm font-semibold text-gray-300">{{ currentRouteName }}</h1>
        <RouterLink to="/" target="_blank" class="flex items-center gap-1.5 text-xs text-gray-500 hover:text-gray-300 transition-colors">
          <ExternalLink class="w-3.5 h-3.5" />
          Lihat Website
        </RouterLink>
      </header>
      <main class="flex-1 p-6 overflow-y-auto">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { LayoutDashboard, Settings, FolderKanban, Cpu, UserSquare2, LogOut, ExternalLink } from 'lucide-vue-next'

const router = useRouter()
const route = useRoute()

const navItems = [
  { to: '/admin/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/admin/settings', label: 'Pengaturan Umum', icon: Settings },
  { to: '/admin/projects', label: 'Proyek', icon: FolderKanban },
  { to: '/admin/skills', label: 'Keahlian (Skills)', icon: Cpu },
  { to: '/admin/about-cards', label: 'Kartu About', icon: UserSquare2 },
]

const routeNames = {
  'AdminDashboard': 'Dashboard',
  'AdminSettings': 'Pengaturan Umum',
  'AdminProjects': 'Manajemen Proyek',
  'AdminSkills': 'Manajemen Keahlian',
  'AdminAboutCards': 'Manajemen Kartu About',
}

const currentRouteName = computed(() => routeNames[route.name] || 'Admin Panel')
const userEmail = computed(() => supabase.auth.getUser()?.then?.(r => r?.data?.user?.email) || 'admin@portofolio.dev')

const logout = async () => {
  await supabase.auth.signOut()
  router.push('/admin/login')
}
</script>
