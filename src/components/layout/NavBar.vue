<template>
  <header
    class="fixed top-0 left-0 right-0 z-50 transition-all duration-500"
    :class="scrolled
      ? 'bg-white/80 dark:bg-gray-900/80 backdrop-blur-md shadow-lg border-b border-gray-200/50 dark:border-gray-700/50 py-3'
      : 'bg-transparent py-5'"
  >
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between">
      <!-- Dynamic Logo -->
      <a href="#home" @click.prevent="scrollTo('home')" class="flex items-center gap-2.5 hover:opacity-85 transition-opacity">
        <img v-if="settings?.site_logo_url" :src="settings.site_logo_url" :alt="settings?.site_logo_text || 'Logo'" class="h-9 w-auto max-w-[140px] object-contain" />
        <span v-else class="text-2xl font-black text-gradient">
          {{ settings?.site_logo_text || 'GP' }}
        </span>
      </a>

      <!-- Desktop Nav -->
      <nav class="hidden md:flex items-center gap-1">
        <a
          v-for="item in navItems"
          :key="item.id"
          :href="`#${item.id}`"
          @click.prevent="scrollTo(item.id)"
          class="px-4 py-2 text-sm font-medium rounded-lg transition-all duration-200"
          :class="activeSection === item.id
            ? 'text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/20'
            : 'text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800'"
        >
          {{ item.label }}
        </a>
      </nav>

      <!-- Controls -->
      <div class="flex items-center gap-2">
        <!-- Language toggle -->
        <button
          @click="toggleLanguage"
          class="px-3 py-1.5 text-xs font-semibold rounded-lg border transition-all duration-200 hover:scale-105"
          :class="scrolled
            ? 'border-gray-300 dark:border-gray-600 text-gray-600 dark:text-gray-300 hover:border-blue-400 hover:text-blue-500'
            : 'border-gray-400/50 dark:border-gray-500/50 text-gray-700 dark:text-gray-300'"
        >
          {{ currentLang === 'en' ? '🇮🇩 ID' : '🇬🇧 EN' }}
        </button>

        <!-- Dark mode toggle -->
        <button
          @click="toggleDark"
          class="w-9 h-9 flex items-center justify-center rounded-lg transition-all duration-200 hover:scale-105"
          :class="scrolled
            ? 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700'
            : 'bg-white/20 dark:bg-gray-800/40 text-gray-700 dark:text-gray-300'"
        >
          <Sun v-if="isDark" class="w-4 h-4" />
          <Moon v-else class="w-4 h-4" />
        </button>

        <!-- Hamburger -->
        <button
          @click="mobileOpen = !mobileOpen"
          class="md:hidden w-9 h-9 flex items-center justify-center rounded-lg bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300"
        >
          <Menu v-if="!mobileOpen" class="w-5 h-5" />
          <X v-else class="w-5 h-5" />
        </button>
      </div>
    </div>

    <!-- Mobile menu -->
    <Transition name="slide-down">
      <div v-if="mobileOpen" class="md:hidden bg-white/95 dark:bg-gray-900/95 backdrop-blur-md border-t border-gray-200/50 dark:border-gray-700/50 px-4 py-3 space-y-1">
        <a
          v-for="item in navItems"
          :key="item.id"
          :href="`#${item.id}`"
          @click.prevent="scrollTo(item.id); mobileOpen = false"
          class="block px-4 py-2.5 text-sm font-medium rounded-lg text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-900/20 transition-all duration-200"
        >
          {{ item.label }}
        </a>
      </div>
    </Transition>
  </header>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { Sun, Moon, Menu, X } from 'lucide-vue-next'
import useLanguage from '@/composables/useLanguage'
import useDarkMode from '@/composables/useDarkMode'
import useSiteSettings from '@/composables/useSiteSettings'

const { currentLang, toggleLanguage, t } = useLanguage()
const { isDark, toggle: toggleDark } = useDarkMode()
const { settings } = useSiteSettings()

const scrolled = ref(false)
const mobileOpen = ref(false)
const activeSection = ref('home')

const navItems = computed(() => [
  { id: 'home',      label: t('Home', 'Beranda') },
  { id: 'about',     label: t('About', 'Tentang') },
  { id: 'skills',    label: t('Skills', 'Keahlian') },
  { id: 'portfolio', label: t('Projects', 'Proyek') },
  { id: 'contact',   label: t('Contact', 'Kontak') },
])

const scrollTo = (id) => {
  const el = document.getElementById(id)
  if (el) el.scrollIntoView({ behavior: 'smooth' })
}

const handleScroll = () => {
  scrolled.value = window.scrollY > 20

  const sections = ['home', 'about', 'skills', 'portfolio', 'contact']
  for (const id of sections.reverse()) {
    const el = document.getElementById(id)
    if (el && window.scrollY >= el.offsetTop - 100) {
      activeSection.value = id
      break
    }
  }
}

onMounted(() => window.addEventListener('scroll', handleScroll))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>

<style scoped>
.slide-down-enter-active,
.slide-down-leave-active {
  transition: all 0.3s cubic-bezier(0.22, 1, 0.36, 1);
}
.slide-down-enter-from,
.slide-down-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
