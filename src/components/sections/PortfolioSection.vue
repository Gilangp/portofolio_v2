<template>
  <section id="portfolio" class="py-14 px-4 sm:px-6 lg:px-8 bg-gray-100 text-gray-900 dark:bg-gradient-to-br dark:from-gray-900 dark:via-gray-850 dark:to-gray-800 dark:text-white transition-colors duration-700 relative overflow-hidden">
    <!-- Background orbs -->
    <div class="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-0">
      <div 
        class="absolute top-1/4 left-1/5 w-32 h-32 rounded-full bg-gradient-to-r from-blue-600/10 to-purple-600/10 blur-xl animate-float-slow opacity-70 transition-transform duration-300"
        :style="{ transform: `translate(${parallaxX * 0.35}px, ${parallaxY * 0.28}px)` }"
      ></div>
      <div 
        class="absolute bottom-1/3 right-1/4 w-40 h-40 rounded-full bg-gradient-to-br from-indigo-600/10 to-pink-600/10 blur-xl animate-float-slower opacity-70 transition-transform duration-300"
        :style="{ transform: `translate(${-parallaxX * 0.55}px, ${parallaxY * 0.38}px)` }"
      ></div>
    </div>

    <div class="h-8"></div>

    <div class="max-w-7xl mx-auto relative z-10">
      <div class="text-center mb-12 animate-fade-in">
        <h2 class="text-3xl md:text-4xl font-bold mb-4">
          <div class="inline-flex flex-col items-center">
            <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 dark:from-blue-400 dark:via-purple-400 dark:to-pink-400">
              {{ currentLang === 'en' ? "My Projects" : "Proyek Saya" }}
            </span>
            <span class="w-16 h-1 bg-gradient-to-r from-blue-400 to-purple-500 rounded-full mt-2 animate-underline"></span>
          </div>
        </h2>
        <p class="text-lg text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
          {{ currentLang === 'en' ? "Here are some of my recent works. Click to see details." : "Berikut adalah beberapa karya terbaru saya. Klik untuk melihat detail." }}
        </p>
      </div>

      <!-- Skeleton when loading -->
      <div v-if="isLoading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="i in 3" :key="i" class="skeleton h-72 rounded-xl" />
      </div>

      <div v-else-if="!projects.length" class="text-center py-12 text-gray-400 text-sm">
        {{ t('No projects found.', 'Belum ada proyek yang ditampilkan.') }}
      </div>

      <!-- Projects slider -->
      <div v-else class="relative group animate-fade-in" style="animation-delay: 0.2s">
        <div class="absolute inset-y-0 left-0 z-10 flex items-center">
          <button @click="prevSlide" class="p-2 rounded-full bg-white/90 dark:bg-gray-800/90 shadow-md hover:bg-white dark:hover:bg-gray-700 transition-transform group-hover:translate-x-2 backdrop-blur-sm border border-gray-200/50 dark:border-gray-700/50">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-800 dark:text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
        </div>

        <div class="overflow-hidden">
          <div ref="slider" class="projects-slider-track flex gap-6 transition-transform duration-300 ease-in-out">
            <div 
              v-for="(project, index) in projects" 
              :key="project.id || index"
              class="flex-shrink-0 w-full sm:w-1/2 lg:w-1/3 px-2 transition-all duration-300 transform hover:scale-105"
            >
              <div 
                class="bg-white/90 dark:bg-gray-800/90 rounded-xl shadow-md overflow-hidden border border-gray-200/50 dark:border-gray-700/50 cursor-pointer h-full flex flex-col backdrop-blur-sm transition-all duration-300 hover:shadow-lg"
                @click="openModal(project)"
              >
                <div class="relative overflow-hidden h-48 group/img">
                  <img :src="project.image_url" :alt="project.title" class="w-full h-full object-cover transition-transform duration-500 group-hover/img:scale-110" loading="lazy">
                  <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent flex items-end p-4">
                    <h3 class="text-xl font-bold text-white">{{ project.title }}</h3>
                  </div>
                </div>
                <div class="p-4 flex-grow flex flex-col justify-between">
                  <p class="text-gray-600 dark:text-gray-300 mb-3 text-sm line-clamp-2">
                    {{ currentLang === 'en' ? project.short_description_en : project.short_description_id }}
                  </p>
                  <div class="flex flex-wrap gap-2 mt-auto">
                    <span v-for="(tag, i) in (project.tags ?? []).slice(0, 3)" :key="i" class="px-2 py-1 bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 text-xs font-medium rounded-full">
                      {{ tag }}
                    </span>
                    <span v-if="(project.tags ?? []).length > 3" class="px-2 py-1 bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 text-xs font-medium rounded-full">
                      +{{ (project.tags ?? []).length - 3 }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="absolute inset-y-0 right-0 z-10 flex items-center">
          <button @click="nextSlide" class="p-2 rounded-full bg-white/90 dark:bg-gray-800/90 shadow-md hover:bg-white dark:hover:bg-gray-700 transition-transform group-hover:-translate-x-2 backdrop-blur-sm border border-gray-200/50 dark:border-gray-700/50">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-800 dark:text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </div>

      <!-- Project detail modal -->
      <div v-if="selectedProject" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4 pt-8">
        <div class="bg-white dark:bg-gray-800 rounded-xl max-w-4xl w-full max-h-[80vh] overflow-y-auto shadow-2xl mt-16" @click.self="closeModal">
          <div class="relative">
            <button @click="closeModal" class="absolute top-4 right-4 p-2 rounded-full bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 z-10">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
            
            <div class="relative cursor-zoom-in" @click.stop="openImagePreview(selectedProject.image_url)" @mouseenter="isImageHovered = true" @mouseleave="isImageHovered = false">
              <img :src="selectedProject.image_url" :alt="selectedProject.title" class="w-full h-64 object-cover rounded-t-xl">
              <div class="absolute inset-0 transition-all duration-300 flex items-center justify-center" :style="isImageHovered ? 'background-color: rgba(0, 0, 0, 0.3)' : 'background-color: rgba(0, 0, 0, 0)'">
                <div class="transition-opacity duration-300 bg-white bg-opacity-80 rounded-full p-3" :style="isImageHovered ? 'opacity: 1' : 'opacity: 0'">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-gray-800" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3-3H7" />
                  </svg>
                </div>
              </div>
              <div class="absolute bottom-4 right-4 bg-black bg-opacity-50 text-white px-2 py-1 rounded text-sm">
                {{ currentLang === 'en' ? "Click to enlarge" : "Klik untuk memperbesar" }}
              </div>
            </div>
            
            <div class="p-6">
              <div class="flex flex-wrap items-center gap-3 mb-4 text-sm text-gray-600 dark:text-gray-400">
                <div class="flex items-center gap-1">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  <span>{{ currentLang === 'en' ? selectedProject.semester_en : selectedProject.semester_id }}</span>
                </div>
                <div class="flex items-center gap-1">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012-2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01" />
                  </svg>
                  <span>{{ currentLang === 'en' ? selectedProject.project_type_en : selectedProject.project_type_id }}</span>
                </div>
                <div class="flex items-center gap-1">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3a6 6 0 016-6h6a6 6 0 016 6h-4m-1-4h.01M9 21h6" />
                  </svg>
                  <span>{{ currentLang === 'en' ? selectedProject.team_size_en : selectedProject.team_size_id }}</span>
                </div>
              </div>
              
              <h3 class="text-2xl font-bold text-gray-800 dark:text-white mb-2">{{ selectedProject.title }}</h3>
              <div class="flex flex-wrap gap-2 mb-4">
                <span v-for="(tag, i) in (selectedProject.tags ?? [])" :key="i" class="px-3 py-1 bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 text-xs font-medium rounded-full">
                  {{ tag }}
                </span>
              </div>
              <p class="text-gray-600 dark:text-gray-300 mb-6 text-sm leading-relaxed">
                {{ currentLang === 'en' ? selectedProject.description_en : selectedProject.description_id }}
              </p>
              
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div v-for="(feature, i) in (currentLang === 'en' ? selectedProject.features_en : selectedProject.features_id)" :key="i" class="flex items-start gap-3">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-500 mt-0.5 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <p class="text-sm text-gray-700 dark:text-gray-200">{{ feature }}</p>
                </div>
              </div>
              
              <div class="flex flex-wrap gap-3">
                <a v-if="selectedProject.live_url" :href="selectedProject.live_url" target="_blank" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg flex items-center gap-2 text-sm transition-all duration-300 transform hover:scale-105">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                  </svg>
                  {{ currentLang === 'en' ? "Live Demo" : "Demo Langsung" }}
                </a>
                <a v-if="selectedProject.code_url" :href="selectedProject.code_url" target="_blank" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-800 dark:text-white rounded-lg flex items-center gap-2 text-sm transition-all duration-300 transform hover:scale-105">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                  </svg>
                  {{ currentLang === 'en' ? "View Code" : "Lihat Kode" }}
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Image Preview Modal -->
      <div v-if="previewImage" class="fixed inset-0 z-[60] flex items-center justify-center bg-black bg-opacity-90 p-4 pt-20" @click.self="closeImagePreview">
        <div class="relative max-w-6xl max-h-full w-full h-full flex items-center justify-center">
          <button @click="closeImagePreview" class="absolute top-4 right-4 p-3 rounded-full bg-white bg-opacity-20 hover:bg-opacity-30 text-white z-10">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
          
          <div class="relative w-full h-full flex items-center justify-center" @click.stop>
            <img :src="previewImage" alt="Preview" class="max-w-full max-h-full object-contain rounded-lg cursor-zoom-out" @click="closeImagePreview">
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import useLanguage from '@/composables/useLanguage'
import { useParallax } from '@/composables/useParallax'

const { currentLang, t } = useLanguage()
const { parallaxY, parallaxX } = useParallax()

const slider = ref(null)
const projects = ref([])
const isLoading = ref(true)
const selectedProject = ref(null)
const previewImage = ref(null)
const isImageHovered = ref(false)

onMounted(async () => {
  const { data } = await supabase.from('projects').select('*').or('is_visible.is.null,is_visible.eq.true').order('sort_order')
  projects.value = (data ?? []).filter(p => p.is_visible !== false)
  isLoading.value = false
})

const nextSlide = () => {
  const sliderElement = slider.value
  if (sliderElement) {
    const firstItem = sliderElement.firstElementChild
    if (firstItem) {
      const itemWidth = firstItem.offsetWidth + 24
      sliderElement.scrollBy({ left: itemWidth, behavior: 'smooth' })
    }
  }
}

const prevSlide = () => {
  const sliderElement = slider.value
  if (sliderElement) {
    const firstItem = sliderElement.firstElementChild
    if (firstItem) {
      const itemWidth = firstItem.offsetWidth + 24
      sliderElement.scrollBy({ left: -itemWidth, behavior: 'smooth' })
    }
  }
}

const openModal = (project) => {
  selectedProject.value = project
  document.body.style.overflow = 'hidden'
}

const closeModal = () => {
  selectedProject.value = null
  document.body.style.overflow = 'auto'
}

const openImagePreview = (imageUrl) => {
  if (imageUrl) {
    previewImage.value = imageUrl
    document.body.style.overflow = 'hidden'
  }
}

const closeImagePreview = () => {
  previewImage.value = null
  if (!selectedProject.value) {
    document.body.style.overflow = 'auto'
  }
}
</script>

<style scoped>
.projects-slider-track {
  overflow-x: auto;
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

.projects-slider-track::-webkit-scrollbar {
  display: none;
}
</style>
