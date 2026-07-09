<template>
  <div>
    <!-- Ultra-fast Global App Loader (Max 300ms) -->
    <Transition name="loader-fade">
      <div
        v-if="showLoader"
        class="fixed inset-0 z-[9999] bg-[#090d16] flex flex-col items-center justify-center select-none"
      >
        <div class="relative w-20 h-20 flex items-center justify-center mb-6">
          <div class="absolute inset-0 rounded-full border-4 border-blue-500/15 border-t-blue-500 border-r-indigo-500 animate-spin shadow-lg shadow-blue-500/20"></div>
          <img
            v-if="settings?.site_logo_url"
            :src="settings.site_logo_url"
            alt="Logo"
            class="h-9 w-9 object-contain animate-pulse"
          />
          <span v-else class="text-2xl font-black text-gradient animate-pulse">
            {{ settings?.site_logo_text || 'GP' }}
          </span>
        </div>
        <div class="flex items-center gap-2">
          <span class="w-2 h-2 rounded-full bg-blue-500 animate-ping"></span>
          <p class="text-xs font-bold tracking-[0.2em] uppercase text-slate-300">
            {{ currentLang === 'en' ? 'Loading Portfolio...' : 'Memuat Portofolio...' }}
          </p>
        </div>
      </div>
    </Transition>

    <RouterView />
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import useSiteSettings from '@/composables/useSiteSettings'
import useLanguage from '@/composables/useLanguage'

const { isLoading, settings } = useSiteSettings()
const { currentLang } = useLanguage()

const showLoader = ref(true)

onMounted(() => {
  // Ensure loader never hangs: unmount automatically after at most 300ms
  const maxTimer = setTimeout(() => {
    showLoader.value = false
  }, 300)

  // If isLoading resolves even faster than 300ms, hide immediately
  watch(isLoading, (val) => {
    if (!val) {
      clearTimeout(maxTimer)
      showLoader.value = false
    }
  }, { immediate: true })
})
</script>

<style>

.loader-fade-enter-active,
.loader-fade-leave-active {
  transition: opacity 0.4s cubic-bezier(0.16, 1, 0.3, 1), transform 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}
.loader-fade-enter-from,
.loader-fade-leave-to {
  opacity: 0;
  transform: scale(1.02);
  pointer-events: none;
}
</style>
