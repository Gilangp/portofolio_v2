<template>
  <footer class="bg-white/60 dark:bg-[#060913]/60 backdrop-blur-md border-t border-gray-200/60 dark:border-cyan-500/15 py-6 text-center text-xs text-gray-400 dark:text-gray-500 transition-colors duration-500 relative overflow-hidden">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
      <p>
        © {{ year }} {{ settings?.name || 'Gilang Purnomo' }}. 
        {{ currentLang === 'en' 
          ? (settings?.footer_copyright_en || t('All rights reserved.', 'Hak cipta dilindungi.')) 
          : (settings?.footer_copyright_id || t('All rights reserved.', 'Hak cipta dilindungi.')) 
        }}
      </p>
    </div>
  </footer>
</template>

<script setup>
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'

const { t, currentLang } = useLanguage()
const { settings } = useSiteSettings()
const year = new Date().getFullYear()
</script>
