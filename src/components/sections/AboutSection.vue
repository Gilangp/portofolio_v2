<template>
  <section id="about" class="min-h-[60vh] bg-gray-100 text-gray-900 dark:bg-gradient-to-br dark:from-gray-900 dark:via-gray-850 dark:to-gray-800 dark:text-white transition-colors duration-700 relative overflow-hidden py-8 md:py-12">
    <!-- Background elements -->
    <div class="absolute top-0 right-0 w-72 h-72 bg-blue-500/5 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute bottom-0 left-0 w-80 h-80 bg-purple-500/5 rounded-full blur-3xl pointer-events-none"></div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
      <h2 class="text-3xl md:text-4xl font-bold text-center mb-8 md:mb-12 animate-fade-in">
        <span class="relative inline-block">
          <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 dark:from-blue-400 dark:via-purple-400 dark:to-pink-400">
            {{ t('About Me', 'Tentang Saya') }}
          </span>
          <span class="absolute -bottom-1 left-0 w-full h-1 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full animate-underline"></span>
        </span>
      </h2>

      <div class="flex flex-col lg:flex-row items-center gap-6 md:gap-8">
        <!-- Photo -->
        <div class="w-full lg:w-2/5 order-1 flex justify-center">
          <div class="relative flex justify-center mx-auto -mt-4 lg:mt-0">
            <div class="overflow-hidden rounded-xl border-4 border-blue-400/50 hover:border-purple-300 transition-all duration-500 shadow-lg hover:shadow-xl hover:shadow-purple-500/20 group transform hover:-translate-y-1">
              <img
                :src="settings?.about_photo_url ?? settings?.profile_photo_url ?? 'https://ui-avatars.com/api/?name=Gilang+Purnomo&size=400&background=3b82f6&color=fff&bold=true'"
                alt="Gilang Purnomo"
                class="h-[360px] w-[300px] object-cover object-top transition-transform duration-500 group-hover:scale-105"
                loading="lazy"
              />
              <div class="absolute inset-0 bg-gradient-to-br from-blue-500/0 via-purple-600/10 to-blue-700/10 group-hover:via-purple-600/20 transition-all duration-300 rounded-xl"></div>
            </div>
          </div>
        </div>

        <!-- Content -->
        <div class="w-full lg:w-3/5 order-2 space-y-4 md:space-y-6 text-left pl-0 lg:-ml-6 xl:-ml-12">
          <div v-if="settings" class="space-y-4 animate-fade-in" style="animation-delay: 0.2s">
            <p class="text-sm md:text-base text-gray-700 dark:text-gray-300 leading-relaxed">
              <span class="text-blue-600 dark:text-blue-400 font-semibold">
                {{ currentLang === 'en' ? settings.about_title_en : settings.about_title_id }}
              </span>
              {{ currentLang === 'en' ? settings.about_bio_en : settings.about_bio_id }}
            </p>
            <p class="text-sm md:text-base text-gray-600 dark:text-gray-400 leading-relaxed">
              {{ currentLang === 'en' ? settings.about_specialty_en : settings.about_specialty_id }}
            </p>
          </div>

          <!-- Skeleton -->
          <div v-else class="space-y-4">
            <div class="skeleton h-4 w-full" />
            <div class="skeleton h-4 w-5/6" />
            <div class="skeleton h-4 w-4/5" />
          </div>

          <!-- Focus Cards - from about_cards table -->
          <div v-if="!cardsLoading" class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2 animate-fade-in" style="animation-delay: 0.4s">
            <div
              v-for="card in cards"
              :key="card.id"
              class="bg-white/90 dark:bg-gray-800/90 p-4 rounded-xl shadow-md hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1 backdrop-blur-sm border border-gray-100/30 dark:border-gray-700/30"
            >
              <div class="flex items-start gap-3">
                <div class="p-2 bg-blue-100/80 dark:bg-blue-900/30 rounded-lg text-blue-600 dark:text-blue-400 flex-shrink-0">
                  <DynamicIcon :name="card.icon_type" class-name="w-5 h-5" />
                </div>
                <div>
                  <h3 class="font-semibold text-gray-800 dark:text-white text-base mb-1">
                    {{ currentLang === 'en' ? card.title_en : card.title_id }}
                  </h3>
                  <p class="text-xs text-gray-600 dark:text-gray-300 leading-relaxed">
                    {{ currentLang === 'en' ? card.description_en : card.description_id }}
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
            <div v-for="i in 4" :key="i" class="skeleton h-24 rounded-xl" />
          </div>

          <!-- CV Download -->
          <div class="pt-2 animate-fade-in" style="animation-delay: 0.6s">
            <a
              v-if="settings?.cv_url"
              :href="settings.cv_url"
              download
              class="inline-flex items-center gap-2 border-2 border-blue-500 dark:border-blue-400 text-blue-600 dark:text-blue-400 hover:text-white dark:hover:text-white px-4 py-2 md:px-5 md:py-2 rounded-full text-sm font-medium transition-all duration-300 transform hover:scale-[1.03] hover:bg-blue-500 dark:hover:bg-blue-400 group"
            >
              <Download class="w-4 h-4 transition-transform duration-300 group-hover:translate-x-1" />
              {{ t('Download CV', 'Unduh CV') }}
            </a>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Download } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'
import DynamicIcon from '@/components/common/DynamicIcon.vue'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()

const cards = ref([])
const cardsLoading = ref(true)

onMounted(async () => {
  const { data } = await supabase.from('about_cards').select('*').order('sort_order')
  cards.value = data ?? []
  cardsLoading.value = false
})
</script>
