<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors duration-500">
    <NavBar />
    <main>
      <RouterView />
    </main>
    <FooterSection />
  </div>
</template>

<script setup>
import NavBar from '@/components/layout/NavBar.vue'
import FooterSection from '@/components/layout/FooterSection.vue'
</script>
