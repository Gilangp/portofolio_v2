<template>
  <section id="skills" class="min-h-screen py-16 px-4 sm:px-6 lg:px-8 bg-gray-100 text-gray-900 dark:bg-gradient-to-br dark:from-gray-900 dark:via-gray-850 dark:to-gray-800 dark:text-white transition-colors duration-700 relative overflow-hidden">
    <!-- Background elements -->
    <div class="absolute top-1/4 left-10 w-80 h-80 bg-blue-500/5 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute bottom-1/4 right-10 w-80 h-80 bg-purple-500/5 rounded-full blur-3xl pointer-events-none"></div>

    <div class="max-w-7xl mx-auto relative z-10">
      <div class="text-center mb-12 animate-fade-in">
        <h2 class="text-3xl md:text-4xl font-bold mb-4 relative inline-block">
          <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 dark:from-blue-400 dark:via-purple-400 dark:to-pink-400">
            {{ t('Technical Skills', 'Keahlian Teknis') }}
          </span>
          <span class="absolute -bottom-2 left-1/2 transform -translate-x-1/2 w-20 h-1 bg-gradient-to-r from-blue-400 via-purple-500 to-pink-400 rounded-full animate-wave"></span>
        </h2>
        <p class="text-base text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
          {{ t('My toolkit categorized by different technical domains', 'Perangkat keahlian saya yang dikelompokkan ke dalam beberapa bidang teknis') }}
        </p>
      </div>

      <!-- Tabs -->
      <div class="flex justify-center mb-8 animate-fade-in" style="animation-delay: 0.2s">
        <div class="inline-flex gap-1 rounded-xl bg-gray-200/80 dark:bg-gray-800/90 p-1.5 backdrop-blur-sm border border-gray-300/50 dark:border-gray-700/50 shadow-inner">
          <button
            v-for="(tab, index) in tabs"
            :key="index"
            @click="activeTab = index"
            :class="[
              'px-5 py-2.5 text-sm font-medium rounded-lg transition-all duration-300',
              activeTab === index
                ? 'bg-white dark:bg-gray-700 shadow-md text-blue-600 dark:text-blue-400 font-semibold'
                : 'text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100/60 dark:hover:bg-gray-700/40'
            ]"
          >
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- Skill Cards Container -->
      <div class="bg-white/90 dark:bg-gray-800/90 rounded-xl shadow-sm border border-gray-100/50 dark:border-gray-700/50 p-6 backdrop-blur-sm animate-fade-in" style="animation-delay: 0.4s">
        <div v-if="isLoading" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          <div v-for="i in 10" :key="i" class="skeleton h-16 rounded-lg" />
        </div>

        <div v-else-if="!allSkills.length" class="text-center py-12 text-gray-400 text-sm">
          {{ t('No skills to display yet.', 'Belum ada skill yang ditampilkan.') }}
        </div>

        <template v-else>
          <!-- Tab 0: Development -->
          <div v-show="activeTab === 0">
            <h3 class="text-xl font-bold text-gray-800 dark:text-white mb-5 flex items-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
              </svg>
              {{ t('Web Development & Programming', 'Pengembangan Web & Pemrograman') }}
            </h3>
            <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
              <div
                v-for="skill in devSkills"
                :key="skill.id"
                class="group flex items-center gap-3 p-3 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-lg transition-all duration-300 border border-gray-100 dark:border-gray-700 hover:border-blue-300 dark:hover:border-blue-500 hover:shadow-md cursor-pointer transform hover:-translate-y-1"
              >
                <div class="flex-shrink-0 h-8 w-8 flex items-center justify-center rounded-md bg-gray-50 dark:bg-gray-700 shadow-sm group-hover:bg-white dark:group-hover:bg-gray-600 transition-colors p-1">
                  <img :src="skill.icon_url" :alt="skill.name" class="h-5 w-5 object-contain transition-transform duration-300 group-hover:scale-110" loading="lazy" />
                </div>
                <div class="flex-1 min-w-0">
                  <h4 class="text-sm font-semibold text-gray-800 dark:text-gray-100 truncate group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">{{ skill.name }}</h4>
                </div>
              </div>
            </div>
            <div v-if="!devSkills.length" class="text-center py-8 text-xs text-gray-400">
              {{ t('No skills in Development category.', 'Belum ada skill di kategori Development.') }}
            </div>
          </div>

          <!-- Tab 1: Networking -->
          <div v-show="activeTab === 1" class="space-y-8">
            <!-- Network Tools -->
            <div>
              <h3 class="text-xl font-bold text-gray-800 dark:text-white mb-5 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z" />
                </svg>
                {{ t('Network Tools & Simulators', 'Perangkat Lunak & Simulator Jaringan') }}
              </h3>
              <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
                <div
                  v-for="skill in netToolSkills"
                  :key="skill.id"
                  class="group flex items-center gap-3 p-3 hover:bg-green-50 dark:hover:bg-green-900/20 rounded-lg transition-all duration-300 border border-gray-100 dark:border-gray-700 hover:border-green-300 dark:hover:border-green-500 hover:shadow-md cursor-pointer transform hover:-translate-y-1"
                >
                  <div class="flex-shrink-0 h-8 w-8 flex items-center justify-center rounded-md bg-gray-50 dark:bg-gray-700 shadow-sm group-hover:bg-white dark:group-hover:bg-gray-600 transition-colors p-1">
                    <img :src="skill.icon_url" :alt="skill.name" class="h-5 w-5 object-contain transition-transform duration-300 group-hover:scale-110" loading="lazy" />
                  </div>
                  <div class="flex-1 min-w-0">
                    <h4 class="text-sm font-semibold text-gray-800 dark:text-gray-100 truncate group-hover:text-green-600 dark:group-hover:text-green-400 transition-colors">{{ skill.name }}</h4>
                  </div>
                </div>
              </div>
              <div v-if="!netToolSkills.length" class="text-center py-4 text-xs text-gray-400">
                {{ t('No network tools listed.', 'Belum ada perangkat jaringan.') }}
              </div>
            </div>

            <!-- Network Knowledge -->
            <div>
              <h3 class="text-xl font-bold text-gray-800 dark:text-white mb-5 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-purple-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
                {{ t('Network Protocols & Concepts', 'Konsep & Protokol Jaringan') }}
              </h3>
              <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
                <div
                  v-for="skill in netKnowledgeSkills"
                  :key="skill.id"
                  class="group flex items-center gap-3 p-3 hover:bg-purple-50 dark:hover:bg-purple-900/20 rounded-lg transition-all duration-300 border border-gray-100 dark:border-gray-700 hover:border-purple-300 dark:hover:border-purple-500 hover:shadow-md cursor-pointer transform hover:-translate-y-1"
                >
                  <div class="flex-shrink-0 h-8 w-8 flex items-center justify-center rounded-md bg-gray-50 dark:bg-gray-700 shadow-sm group-hover:bg-white dark:group-hover:bg-gray-600 transition-colors p-1">
                    <img :src="skill.icon_url" :alt="skill.name" class="h-5 w-5 object-contain transition-transform duration-300 group-hover:scale-110" loading="lazy" />
                  </div>
                  <div class="flex-1 min-w-0">
                    <h4 class="text-sm font-semibold text-gray-800 dark:text-gray-100 truncate group-hover:text-purple-600 dark:group-hover:text-purple-400 transition-colors">{{ skill.name }}</h4>
                  </div>
                </div>
              </div>
              <div v-if="!netKnowledgeSkills.length" class="text-center py-4 text-xs text-gray-400">
                {{ t('No network concepts listed.', 'Belum ada konsep jaringan.') }}
              </div>
            </div>
          </div>

          <!-- Tab 2: Tools -->
          <div v-show="activeTab === 2">
            <h3 class="text-xl font-bold text-gray-800 dark:text-white mb-5 flex items-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-pink-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              {{ t('Development Tools & Platforms', 'Perangkat Lunak & Platform Pengembangan') }}
            </h3>
            <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
              <div
                v-for="skill in toolSkills"
                :key="skill.id"
                class="group flex items-center gap-3 p-3 hover:bg-pink-50 dark:hover:bg-pink-900/20 rounded-lg transition-all duration-300 border border-gray-100 dark:border-gray-700 hover:border-pink-300 dark:hover:border-pink-500 hover:shadow-md cursor-pointer transform hover:-translate-y-1"
              >
                <div class="flex-shrink-0 h-8 w-8 flex items-center justify-center rounded-md bg-gray-50 dark:bg-gray-700 shadow-sm group-hover:bg-white dark:group-hover:bg-gray-600 transition-colors p-1">
                  <img :src="skill.icon_url" :alt="skill.name" class="h-5 w-5 object-contain transition-transform duration-300 group-hover:scale-110" loading="lazy" />
                </div>
                <div class="flex-1 min-w-0">
                  <h4 class="text-sm font-semibold text-gray-800 dark:text-gray-100 truncate group-hover:text-pink-600 dark:group-hover:text-pink-400 transition-colors">{{ skill.name }}</h4>
                </div>
              </div>
            </div>
            <div v-if="!toolSkills.length" class="text-center py-8 text-xs text-gray-400">
              {{ t('No skills in Dev Tools category.', 'Belum ada skill di kategori Dev Tools.') }}
            </div>
          </div>
        </template>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
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
  const { data, error } = await supabase.from('skills').select('*').or('is_visible.is.null,is_visible.eq.true').order('sort_order', { ascending: true })
  if (error) {
    console.error('Gagal mengambil data skills dari Supabase:', error.message)
  }
  allSkills.value = (data ?? []).filter(s => s.is_visible !== false)
  isLoading.value = false
})
</script>
