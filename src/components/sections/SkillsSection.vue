<template>
  <section id="skills" class="py-20 px-4 sm:px-6 lg:px-8 bg-transparent transition-colors duration-500 relative overflow-hidden">
    <div class="orb top-1/4 right-10 w-80 h-80 bg-purple-500/10 dark:bg-indigo-500/15" />
    <div class="orb bottom-1/4 left-10 w-80 h-80 bg-blue-500/10 dark:bg-cyan-500/15" />

    <div class="max-w-6xl mx-auto relative z-10">
      <!-- High-End Cyber-Satin Luxury Header -->
      <div class="text-center mb-16 relative">
        <div class="absolute inset-x-0 -top-6 flex justify-center pointer-events-none opacity-50 dark:opacity-35">
          <div class="w-72 h-16 bg-gradient-to-r from-blue-600 via-indigo-500 to-cyan-400 blur-2xl rounded-full"></div>
        </div>
        <div class="relative inline-flex items-center gap-2.5 px-4 py-1.5 rounded-full bg-white/60 dark:bg-slate-900/60 border border-blue-500/20 dark:border-cyan-500/25 backdrop-blur-md shadow-sm mb-4 transition-all hover:border-cyan-400/50">
          <span class="w-1.5 h-1.5 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_8px_rgba(0,216,255,0.8)]"></span>
          <span class="text-xs font-bold tracking-[0.18em] text-slate-800 dark:text-slate-200 uppercase">{{ t('Tech Stack', 'Keahlian Teknis') }}</span>
        </div>
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 dark:text-white tracking-tight">
          {{ t('Skills &', 'Sistem &') }} <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 via-indigo-600 to-cyan-500 dark:from-cyan-400 dark:via-blue-500 dark:to-indigo-400 drop-shadow-[0_2px_12px_rgba(0,216,255,0.25)]">{{ t('Technologies', 'Teknologi') }}</span>
        </h2>
        <div class="flex items-center justify-center gap-2 mt-5">
          <span class="w-2 h-2 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_10px_rgba(0,216,255,0.8)]"></span>
          <span class="w-24 h-1 rounded-full bg-gradient-to-r from-blue-600 via-indigo-500 to-transparent dark:from-cyan-400 dark:via-blue-500 dark:to-transparent"></span>
        </div>
        <p class="mt-4 text-slate-600 dark:text-slate-400 text-sm max-w-lg mx-auto leading-relaxed">
          {{ t('My toolkit across different technical domains', 'Kumpulan keahlian teknis saya di berbagai bidang') }}
        </p>
      </div>

      <!-- Tabs -->
      <div class="flex justify-center mb-8">
        <div class="inline-flex p-1 rounded-xl bg-gray-100 dark:bg-gray-800 border border-gray-200/50 dark:border-gray-700/50">
          <button
            v-for="(tab, i) in tabs"
            :key="i"
            @click="activeTab = i"
            class="px-5 py-2 text-sm font-medium rounded-lg transition-all duration-300"
            :class="activeTab === i
              ? 'bg-white dark:bg-gray-700 shadow-sm text-blue-600 dark:text-blue-400 scale-[1.02]'
              : 'text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'"
          >
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- Skill Cards Container -->
      <div class="card-base p-6 min-h-[200px]">
        <div v-if="isLoading" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <div v-for="i in 8" :key="i" class="skeleton h-16 rounded-xl" />
        </div>

        <div v-else-if="!allSkills.length" class="text-center py-12 text-gray-400 text-sm">
          Belum ada skill yang ditampilkan atau kebijakan RLS Supabase memblokir akses publik.
        </div>

        <template v-else>
          <!-- Tab 0: Development -->
          <div v-show="activeTab === 0" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <div
              v-for="skill in devSkills"
              :key="skill.id"
              class="group flex items-center gap-3.5 p-3.5 rounded-xl border border-gray-200/80 dark:border-gray-800/80 bg-white/50 dark:bg-gray-900/50 hover:border-blue-400 dark:hover:border-blue-500 hover:bg-blue-50/50 dark:hover:bg-blue-900/20 hover:shadow-md hover:-translate-y-1 transition-all duration-300"
            >
              <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center rounded-xl bg-gray-100 dark:bg-gray-800 shadow-sm overflow-hidden p-1.5">
                <img :src="skill.icon_url" :alt="skill.name" class="w-full h-full object-contain group-hover:scale-110 transition-transform" loading="lazy" />
              </div>
              <span class="text-sm font-bold text-gray-800 dark:text-gray-100 truncate group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">{{ skill.name }}</span>
            </div>
            <div v-if="!devSkills.length" class="col-span-full text-center py-8 text-xs text-gray-400">
              Belum ada skill di kategori Development.
            </div>
          </div>

          <!-- Tab 1: Networking -->
          <div v-show="activeTab === 1">
            <h3 class="text-xs font-bold text-gray-500 dark:text-gray-400 mb-3.5 uppercase tracking-wider flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span> {{ t('Network Tools', 'Alat Jaringan') }}
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-8">
              <div
                v-for="skill in netToolSkills"
                :key="skill.id"
                class="group flex items-center gap-3.5 p-3.5 rounded-xl border border-gray-200/80 dark:border-gray-800/80 bg-white/50 dark:bg-gray-900/50 hover:border-emerald-400 dark:hover:border-emerald-500 hover:bg-emerald-50/50 dark:hover:bg-emerald-900/20 hover:shadow-md hover:-translate-y-1 transition-all duration-300"
              >
                <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center rounded-xl bg-gray-100 dark:bg-gray-800 shadow-sm overflow-hidden p-1.5">
                  <img :src="skill.icon_url" :alt="skill.name" class="w-full h-full object-contain group-hover:scale-110 transition-transform" loading="lazy" />
                </div>
                <span class="text-sm font-bold text-gray-800 dark:text-gray-100 truncate group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors">{{ skill.name }}</span>
              </div>
              <div v-if="!netToolSkills.length" class="col-span-full text-center py-4 text-xs text-gray-400">
                Belum ada skill di kategori Network Tools.
              </div>
            </div>

            <h3 class="text-xs font-bold text-gray-500 dark:text-gray-400 mb-3.5 uppercase tracking-wider flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-blue-500"></span> {{ t('Network Knowledge', 'Pengetahuan Jaringan') }}
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              <div
                v-for="skill in netKnowledgeSkills"
                :key="skill.id"
                class="group flex items-center gap-3.5 p-3.5 rounded-xl border border-gray-200/80 dark:border-gray-800/80 bg-white/50 dark:bg-gray-900/50 hover:border-blue-400 dark:hover:border-blue-500 hover:bg-blue-50/50 dark:hover:bg-blue-900/20 hover:shadow-md hover:-translate-y-1 transition-all duration-300"
              >
                <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center rounded-xl bg-gray-100 dark:bg-gray-800 shadow-sm overflow-hidden p-1.5">
                  <img :src="skill.icon_url" :alt="skill.name" class="w-full h-full object-contain group-hover:scale-110 transition-transform" loading="lazy" />
                </div>
                <span class="text-sm font-bold text-gray-800 dark:text-gray-100 truncate group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">{{ skill.name }}</span>
              </div>
              <div v-if="!netKnowledgeSkills.length" class="col-span-full text-center py-4 text-xs text-gray-400">
                Belum ada skill di kategori Network Knowledge.
              </div>
            </div>
          </div>

          <!-- Tab 2: Tools -->
          <div v-show="activeTab === 2" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <div
              v-for="skill in toolSkills"
              :key="skill.id"
              class="group flex items-center gap-3.5 p-3.5 rounded-xl border border-gray-200/80 dark:border-gray-800/80 bg-white/50 dark:bg-gray-900/50 hover:border-purple-400 dark:hover:border-purple-500 hover:bg-purple-50/50 dark:hover:bg-purple-900/20 hover:shadow-md hover:-translate-y-1 transition-all duration-300"
            >
              <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center rounded-xl bg-gray-100 dark:bg-gray-800 shadow-sm overflow-hidden p-1.5">
                <img :src="skill.icon_url" :alt="skill.name" class="w-full h-full object-contain group-hover:scale-110 transition-transform" loading="lazy" />
              </div>
              <span class="text-sm font-bold text-gray-800 dark:text-gray-100 truncate group-hover:text-purple-600 dark:group-hover:text-purple-400 transition-colors">{{ skill.name }}</span>
            </div>
            <div v-if="!toolSkills.length" class="col-span-full text-center py-8 text-xs text-gray-400">
              Belum ada skill di kategori Dev Tools.
            </div>
          </div>
        </template>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Cpu } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import useLanguage from '@/composables/useLanguage'

const { t } = useLanguage()
const activeTab = ref(0)
const isLoading = ref(true)
const allSkills = ref([])

const tabs = computed(() => [
  { label: t('Development', 'Pengembangan') },
  { label: t('Networking', 'Jaringan') },
  { label: t('Tools', 'Alat / Tools') },
])

const devSkills = computed(() => allSkills.value.filter(s => {
  const cat = (s.category || '').toLowerCase()
  return cat === 'development' || cat === 'dev'
}))
const netToolSkills = computed(() => allSkills.value.filter(s => {
  const cat = (s.category || '').toLowerCase()
  return cat === 'networking_tool' || cat === 'networking' || cat === 'network_tool'
}))
const netKnowledgeSkills = computed(() => allSkills.value.filter(s => {
  const cat = (s.category || '').toLowerCase()
  return cat === 'networking_knowledge' || cat === 'network_knowledge'
}))
const toolSkills = computed(() => allSkills.value.filter(s => {
  const cat = (s.category || '').toLowerCase()
  return cat === 'tool' || cat === 'tools' || cat === 'dev_tool' || cat === 'other'
}))

onMounted(async () => {
  const { data, error } = await supabase.from('skills').select('*').order('sort_order', { ascending: true })
  if (error) {
    console.error('Gagal mengambil data skills dari Supabase:', error.message)
  }
  allSkills.value = data ?? []
  isLoading.value = false
})
</script>
