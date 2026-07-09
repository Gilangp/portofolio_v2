<template>
  <section id="about" class="py-20 px-4 sm:px-6 lg:px-8 bg-white/40 dark:bg-[#070a13]/40 backdrop-blur-sm transition-colors duration-500 relative overflow-hidden">
    <div class="orb top-1/4 left-10 w-80 h-80 bg-blue-500/10 dark:bg-cyan-500/15" />
    <div class="orb bottom-1/3 right-10 w-80 h-80 bg-purple-500/10 dark:bg-indigo-500/15" />

    <div class="max-w-6xl mx-auto relative z-10">
      <!-- High-End Cyber-Satin Luxury Header -->
      <div class="text-center mb-16 relative">
        <div class="absolute inset-x-0 -top-6 flex justify-center pointer-events-none opacity-50 dark:opacity-35">
          <div class="w-72 h-16 bg-gradient-to-r from-blue-600 via-indigo-500 to-cyan-400 blur-2xl rounded-full"></div>
        </div>
        <div class="relative inline-flex items-center gap-2.5 px-4 py-1.5 rounded-full bg-white/60 dark:bg-slate-900/60 border border-blue-500/20 dark:border-cyan-500/25 backdrop-blur-md shadow-sm mb-4 transition-all hover:border-cyan-400/50">
          <span class="w-1.5 h-1.5 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_8px_rgba(0,216,255,0.8)]"></span>
          <span class="text-xs font-bold tracking-[0.18em] text-slate-800 dark:text-slate-200 uppercase">{{ t('Discovery', 'Mengenal Lebih Dekat') }}</span>
        </div>
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 dark:text-white tracking-tight">
          {{ t('About', 'Tentang') }} <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 via-indigo-600 to-cyan-500 dark:from-cyan-400 dark:via-blue-500 dark:to-indigo-400 drop-shadow-[0_2px_12px_rgba(0,216,255,0.25)]">{{ t('Me', 'Saya') }}</span>
        </h2>
        <div class="flex items-center justify-center gap-2 mt-5">
          <span class="w-2 h-2 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_10px_rgba(0,216,255,0.8)]"></span>
          <span class="w-24 h-1 rounded-full bg-gradient-to-r from-blue-600 via-indigo-500 to-transparent dark:from-cyan-400 dark:via-blue-500 dark:to-transparent"></span>
        </div>
      </div>

      <div class="flex flex-col lg:flex-row items-start gap-10 xl:gap-16">
        <!-- Photo -->
        <div class="w-full lg:w-2/5 flex justify-center">
          <div class="relative group">
            <div class="absolute inset-0 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl blur-xl opacity-20 group-hover:opacity-30 transition-opacity duration-500 scale-95" />
            <div class="relative overflow-hidden rounded-2xl border-2 border-blue-400/40 hover:border-purple-400/60 shadow-xl transition-all duration-500">
              <img
                :src="settings?.about_photo_url ?? settings?.profile_photo_url ?? 'https://ui-avatars.com/api/?name=Gilang+Purnomo&size=400&background=3b82f6&color=fff&bold=true'"
                alt="Gilang Purnomo"
                class="h-[380px] w-[300px] object-cover object-top transition-transform duration-500 group-hover:scale-105"
                loading="lazy"
              />
            </div>
          </div>
        </div>

        <!-- Content -->
        <div class="w-full lg:w-3/5 space-y-6">
          <div v-if="settings" class="space-y-4">
            <p class="text-gray-700 dark:text-gray-300 text-base leading-relaxed">
              <span class="text-blue-600 dark:text-blue-400 font-semibold">
                {{ currentLang === 'en' ? settings.about_title_en : settings.about_title_id }}
              </span>
              {{ currentLang === 'en' ? settings.about_bio_en : settings.about_bio_id }}
            </p>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
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
          <div v-if="!cardsLoading" class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div
              v-for="card in cards"
              :key="card.id"
              class="card-base p-4 hover:shadow-lg hover:-translate-y-1"
            >
              <div class="flex items-start gap-3">
                <div class="p-2 rounded-lg" :class="iconColors[card.icon_type] ?? 'bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400'">
                  <component :is="getIcon(card.icon_type)" class="w-5 h-5" />
                </div>
                <div>
                  <h4 class="text-sm font-semibold text-gray-800 dark:text-white mb-1">
                    {{ currentLang === 'en' ? card.title_en : card.title_id }}
                  </h4>
                  <p class="text-xs text-gray-500 dark:text-gray-400 leading-relaxed">
                    {{ currentLang === 'en' ? card.description_en : card.description_id }}
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div v-for="i in 4" :key="i" class="skeleton h-24 rounded-xl" />
          </div>

          <!-- CV Download -->
          <a
            v-if="settings?.cv_url"
            :href="settings.cv_url"
            download
            class="inline-flex items-center gap-2 btn-secondary text-sm"
          >
            <Download class="w-4 h-4" />
            {{ t('Download CV', 'Unduh CV') }}
          </a>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Code2, Globe, ShieldCheck, Cpu, BrainCircuit, Download, User } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()

const cards = ref([])
const cardsLoading = ref(true)

const iconMap = { code: Code2, globe: Globe, shield: ShieldCheck, cpu: Cpu, brain: BrainCircuit }
const iconColors = {
  code: 'bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400',
  globe: 'bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400',
  shield: 'bg-purple-100 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400',
  cpu: 'bg-orange-100 dark:bg-orange-900/30 text-orange-500 dark:text-orange-400',
  brain: 'bg-pink-100 dark:bg-pink-900/30 text-pink-600 dark:text-pink-400',
}
const getIcon = (type) => iconMap[type] ?? Code2

onMounted(async () => {
  const { data } = await supabase.from('about_cards').select('*').order('sort_order')
  cards.value = data ?? []
  cardsLoading.value = false
})
</script>
