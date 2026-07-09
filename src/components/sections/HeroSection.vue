<template>
  <section id="home" class="min-h-screen bg-gray-50 text-gray-900 dark:bg-gradient-to-br dark:from-gray-900 dark:to-gray-800 dark:text-white transition-colors duration-500 relative overflow-hidden flex items-center">
    <!-- Background orbs -->
    <div class="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
      <div 
        class="absolute top-20 left-10 w-32 h-32 rounded-full bg-blue-400/10 blur-3xl animate-float-slow transition-transform duration-300"
        :style="{ transform: `translate(${parallaxX * 0.5}px, ${parallaxY * 0.3}px)` }"
      ></div>
      <div 
        class="absolute bottom-1/4 right-20 w-40 h-40 rounded-full bg-blue-600/10 blur-3xl animate-float-slower transition-transform duration-300"
        :style="{ transform: `translate(${-parallaxX * 0.8}px, ${parallaxY * 0.5}px)` }"
      ></div>
      <div 
        class="absolute top-1/3 right-1/4 w-24 h-24 rounded-full bg-blue-500/10 blur-xl animate-float transition-transform duration-300"
        :style="{ transform: `translate(${parallaxX * 0.3}px, ${-parallaxY * 0.4}px)` }"
      ></div>
    </div>

    <div class="w-full max-w-[1440px] mx-auto px-4 sm:px-6 lg:px-12 xl:px-20 pt-20 pb-16 relative z-10">
      <div class="flex flex-col lg:flex-row items-center justify-between gap-8 md:gap-10 lg:gap-12 xl:gap-20">
        <div class="relative order-1 sm:mb-0 lg:order-2 w-64 h-64 sm:w-72 sm:h-72 md:w-80 md:h-80 lg:w-88 lg:h-88 xl:w-96 xl:h-96 animate-float mt-6 sm:mt-0 flex-shrink-0">
          <div class="absolute -top-4 -right-4 w-24 h-24 rounded-full bg-blue-500/10 blur-xl animate-pulse-slow -z-10"></div>
          <div class="absolute -bottom-6 -left-6 w-20 h-20 rounded-full bg-blue-600/10 blur-xl animate-pulse-slower -z-10"></div>
          
          <!-- rings -->
          <div class="absolute inset-0 rounded-full border-4 border-transparent border-t-blue-400/70 border-r-blue-400/70 border-b-blue-600/70 border-l-blue-600/70 animate-spin-slow -z-5"></div>
          <div class="absolute inset-4 rounded-full border-4 border-transparent border-t-blue-300/50 border-r-blue-300/50 border-b-blue-500/50 border-l-blue-500/50 animate-spin-reverse -z-5"></div>
          
          <!-- Photo -->
          <div class="relative w-full h-full overflow-hidden rounded-full border-4 border-blue-400/50 hover:border-blue-300 transition-all duration-500 z-10 shadow-2xl md:shadow-3xl hover:shadow-4xl hover:shadow-blue-500/40 group">
            <div class="w-full h-full overflow-hidden rounded-full">
              <img 
                v-if="settings?.hero_image_url || settings?.profile_photo_url"
                :src="settings?.hero_image_url || settings?.profile_photo_url"
                :alt="settings?.name || 'Profile'"
                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                loading="eager"
              />
              <div v-else class="w-full h-full bg-gradient-to-br from-blue-500/20 to-purple-500/20 flex items-center justify-center">
                <User class="w-24 h-24 text-blue-500/50" />
              </div>
            </div>
            <div class="absolute inset-0 bg-gradient-to-br from-blue-500/0 via-blue-600/10 to-blue-700/10 group-hover:backdrop-blur-0 transition-all duration-500 rounded-full"></div>
          </div>
        </div>

        <!-- Text Section -->
        <div class="flex-1 order-2 lg:order-1 text-center lg:text-left space-y-4 md:space-y-5 lg:pr-8 xl:pr-16 max-w-3xl">
          <h3 class="text-lg md:text-xl lg:text-2xl text-gray-600 dark:text-gray-300 animate-fade-in" style="animation-delay: 0.1s">
            <span class="inline-block animate-wiggle">👋</span> {{ settings?.hero_greeting_en && currentLang === 'en' ? settings.hero_greeting_en : (settings?.hero_greeting_id ?? (currentLang === 'en' ? "Hello, I'm" : "Halo, Saya")) }}
          </h3>
          <h1 class="text-3xl sm:text-4xl md:text-5xl lg:text-6xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 dark:from-blue-400 dark:via-blue-500 dark:to-blue-600 leading-tight md:leading-[1.2] animate-fade-in" style="animation-delay: 0.3s">
            {{ settings?.name ?? 'Gilang Purnomo' }}
          </h1>
          <h2 class="text-xl md:text-2xl lg:text-3xl text-blue-600 dark:text-blue-400 font-medium animate-fade-in" style="animation-delay: 0.5s">
            {{ currentLang === 'en' ? "Crafting digital experiences as a" : "Menciptakan karya digital sebagai" }} <br>
            <span class="font-bold text-blue-500 dark:text-blue-300 relative">
              <span class="absolute -bottom-1 left-0 w-full h-1 bg-blue-500/50 dark:bg-blue-300/40 rounded-full animate-underline"></span>
              <span class="typing-text">{{ currentTypingText }}</span>
            </span>
          </h2>

          <!-- Description -->
          <p class="text-gray-600 dark:text-gray-300 max-w-lg text-sm md:text-base leading-relaxed animate-fade-in" style="animation-delay: 0.6s">
            {{ currentLang === 'en' ? (settings?.hero_desc_en ?? "Passionate about creating impactful web experiences and building reliable network systems. Combining creativity and technical problem-solving to deliver seamless digital solutions.") : (settings?.hero_desc_id ?? "Bersemangat dalam menciptakan aplikasi web yang berdampak serta membangun sistem jaringan yang handal. Memadukan kreativitas dan pemecahan masalah teknis untuk menghadirkan solusi digital berkualitas.") }}
          </p>

          <!-- Social Links -->
          <div class="flex justify-center lg:justify-start gap-3 md:gap-4 pt-2 animate-fade-in flex-wrap" style="animation-delay: 0.7s">
            <a
              v-for="(link, idx) in (settings?.normalized_social_links || defaultSocialLinks)"
              :key="idx"
              :href="link.url"
              target="_blank"
              :aria-label="link.name || link.label"
              class="w-10 h-10 md:w-11 md:h-11 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-200 dark:hover:bg-gray-700 transition-all duration-300 hover:scale-110 shadow-sm hover:shadow-md group"
            >
              <DynamicIcon :name="link.icon || link.name || 'globe'" class-name="w-5 h-5 md:w-6 md:h-6 group-hover:scale-110 transition-transform" />
            </a>
          </div>

          <!-- Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 pt-3 justify-center lg:justify-start animate-fade-in" style="animation-delay: 0.9s">
            <button @click="handleButtonClick($event, 'portfolio')" class="ripple-button relative overflow-hidden group bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white px-6 py-2.5 md:px-8 md:py-3 rounded-full text-base md:text-lg font-medium transition-all duration-300 transform hover:scale-105 hover:shadow-lg hover:shadow-blue-500/30">
              <span class="relative z-10 flex items-center justify-center gap-2">
                {{ t('View My Work', 'Lihat Karya Saya') }}
                <span class="transition-transform duration-300 group-hover:translate-x-1">→</span>
              </span>
              <span class="absolute inset-0 bg-gradient-to-r from-blue-500 to-blue-600 opacity-0 group-hover:opacity-100 transition-opacity duration-500 rounded-full"></span>
            </button>
            
            <button @click="handleButtonClick($event, 'contact')" class="ripple-button relative overflow-hidden group border-2 border-blue-500 dark:border-blue-400 text-blue-600 dark:text-blue-400 hover:text-white dark:hover:text-white px-6 py-2.5 md:px-8 md:py-3 rounded-full text-base md:text-lg font-medium transition-all duration-300 transform hover:scale-105">
              <span class="relative z-10 flex items-center justify-center gap-2">
                {{ t('Contact Me', 'Hubungi Saya') }}
                <span class="transition-transform duration-300 group-hover:translate-x-1">→</span>
              </span>
              <span class="absolute inset-0 bg-blue-500 dark:bg-blue-400 opacity-0 group-hover:opacity-100 transition-opacity duration-500 rounded-full -z-10"></span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import { User } from 'lucide-vue-next'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'
import { useRipple } from '@/composables/useRipple'
import { useParallax } from '@/composables/useParallax'
import DynamicIcon from '@/components/common/DynamicIcon.vue'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()
const { createRipple } = useRipple()
const { parallaxY, parallaxX } = useParallax()

const defaultSocialLinks = [
  { name: 'github', url: 'https://github.com/Gilangp', icon: 'github' },
  { name: 'linkedin', url: 'https://www.linkedin.com/in/gilang-purnomo-b3863328b/', icon: 'linkedin' },
  { name: 'instagram', url: 'https://www.instagram.com/gilangprnm__/', icon: 'instagram' },
  { name: 'tiktok', url: 'https://www.tiktok.com/@gilangp__', icon: 'tiktok' }
]

const handleButtonClick = (event, sectionId) => {
  createRipple(event)
  setTimeout(() => {
    document.getElementById(sectionId)?.scrollIntoView({ behavior: 'smooth' })
  }, 200)
}

// Typing animation
const currentTypingText = ref('')
let typingTimer = null
let currentIndex = 0
let charIndex = 0
let isDeleting = false

const roles = computed(() => {
  const r = settings.value?.hero_roles
  if (!r || !r.length) {
    return currentLang.value === 'en'
      ? ['Fullstack Developer', 'Network Engineer']
      : ['Pengembang Fullstack', 'Teknisi Jaringan']
  }
  return r
})

const type = () => {
  const role = roles.value[currentIndex % roles.value.length]
  if (!role) return

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
      typingTimer = setTimeout(() => { isDeleting = true; type() }, 2000)
    } else {
      typingTimer = setTimeout(type, 100)
    }
  }
}

onMounted(() => {
  typingTimer = setTimeout(type, 600)
})

onBeforeUnmount(() => {
  clearTimeout(typingTimer)
})

watch([currentLang, roles], () => {
  clearTimeout(typingTimer)
  charIndex = 0
  isDeleting = false
  currentIndex = 0
  typingTimer = setTimeout(type, 300)
})
</script>

<style scoped>
h1 {
  line-height: 1.3;
}

.typing-text {
  display: inline-block;
  min-width: 10px;
}
</style>
