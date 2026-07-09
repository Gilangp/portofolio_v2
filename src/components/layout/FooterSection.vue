<template>
  <footer class="bg-white dark:bg-gray-900 border-t border-gray-200/40 dark:border-white/10 py-6 text-center text-sm text-gray-500 dark:text-gray-400 transition-colors duration-500">
    <div class="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-2">
      <p class="font-medium">
        <span class="text-gradient font-bold">GP</span> — Gilang Purnomo
      </p>
      <p>© {{ year }} {{ t('All rights reserved.', 'Hak cipta dilindungi.') }}</p>
      <p class="text-xs">
        {{ t('Built with', 'Dibangun dengan') }}
        <span class="text-blue-500 font-medium">Vue.js</span> +
        <span class="text-emerald-500 font-medium">Supabase</span>
      </p>
    </div>
  </footer>
</template>

<script setup>
import useLanguage from '@/composables/useLanguage'

const { t } = useLanguage()
const year = new Date().getFullYear()
</script>
