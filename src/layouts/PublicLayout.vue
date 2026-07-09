<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors duration-500 relative">
    <NavBar />
    <main>
      <RouterView />
    </main>
    <FooterSection />

    <!-- Back to Top / Scroll to Top Button -->
    <Transition name="fade-scale">
      <button
        v-if="showBackToTop"
        @click="scrollToTop"
        class="fixed bottom-6 right-6 z-40 w-9 h-9 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white shadow-lg shadow-indigo-500/30 dark:shadow-indigo-500/40 flex items-center justify-center transition-all duration-300 hover:scale-110 active:scale-95 group border border-white/20 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2 dark:focus:ring-offset-gray-900"
        title="Kembali ke atas"
        aria-label="Back to top"
      >
        <ArrowUp class="w-4 h-4 transition-transform duration-300 group-hover:-translate-y-0.5 stroke-[2.5]" />
      </button>
    </Transition>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { ArrowUp } from 'lucide-vue-next'
import NavBar from '@/components/layout/NavBar.vue'
import FooterSection from '@/components/layout/FooterSection.vue'

const showBackToTop = ref(false)

const handleScroll = () => {
  showBackToTop.value = window.scrollY > 300
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

onMounted(() => window.addEventListener('scroll', handleScroll))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>

<style scoped>
.fade-scale-enter-active,
.fade-scale-leave-active {
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.fade-scale-enter-from,
.fade-scale-leave-to {
  opacity: 0;
  transform: scale(0.6) translateY(12px);
}
</style>
