<template>
  <header
    class="fixed top-0 left-0 right-0 z-50 transition-all duration-500"
    :class="scrolled
      ? 'bg-white/85 dark:bg-[#060913]/85 backdrop-blur-xl shadow-[0_10px_30px_-10px_rgba(0,0,0,0.1)] dark:shadow-[0_10px_30px_-10px_rgba(0,0,0,0.7)] border-b border-blue-100/80 dark:border-cyan-500/20 py-3'
      : 'bg-transparent py-5'"
  >
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between">
      <!-- Dynamic Logo -->
      <a href="#home" @click.prevent="scrollTo('home')" class="flex items-center gap-2.5 hover:opacity-85 transition-opacity">
        <img v-if="settings?.site_logo_url" :src="settings.site_logo_url" :alt="settings?.site_logo_text || 'Logo'" class="h-9 w-auto max-w-[140px] object-contain" />
        <span v-else class="text-2xl font-black tracking-tight flex items-center">
          <span class="text-blue-600 dark:text-cyan-400 drop-shadow-[0_0_12px_rgba(0,216,255,0.45)]">{{ (settings?.site_logo_text || 'Gilangprnm').charAt(0) }}</span>
          <span class="text-gray-900 dark:text-white">{{ (settings?.site_logo_text || 'Gilangprnm').slice(1) }}</span>
        </span>
      </a>

      <!-- Right Group: Desktop Nav + Controls -->
      <div class="flex items-center gap-6 lg:gap-8 ml-auto">
        <!-- Desktop Nav -->
        <nav class="hidden md:flex items-center gap-6 lg:gap-8">
          <a
            v-for="item in navItems"
            :key="item.id"
            :href="`#${item.id}`"
            @click.prevent="scrollTo(item.id)"
            class="text-sm font-medium pb-1 border-b-2 transition-all duration-200"
            :class="activeSection === item.id
              ? 'text-blue-600 dark:text-cyan-400 font-bold border-blue-600 dark:border-cyan-400'
              : 'text-gray-600 dark:text-gray-300 border-transparent hover:text-blue-600 dark:hover:text-cyan-400 hover:border-blue-300 dark:hover:border-cyan-400/50'"
          >
            {{ item.label }}
          </a>
        </nav>

        <!-- Controls -->
        <div class="flex items-center gap-3">
          <!-- Dark mode toggle -->
          <button
            @click="toggleDark"
            class="w-9 h-9 flex items-center justify-center rounded-full border transition-all duration-200 hover:scale-105 border-blue-500/50 dark:border-cyan-400/60 text-blue-600 dark:text-cyan-400 hover:bg-blue-500/10 dark:hover:bg-cyan-400/10"
            :title="isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'"
          >
            <Sun v-if="isDark" class="w-4 h-4" />
            <Moon v-else class="w-4 h-4" />
          </button>

          <!-- Language toggle -->
          <button
            @click="toggleLanguage"
            class="px-3.5 py-1.5 text-xs font-bold rounded-full border transition-all duration-200 hover:scale-105 border-blue-500/50 dark:border-cyan-400/60 text-blue-600 dark:text-cyan-400 hover:bg-blue-500/10 dark:hover:bg-cyan-400/10"
          >
            {{ currentLang === 'en' ? 'EN / ID' : 'ID / EN' }}
          </button>

          <!-- Hamburger -->
          <button
            @click="mobileOpen = !mobileOpen"
            class="md:hidden w-9 h-9 flex items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
          >
            <Menu v-if="!mobileOpen" class="w-5 h-5" />
            <X v-else class="w-5 h-5" />
          </button>
        </div>
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
