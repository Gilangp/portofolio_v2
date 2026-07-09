<template>
  <div class="min-h-screen bg-[#090d16] text-slate-100 flex font-sans">
    <!-- Sidebar -->
    <aside class="w-64 bg-slate-900/90 border-r border-slate-800/80 flex flex-col fixed h-screen backdrop-blur-xl z-20">
      <div class="p-6 border-b border-slate-800/80 flex items-center justify-between">
        <RouterLink to="/" class="flex items-center gap-3 group">
          <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-blue-600 to-indigo-600 flex items-center justify-center shadow-md shadow-blue-500/20 group-hover:scale-105 transition-transform overflow-hidden p-1.5">
            <img v-if="settings?.site_logo_url" :src="settings.site_logo_url" :alt="settings?.site_logo_text || 'Logo'" class="w-full h-full object-contain" />
            <span v-else class="text-lg font-black text-white">{{ settings?.site_logo_text || 'GP' }}</span>
          </div>
          <div>
            <p class="text-sm font-bold text-slate-100 leading-tight">Admin Portal</p>
            <p class="text-[11px] text-slate-400">Portfolio V2</p>
          </div>
        </RouterLink>
      </div>

      <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
        <RouterLink
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-400 hover:text-slate-100 hover:bg-slate-800/60 transition-all duration-200"
          active-class="bg-blue-600/15 !text-blue-400 border-l-2 border-blue-500 font-semibold shadow-sm"
        >
          <component :is="item.icon" class="w-4 h-4 flex-shrink-0" />
          {{ item.label }}
        </RouterLink>
      </nav>

      <div class="p-4 border-t border-slate-800/80 space-y-3">
        <div class="flex items-center gap-3 px-2 py-1">
          <div class="w-8 h-8 rounded-full bg-slate-800 border border-slate-700 flex items-center justify-center text-xs font-bold text-blue-400">
            {{ userInitial }}
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-xs font-semibold text-slate-200 truncate">{{ userEmail }}</p>
            <p class="text-[11px] text-slate-500">Administrator</p>
          </div>
        </div>
        <button
          @click="logout"
          class="w-full flex items-center gap-2 px-3 py-2 text-xs font-medium text-rose-400 hover:text-rose-300 hover:bg-rose-500/10 rounded-xl transition-all duration-200"
        >
          <LogOut class="w-3.5 h-3.5" />
          Keluar (Logout)
        </button>
      </div>
    </aside>

    <!-- Main content -->
    <div class="flex-1 ml-64 flex flex-col min-h-screen">
      <header class="sticky top-0 z-10 bg-[#090d16]/80 backdrop-blur-md border-b border-slate-800/80 px-8 py-4 flex items-center justify-between">
        <div>
          <h1 class="text-base font-bold text-slate-200">{{ currentRouteName }}</h1>
        </div>
        <RouterLink
          to="/"
          target="_blank"
          class="flex items-center gap-1.5 px-3 py-1.5 bg-slate-800/60 hover:bg-slate-800 border border-slate-700/60 rounded-lg text-xs font-medium text-slate-300 hover:text-white transition-all shadow-sm"
        >
          <ExternalLink class="w-3.5 h-3.5 text-blue-400" />
          Lihat Website Live
        </RouterLink>
      </header>

      <main class="flex-1 p-8 overflow-y-auto max-w-6xl">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { supabase } from '@/lib/supabase'
import { LayoutDashboard, Settings, FolderKanban, Cpu, UserSquare2, LogOut, ExternalLink } from 'lucide-vue-next'
import useSiteSettings from '@/composables/useSiteSettings'

const router = useRouter()
const route = useRoute()
const { settings } = useSiteSettings()
const userEmail = ref('admin@portofolio.dev')

onMounted(async () => {
  const { data: { user } } = await supabase.auth.getUser()
  if (user?.email) userEmail.value = user.email
})

const userInitial = computed(() => userEmail.value ? userEmail.value.charAt(0).toUpperCase() : 'A')

const navItems = [
  { to: '/admin/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/admin/settings', label: 'Pengaturan Umum', icon: Settings },
  { to: '/admin/projects', label: 'Proyek', icon: FolderKanban },
  { to: '/admin/skills', label: 'Keahlian (Skills)', icon: Cpu },
  { to: '/admin/about-cards', label: 'Kartu About', icon: UserSquare2 },
]

const routeNames = {
  'AdminDashboard': 'Ringkasan Dashboard',
  'AdminSettings': 'Pengaturan Umum & Biodata',
  'AdminProjects': 'Manajemen Proyek Portofolio',
  'AdminSkills': 'Manajemen Keahlian & Tools',
  'AdminAboutCards': 'Manajemen Kartu Keahlian Fokus',
}

const currentRouteName = computed(() => routeNames[route.name] || 'Admin Panel')

const logout = async () => {
  await supabase.auth.signOut()
  router.push('/admin/login')
}
</script>
