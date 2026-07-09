<template>
  <section id="home" class="min-h-screen relative overflow-hidden flex items-center bg-gray-50 dark:bg-gradient-to-br dark:from-gray-900 dark:to-gray-800 transition-colors duration-500">
    <!-- Background orbs -->
    <div class="orb top-20 left-10 w-72 h-72 bg-blue-400/10" />
    <div class="orb bottom-1/4 right-16 w-80 h-80 bg-purple-600/10" />
    <div class="orb top-1/3 right-1/4 w-48 h-48 bg-blue-500/10" />

    <div class="container mx-auto px-4 sm:px-6 lg:px-8 pt-24 pb-16 relative z-10">
      <div class="flex flex-col lg:flex-row items-center justify-between gap-12">
        <!-- Text -->
        <div class="max-w-2xl text-center lg:text-left space-y-6 animate-fade-in">
          <p class="text-lg text-gray-500 dark:text-gray-400 flex items-center justify-center lg:justify-start gap-2">
            <span class="animate-wiggle inline-block">👋</span>
            {{ settings?.hero_greeting_en && currentLang === 'en' ? settings.hero_greeting_en : settings?.hero_greeting_id ?? t("Hello, I'm", "Halo, Saya") }}
          </p>

          <h1 class="text-4xl sm:text-5xl lg:text-6xl font-black text-gradient leading-tight">
            {{ settings?.name ?? 'Gilang Purnomo' }}
          </h1>

          <h2 class="text-xl md:text-2xl lg:text-3xl text-gray-700 dark:text-gray-300 font-medium">
            <span class="typing-cursor font-bold text-blue-600 dark:text-blue-400">{{ currentTypingText }}</span>
          </h2>

          <p class="text-gray-500 dark:text-gray-400 max-w-lg text-base leading-relaxed">
            {{ currentLang === 'en' ? (settings?.hero_desc_en ?? '') : (settings?.hero_desc_id ?? '') }}
          </p>

          <!-- Social Links -->
          <div class="flex items-center justify-center lg:justify-start gap-3">
            <a v-if="settings?.social_github" :href="settings.social_github" target="_blank" aria-label="GitHub"
              class="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 hover:bg-gray-900 hover:text-white dark:hover:bg-white dark:hover:text-gray-900 transition-all duration-300 hover:scale-110 shadow">
              <Github class="w-5 h-5" />
            </a>
            <a v-if="settings?.social_linkedin" :href="settings.social_linkedin" target="_blank" aria-label="LinkedIn"
              class="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 text-blue-600 dark:text-blue-400 hover:bg-blue-600 hover:text-white transition-all duration-300 hover:scale-110 shadow">
              <Linkedin class="w-5 h-5" />
            </a>
            <a v-if="settings?.social_instagram" :href="settings.social_instagram" target="_blank" aria-label="Instagram"
              class="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 text-pink-500 dark:text-pink-400 hover:bg-gradient-to-br hover:from-pink-500 hover:to-orange-400 hover:text-white transition-all duration-300 hover:scale-110 shadow">
              <Instagram class="w-5 h-5" />
            </a>
          </div>

          <!-- CTA Buttons -->
          <div class="flex flex-wrap gap-4 justify-center lg:justify-start">
            <button @click="scrollTo('portfolio')" class="btn-primary">
              {{ t('View My Work', 'Lihat Karya Saya') }} →
            </button>
            <button @click="scrollTo('contact')" class="btn-secondary">
              {{ t('Contact Me', 'Hubungi Saya') }}
            </button>
          </div>
        </div>

        <!-- Photo -->
        <div class="relative w-64 h-64 sm:w-72 sm:h-72 lg:w-80 lg:h-80 animate-float flex-shrink-0">
          <div class="absolute inset-0 rounded-full border-4 border-transparent border-t-blue-400/70 border-r-blue-500/70 border-b-purple-500/70 border-l-purple-400/70 animate-spin-slow" />
          <div class="absolute inset-4 rounded-full border-4 border-transparent border-t-blue-300/50 border-r-blue-400/50 border-b-purple-400/50 border-l-purple-300/50 animate-spin-reverse" />
          <div class="relative w-full h-full overflow-hidden rounded-full border-4 border-blue-400/50 shadow-2xl shadow-blue-500/20 group z-10">
            <img
              :src="settings?.profile_photo_url ?? 'https://ui-avatars.com/api/?name=Gilang+Purnomo&size=320&background=3b82f6&color=fff&bold=true'"
              alt="Gilang Purnomo"
              class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
            />
            <div class="absolute inset-0 bg-gradient-to-br from-blue-500/0 via-blue-600/10 to-purple-700/10 rounded-full" />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import { Github, Linkedin, Instagram } from 'lucide-vue-next'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()

const scrollTo = (id) => {
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
}

// Typing animation
const currentTypingText = ref('')
let typingTimer = null
let currentIndex = 0
let charIndex = 0
let isDeleting = false

const roles = computed(() => {
  const r = settings.value?.hero_roles
  if (!r || !r.length) return ['Fullstack Developer', 'Network Engineer']
  return r
})

const type = () => {
  const role = roles.value[currentIndex % roles.value.length]
  if (isDeleting) {
    currentTypingText.value = role.substring(0, charIndex - 1)
    charIndex--
    if (charIndex === 0) {
      isDeleting = false
      currentIndex++
      typingTimer = setTimeout(type, 500)
    } else {
      typingTimer = setTimeout(type, 50)
    }
  } else {
    currentTypingText.value = role.substring(0, charIndex + 1)
    charIndex++
    if (charIndex === role.length) {
      typingTimer = setTimeout(() => { isDeleting = true; type() }, 2200)
    } else {
      typingTimer = setTimeout(type, 100)
    }
  }
}

onMounted(() => { typingTimer = setTimeout(type, 600) })
onBeforeUnmount(() => clearTimeout(typingTimer))
watch(currentLang, () => {
  clearTimeout(typingTimer)
  charIndex = 0; isDeleting = false; currentIndex = 0
  typingTimer = setTimeout(type, 300)
})
</script>
