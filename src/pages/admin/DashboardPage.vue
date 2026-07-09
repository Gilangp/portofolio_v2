<template>
  <div class="space-y-8">
    <div>
      <h2 class="text-xl font-bold text-slate-100">Selamat Datang di Admin Portal</h2>
      <p class="text-sm text-slate-400 mt-1">Pantau dan kelola seluruh konten aktif di website portofolio Anda</p>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div v-for="stat in stats" :key="stat.label" class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-5 flex items-center gap-4 shadow-sm hover:border-slate-700/80 transition-colors">
        <div class="p-3 rounded-xl" :class="stat.iconBg">
          <component :is="stat.icon" class="w-5 h-5" :class="stat.iconColor" />
        </div>
        <div>
          <p class="text-2xl font-bold text-slate-100">{{ stat.value ?? '…' }}</p>
          <p class="text-xs text-slate-400 mt-0.5 font-medium">{{ stat.label }}</p>
        </div>
      </div>
    </div>

    <!-- Quick Links -->
    <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 shadow-sm">
      <h3 class="text-sm font-semibold text-slate-200 mb-4 flex items-center gap-2">
        <Zap class="w-4 h-4 text-blue-400" />
        Aksi Cepat
      </h3>
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3.5">
        <RouterLink v-for="link in quickLinks" :key="link.to" :to="link.to"
          class="flex flex-col items-center justify-center gap-2.5 p-4 rounded-xl bg-slate-800/40 hover:bg-slate-800 border border-slate-800 hover:border-slate-700 transition-all duration-200 group">
          <div class="p-2.5 rounded-lg bg-slate-800 group-hover:bg-blue-600/10 transition-colors">
            <component :is="link.icon" class="w-5 h-5 text-slate-400 group-hover:text-blue-400 transition-colors" />
          </div>
          <span class="text-xs text-slate-300 group-hover:text-slate-100 font-medium text-center transition-colors">{{ link.label }}</span>
        </RouterLink>
      </div>
    </div>

    <!-- Info Banner -->
    <div class="bg-gradient-to-r from-blue-950/40 via-slate-900/60 to-indigo-950/40 border border-blue-900/30 rounded-2xl p-5 text-sm text-slate-300 flex items-start gap-3.5">
      <div class="p-2 rounded-lg bg-blue-500/10 text-blue-400 mt-0.5 flex-shrink-0">
        <Lightbulb class="w-4 h-4" />
      </div>
      <div>
        <p class="font-semibold text-slate-200 mb-1">Panduan Pengelolaan Konten:</p>
        <ul class="text-xs text-slate-400 space-y-1.5 mt-2 list-disc list-inside leading-relaxed">
          <li>Menu <strong class="text-slate-300">Pengaturan Umum</strong> untuk mengubah bio, foto hero/about, kontak email, dan link sosial media.</li>
          <li>Menu <strong class="text-slate-300">Proyek</strong> untuk menambah, mengedit, atau menghapus proyek portofolio beserta fiturnya.</li>
          <li>Menu <strong class="text-slate-300">Keahlian</strong> untuk menambah logo tool dan bahasa pemrograman yang Anda kuasai.</li>
          <li>Menu <strong class="text-slate-300">Kartu About</strong> untuk memodifikasi 4 kartu keahlian utama di section About Me.</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Settings, FolderKanban, Cpu, UserSquare2, Zap, Lightbulb } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

const stats = ref([
  { label: 'Proyek Portofolio', icon: FolderKanban, iconBg: 'bg-blue-500/10', iconColor: 'text-blue-400', value: null },
  { label: 'Keahlian (Skills)', icon: Cpu, iconBg: 'bg-purple-500/10', iconColor: 'text-purple-400', value: null },
  { label: 'Kartu Fokus', icon: UserSquare2, iconBg: 'bg-pink-500/10', iconColor: 'text-pink-400', value: null },
  { label: 'Status Sistem', icon: Settings, iconBg: 'bg-emerald-500/10', iconColor: 'text-emerald-400', value: 'Aktif' },
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
