<template>
  <section id="skills" class="py-20 px-4 sm:px-6 lg:px-8 bg-gray-50 dark:bg-gray-950 transition-colors duration-500 relative overflow-hidden">
    <div class="orb top-1/4 right-10 w-60 h-60 bg-purple-500/5" />
    <div class="orb bottom-1/4 left-10 w-72 h-72 bg-blue-500/5" />

    <div class="max-w-6xl mx-auto relative z-10">
      <div class="text-center mb-12">
        <h2 class="section-title">{{ t('Technical Skills', 'Keahlian Teknis') }}</h2>
        <span class="inline-block w-16 h-1 bg-gradient-to-r from-blue-400 to-purple-500 rounded-full mt-2" />
        <p class="mt-4 text-gray-500 dark:text-gray-400 text-sm">
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

      <!-- Skill Cards -->
      <div class="card-base p-6 min-h-[200px]">
        <div v-if="isLoading" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <div v-for="i in 8" :key="i" class="skeleton h-16 rounded-xl" />
        </div>

        <template v-else>
          <div v-show="activeTab === 0" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <SkillCard v-for="s in devSkills" :key="s.id" :skill="s" color="blue" />
          </div>

          <div v-show="activeTab === 1">
            <h3 class="text-sm font-semibold text-gray-500 dark:text-gray-400 mb-4 uppercase tracking-wider">
              {{ t('Network Tools', 'Alat Jaringan') }}
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-6">
              <SkillCard v-for="s in netToolSkills" :key="s.id" :skill="s" color="green" />
            </div>
            <h3 class="text-sm font-semibold text-gray-500 dark:text-gray-400 mb-4 uppercase tracking-wider">
              {{ t('Network Knowledge', 'Pengetahuan Jaringan') }}
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              <SkillCard v-for="s in netKnowledgeSkills" :key="s.id" :skill="s" color="blue" />
            </div>
          </div>

          <div v-show="activeTab === 2" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <SkillCard v-for="s in toolSkills" :key="s.id" :skill="s" color="purple" />
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

const devSkills = computed(() => allSkills.value.filter(s => s.category === 'development'))
const netToolSkills = computed(() => allSkills.value.filter(s => s.category === 'networking_tool'))
const netKnowledgeSkills = computed(() => allSkills.value.filter(s => s.category === 'networking_knowledge'))
const toolSkills = computed(() => allSkills.value.filter(s => s.category === 'tool'))

onMounted(async () => {
  const { data } = await supabase.from('skills').select('*').order('sort_order')
  allSkills.value = data ?? []
  isLoading.value = false
})

// Inline child component
const SkillCard = {
  props: ['skill', 'color'],
  template: `
    <div class="group flex items-center gap-3 p-3 rounded-xl border border-gray-100 dark:border-gray-700 cursor-default
                hover:shadow-md hover:-translate-y-1 transition-all duration-300"
         :class="{
           'hover:border-blue-300 dark:hover:border-blue-500 hover:bg-blue-50 dark:hover:bg-blue-900/20': color === 'blue',
           'hover:border-green-300 dark:hover:border-green-500 hover:bg-green-50 dark:hover:bg-green-900/20': color === 'green',
           'hover:border-purple-300 dark:hover:border-purple-500 hover:bg-purple-50 dark:hover:bg-purple-900/20': color === 'purple',
         }">
      <div class="w-9 h-9 flex-shrink-0 flex items-center justify-center rounded-lg bg-gray-50 dark:bg-gray-700 shadow-sm">
        <img :src="skill.icon_url" :alt="skill.name" class="w-6 h-6 object-contain group-hover:scale-110 transition-transform" loading="lazy" />
      </div>
      <span class="text-sm font-semibold text-gray-800 dark:text-gray-100 truncate
                   group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">{{ skill.name }}</span>
    </div>
  `
}
</script>
