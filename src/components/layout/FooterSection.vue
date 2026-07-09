<template>
  <footer class="bg-white dark:bg-gray-950 border-t border-gray-200/60 dark:border-white/10 py-12 text-gray-500 dark:text-gray-400 transition-colors duration-500 relative overflow-hidden">
    <!-- Subtle glow orb -->
    <div class="absolute bottom-0 left-1/2 -translate-x-1/2 w-[500px] h-32 bg-blue-500/5 dark:bg-blue-500/10 rounded-full blur-3xl pointer-events-none"></div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8 items-center justify-between pb-8 border-b border-gray-200/40 dark:border-white/5">
        <!-- Brand & Tagline -->
        <div class="space-y-2 text-center md:text-left">
          <div class="flex items-center justify-center md:justify-start gap-2.5">
            <img v-if="settings?.site_logo_url" :src="settings.site_logo_url" class="h-8 w-auto max-w-[120px] object-contain" alt="Logo" />
            <span v-else class="text-gradient font-black text-xl tracking-tight">{{ settings?.site_logo_text || 'GP' }}</span>
            <span class="font-bold text-gray-800 dark:text-gray-200 text-base">— {{ settings?.name || 'Gilang Purnomo' }}</span>
          </div>
          <p class="text-xs sm:text-sm text-gray-500 dark:text-gray-400 max-w-sm mx-auto md:mx-0">
            {{ currentLang === 'en' 
              ? (settings?.footer_tagline_en || "Thank you for visiting my portfolio. Let's create something amazing together!") 
              : (settings?.footer_tagline_id || "Terima kasih telah mengunjungi portofolio saya. Mari berkarya bersama!") 
            }}
          </p>
        </div>

        <!-- Quick Links -->
        <div class="flex flex-wrap justify-center gap-6 text-xs sm:text-sm font-semibold text-gray-600 dark:text-gray-300">
          <a href="#hero" class="hover:text-blue-500 transition-colors">{{ t('Home', 'Beranda') }}</a>
          <a href="#about" class="hover:text-blue-500 transition-colors">{{ t('About', 'Tentang') }}</a>
          <a href="#skills" class="hover:text-blue-500 transition-colors">{{ t('Skills', 'Keahlian') }}</a>
          <a href="#portfolio" class="hover:text-blue-500 transition-colors">{{ t('Projects', 'Proyek') }}</a>
          <a href="#contact" class="hover:text-blue-500 transition-colors">{{ t('Contact', 'Kontak') }}</a>
        </div>

        <!-- Dynamic Social Icons -->
        <div class="flex items-center justify-center md:justify-end gap-3">
          <a
            v-for="(link, idx) in (settings?.normalized_social_links || [])"
            :key="idx"
            :href="link.url"
            target="_blank"
            rel="noopener noreferrer"
            class="w-10 h-10 rounded-xl bg-gray-100 dark:bg-gray-900 border border-gray-200/60 dark:border-white/10 flex items-center justify-center text-gray-600 dark:text-gray-300 hover:bg-blue-600 hover:text-white hover:border-blue-500 transition-all duration-300 shadow-sm hover:scale-110"
            :title="link.name"
          >
            <component :is="getSocialIcon(link.icon || link.name)" class="w-4 h-4" />
          </a>
        </div>
      </div>

      <!-- Copyright Row -->
      <div class="pt-6 text-center text-xs text-gray-400 dark:text-gray-500">
        <p>
          © {{ year }} {{ settings?.name || 'Gilang Purnomo' }}. 
          {{ currentLang === 'en' 
            ? (settings?.footer_copyright_en || t('All rights reserved.', 'Hak cipta dilindungi.')) 
            : (settings?.footer_copyright_id || t('All rights reserved.', 'Hak cipta dilindungi.')) 
          }}
        </p>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'
import { 
  Github, Linkedin, Instagram, Twitter, Youtube, 
  MessageCircle, Send, PhoneCall, Globe, Code2 
} from 'lucide-vue-next'

const { t, currentLang } = useLanguage()
const { settings } = useSiteSettings()
const year = new Date().getFullYear()

const iconMap = {
  github: Github,
  linkedin: Linkedin,
  instagram: Instagram,
  tiktok: MessageCircle,
  twitter: Twitter,
  youtube: Youtube,
  discord: MessageCircle,
  telegram: Send,
  whatsapp: PhoneCall,
  website: Globe
}

const getSocialIcon = (name) => {
  if (!name) return Globe
  const key = name.toLowerCase()
  return iconMap[key] || Globe
}
</script>
