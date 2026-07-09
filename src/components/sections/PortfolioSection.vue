<template>
  <section id="portfolio" class="py-20 px-4 sm:px-6 lg:px-8 bg-white/40 dark:bg-[#070a13]/40 backdrop-blur-sm transition-colors duration-500 relative overflow-hidden">
    <div class="orb top-1/4 left-1/5 w-80 h-80 bg-blue-500/10 dark:bg-cyan-500/15" />
    <div class="orb bottom-1/3 right-1/4 w-80 h-80 bg-purple-500/10 dark:bg-indigo-500/15" />

    <div class="max-w-7xl mx-auto relative z-10">
      <!-- High-End Cyber-Satin Luxury Header -->
      <div class="text-center mb-16 relative">
        <div class="absolute inset-x-0 -top-6 flex justify-center pointer-events-none opacity-50 dark:opacity-35">
          <div class="w-72 h-16 bg-gradient-to-r from-blue-600 via-indigo-500 to-cyan-400 blur-2xl rounded-full"></div>
        </div>
        <div class="relative inline-flex items-center gap-2.5 px-4 py-1.5 rounded-full bg-white/60 dark:bg-slate-900/60 border border-blue-500/20 dark:border-cyan-500/25 backdrop-blur-md shadow-sm mb-4 transition-all hover:border-cyan-400/50">
          <span class="w-1.5 h-1.5 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_8px_rgba(0,216,255,0.8)]"></span>
          <span class="text-xs font-bold tracking-[0.18em] text-slate-800 dark:text-slate-200 uppercase">{{ t('Showcase', 'Portofolio') }}</span>
        </div>
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 dark:text-white tracking-tight">
          {{ t('Featured', 'Proyek') }} <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 via-indigo-600 to-cyan-500 dark:from-cyan-400 dark:via-blue-500 dark:to-indigo-400 drop-shadow-[0_2px_12px_rgba(0,216,255,0.25)]">{{ t('Projects', 'Unggulan') }}</span>
        </h2>
        <div class="flex items-center justify-center gap-2 mt-5">
          <span class="w-2 h-2 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_10px_rgba(0,216,255,0.8)]"></span>
          <span class="w-24 h-1 rounded-full bg-gradient-to-r from-blue-600 via-indigo-500 to-transparent dark:from-cyan-400 dark:via-blue-500 dark:to-transparent"></span>
        </div>
        <p class="mt-4 text-slate-600 dark:text-slate-400 text-sm max-w-lg mx-auto leading-relaxed">
          {{ t('Click on any project to see details.', 'Klik proyek untuk melihat detail spesifikasi dan demo.') }}
        </p>
      </div>

      <!-- Skeleton -->
      <div v-if="isLoading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="i in 6" :key="i" class="skeleton h-72 rounded-2xl" />
      </div>

      <!-- Project Grid -->
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="(project, i) in projects"
          :key="project.id"
          @click="openModal(project)"
          class="card-base group cursor-pointer hover:shadow-xl hover:-translate-y-2 overflow-hidden"
          :style="`animation-delay: ${i * 0.1}s`"
        >
          <div class="relative overflow-hidden h-48">
            <img
              :src="project.image_url"
              :alt="project.title"
              class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
              loading="lazy"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent flex items-end p-4">
              <h3 class="text-white font-bold text-lg leading-tight">{{ project.title }}</h3>
            </div>
            <div class="absolute top-3 right-3 flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
              <span v-if="project.live_url" class="px-2 py-0.5 bg-green-500 text-white text-xs font-bold rounded-full">Live</span>
              <span v-if="project.code_url" class="px-2 py-0.5 bg-gray-800 text-white text-xs font-bold rounded-full">Code</span>
            </div>
          </div>
          <div class="p-4 flex flex-col gap-3">
            <p class="text-gray-500 dark:text-gray-400 text-sm line-clamp-2">
              {{ currentLang === 'en' ? project.short_description_en : project.short_description_id }}
            </p>
            <div class="flex flex-wrap gap-1.5">
              <span v-for="tag in (project.tags ?? []).slice(0, 3)" :key="tag" class="tag-badge">{{ tag }}</span>
              <span v-if="(project.tags ?? []).length > 3" class="tag-badge opacity-70">+{{ (project.tags ?? []).length - 3 }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <Transition name="modal">
      <div v-if="selected" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm" @click.self="closeModal">
        <div class="bg-white dark:bg-gray-800 rounded-2xl max-w-3xl w-full max-h-[85vh] overflow-y-auto shadow-2xl">
          <!-- Image -->
          <div class="relative">
            <img :src="selected.image_url" :alt="selected.title" class="w-full h-64 object-cover rounded-t-2xl" />
            <button @click="closeModal" class="absolute top-3 right-3 w-9 h-9 flex items-center justify-center bg-black/40 hover:bg-black/60 text-white rounded-full transition-colors">
              <X class="w-5 h-5" />
            </button>
          </div>

          <div class="p-6 space-y-4">
            <!-- Meta info -->
            <div class="flex flex-wrap gap-3 text-xs text-gray-500 dark:text-gray-400">
              <span class="flex items-center gap-1"><Calendar class="w-3.5 h-3.5" /> {{ currentLang === 'en' ? selected.semester_en : selected.semester_id }}</span>
              <span class="flex items-center gap-1"><Layers class="w-3.5 h-3.5" /> {{ currentLang === 'en' ? selected.project_type_en : selected.project_type_id }}</span>
              <span class="flex items-center gap-1"><Users class="w-3.5 h-3.5" /> {{ currentLang === 'en' ? selected.team_size_en : selected.team_size_id }}</span>
            </div>

            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">{{ selected.title }}</h3>

            <!-- Tags -->
            <div class="flex flex-wrap gap-2">
              <span v-for="tag in (selected.tags ?? [])" :key="tag" class="tag-badge">{{ tag }}</span>
            </div>

            <!-- Description -->
            <p class="text-gray-600 dark:text-gray-300 text-sm leading-relaxed">
              {{ currentLang === 'en' ? selected.description_en : selected.description_id }}
            </p>

            <!-- Features -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div v-for="(f, i) in (currentLang === 'en' ? selected.features_en : selected.features_id)" :key="i" class="flex items-start gap-2">
                <CheckCircle class="w-4 h-4 text-green-500 flex-shrink-0 mt-0.5" />
                <span class="text-sm text-gray-700 dark:text-gray-300">{{ f }}</span>
              </div>
            </div>

            <!-- Links -->
            <div class="flex flex-wrap gap-3 pt-2">
              <a v-if="selected.live_url" :href="selected.live_url" target="_blank" class="btn-primary text-sm px-4 py-2 flex items-center gap-2">
                <ExternalLink class="w-4 h-4" /> {{ t('Live Demo', 'Demo Langsung') }}
              </a>
              <a v-if="selected.code_url" :href="selected.code_url" target="_blank" class="btn-secondary text-sm px-4 py-2 flex items-center gap-2">
                <Code2 class="w-4 h-4" /> {{ t('View Code', 'Lihat Kode') }}
              </a>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { X, Calendar, Layers, Users, CheckCircle, ExternalLink, Code2, Sparkles } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import useLanguage from '@/composables/useLanguage'

const { currentLang, t } = useLanguage()
const projects = ref([])
const isLoading = ref(true)
const selected = ref(null)

onMounted(async () => {
  const { data } = await supabase.from('projects').select('*').order('sort_order')
  projects.value = data ?? []
  isLoading.value = false
})

const openModal = (p) => { selected.value = p; document.body.style.overflow = 'hidden' }
const closeModal = () => { selected.value = null; document.body.style.overflow = '' }
</script>

<style scoped>
.modal-enter-active, .modal-leave-active { transition: all 0.3s cubic-bezier(0.22, 1, 0.36, 1); }
.modal-enter-from, .modal-leave-to { opacity: 0; }
.modal-enter-from > div, .modal-leave-to > div { transform: scale(0.95) translateY(20px); }
</style>
