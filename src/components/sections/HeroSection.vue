<template>
  <section id="home" class="min-h-screen relative overflow-hidden flex items-center bg-transparent transition-colors duration-500">
    <!-- Background orbs -->
    <div class="orb top-20 left-10 w-96 h-96 bg-blue-500/15 dark:bg-cyan-500/20 animate-pulse-slow" />
    <div class="orb bottom-1/4 right-16 w-96 h-96 bg-purple-500/15 dark:bg-indigo-500/20 animate-pulse-slow" />
    <div class="orb top-1/3 right-1/4 w-72 h-72 bg-pink-500/10 dark:bg-purple-500/15" />

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

          <!-- Dynamic Social Links -->
          <div class="flex items-center justify-center lg:justify-start gap-3 flex-wrap">
            <a
              v-for="(link, idx) in (settings?.normalized_social_links || [])"
              :key="idx"
              :href="link.url"
              target="_blank"
              :aria-label="link.name || link.label"
              class="w-10 h-10 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 hover:bg-blue-600 hover:text-white transition-all duration-300 hover:scale-110 shadow group"
              :title="link.name || link.label"
            >
              <component :is="getSocialIcon(link.icon || link.name)" class="w-5 h-5 group-hover:scale-110 transition-transform" />
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
import { Github, Linkedin, Instagram, Twitter, Youtube, MessageSquare, Send, Globe, MessageCircle, Phone, Share2 } from 'lucide-vue-next'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()

// Icon resolver helper for dynamic social links
const getSocialIcon = (iconName = '') => {
  const name = iconName.toLowerCase()
  if (name.includes('github')) return Github
  if (name.includes('linkedin')) return Linkedin
  if (name.includes('instagram')) return Instagram
  if (name.includes('twitter') || name.includes('x')) return Twitter
  if (name.includes('youtube')) return Youtube
  if (name.includes('discord')) return MessageSquare
  if (name.includes('telegram')) return Send
  if (name.includes('whatsapp') || name.includes('wa')) return MessageCircle
  if (name.includes('phone') || name.includes('tel')) return Phone
  return Globe || Share2
}

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
