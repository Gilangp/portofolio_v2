<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-xl font-bold text-white">Dashboard</h2>
      <p class="text-sm text-gray-400 mt-1">Ringkasan konten portofolio Anda</p>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div v-for="stat in stats" :key="stat.label" class="bg-gray-900 border border-gray-800 rounded-xl p-5 flex items-start gap-4">
        <div class="p-2.5 rounded-xl" :class="stat.iconBg">
          <component :is="stat.icon" class="w-5 h-5" :class="stat.iconColor" />
        </div>
        <div>
          <p class="text-2xl font-bold text-white">{{ stat.value ?? '…' }}</p>
          <p class="text-xs text-gray-400 mt-0.5">{{ stat.label }}</p>
        </div>
      </div>
    </div>

    <!-- Quick Links -->
    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
      <h3 class="text-sm font-semibold text-gray-300 mb-4">⚡ Aksi Cepat</h3>
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
        <RouterLink v-for="link in quickLinks" :key="link.to" :to="link.to"
          class="flex flex-col items-center gap-2 p-4 rounded-xl bg-gray-800 hover:bg-gray-700 border border-gray-700 hover:border-gray-600 transition-all duration-200 group">
          <component :is="link.icon" class="w-5 h-5 text-gray-400 group-hover:text-violet-400 transition-colors" />
          <span class="text-xs text-gray-400 group-hover:text-gray-200 font-medium text-center transition-colors">{{ link.label }}</span>
        </RouterLink>
      </div>
    </div>

    <!-- Info -->
    <div class="bg-gradient-to-r from-violet-900/30 to-indigo-900/30 border border-violet-800/40 rounded-xl p-5 text-sm text-violet-300">
      <p class="font-semibold mb-1">💡 Cara menggunakan Admin Panel:</p>
      <ul class="text-xs text-violet-400 space-y-1 mt-2 list-disc list-inside">
        <li>Pergi ke <strong>Pengaturan Umum</strong> untuk mengubah bio, foto, kontak, dan link sosial media.</li>
        <li>Pergi ke <strong>Proyek</strong> untuk menambah, edit, atau hapus proyek portofolio.</li>
        <li>Pergi ke <strong>Keahlian</strong> untuk mengelola daftar skill di halaman Skills.</li>
        <li>Pergi ke <strong>Kartu About</strong> untuk mengelola 4 kartu fokus di halaman About.</li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Settings, FolderKanban, Cpu, UserSquare2 } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

const stats = ref([
  { label: 'Jumlah Proyek', icon: FolderKanban, iconBg: 'bg-blue-900/40', iconColor: 'text-blue-400', value: null },
  { label: 'Keahlian (Skills)', icon: Cpu, iconBg: 'bg-purple-900/40', iconColor: 'text-purple-400', value: null },
  { label: 'Kartu About', icon: UserSquare2, iconBg: 'bg-pink-900/40', iconColor: 'text-pink-400', value: null },
  { label: 'Status Config', icon: Settings, iconBg: 'bg-green-900/40', iconColor: 'text-green-400', value: '✓ OK' },
])

const quickLinks = [
  { to: '/admin/settings', label: 'Edit Pengaturan', icon: Settings },
  { to: '/admin/projects', label: 'Kelola Proyek', icon: FolderKanban },
  { to: '/admin/skills', label: 'Kelola Skill', icon: Cpu },
  { to: '/admin/about-cards', label: 'Kelola Kartu', icon: UserSquare2 },
]

onMounted(async () => {
  const [projects, skills, cards] = await Promise.all([
    supabase.from('projects').select('id', { count: 'exact', head: true }),
    supabase.from('skills').select('id', { count: 'exact', head: true }),
    supabase.from('about_cards').select('id', { count: 'exact', head: true }),
  ])
  stats.value[0].value = projects.count ?? 0
  stats.value[1].value = skills.count ?? 0
  stats.value[2].value = cards.count ?? 0
})
</script>
