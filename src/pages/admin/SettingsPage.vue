<template>
  <div class="space-y-6 max-w-4xl">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-white">Pengaturan Umum</h2>
        <p class="text-sm text-gray-400 mt-1">Kontrol semua informasi dasar portofolio Anda</p>
      </div>
      <button @click="save" :disabled="isSaving" class="btn-admin">
        <Loader2 v-if="isSaving" class="w-4 h-4 animate-spin" />
        <Save v-else class="w-4 h-4" />
        {{ isSaving ? 'Menyimpan...' : 'Simpan Semua' }}
      </button>
    </div>

    <!-- Toast -->
    <Transition name="toast">
      <div v-if="toast.show" class="fixed top-4 right-4 z-50 px-5 py-3 rounded-xl shadow-2xl text-white text-sm font-medium flex items-center gap-2"
           :class="toast.type === 'success' ? 'bg-green-600' : 'bg-red-600'">
        {{ toast.message }}
      </div>
    </Transition>

    <div v-if="isLoading" class="space-y-4">
      <div v-for="i in 8" :key="i" class="skeleton h-12 rounded-xl" />
    </div>

    <template v-else>
      <!-- Photo Section -->
      <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 space-y-4">
        <h3 class="text-sm font-semibold text-gray-300 flex items-center gap-2"><ImageIcon class="w-4 h-4 text-violet-400" /> Foto Profil</h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">URL Foto Hero (halaman Home)</label>
            <input v-model="form.profile_photo_url" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://..." />
            <img v-if="form.profile_photo_url" :src="form.profile_photo_url" class="mt-2 w-16 h-16 rounded-full object-cover border border-gray-700" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">URL Foto About (halaman About)</label>
            <input v-model="form.about_photo_url" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://..." />
            <img v-if="form.about_photo_url" :src="form.about_photo_url" class="mt-2 w-16 h-16 rounded-xl object-cover border border-gray-700" />
          </div>
        </div>
      </div>

      <!-- Hero Section -->
      <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 space-y-4">
        <h3 class="text-sm font-semibold text-gray-300 flex items-center gap-2"><Home class="w-4 h-4 text-violet-400" /> Hero / Home Section</h3>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Nama</label>
            <input v-model="form.name" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Link Download CV</label>
            <input v-model="form.cv_url" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://..." />
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Salam (EN)</label>
            <input v-model="form.hero_greeting_en" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Salam (ID)</label>
            <input v-model="form.hero_greeting_id" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
        </div>
        <div>
          <label class="block text-xs text-gray-400 mb-1.5">Teks Typing Animation (pisahkan dengan koma)</label>
          <input :value="rolesText" @input="rolesText = $event.target.value" type="text" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="Fullstack Developer, Network Engineer" />
          <p class="text-xs text-gray-500 mt-1">Contoh: <code class="text-violet-400">Fullstack Developer, Network Engineer</code></p>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Deskripsi Hero (EN)</label>
            <textarea v-model="form.hero_desc_en" rows="3" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Deskripsi Hero (ID)</label>
            <textarea v-model="form.hero_desc_id" rows="3" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
          </div>
        </div>
      </div>

      <!-- About Section -->
      <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 space-y-4">
        <h3 class="text-sm font-semibold text-gray-300 flex items-center gap-2"><UserSquare2 class="w-4 h-4 text-violet-400" /> About Section</h3>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Judul About (EN)</label>
            <input v-model="form.about_title_en" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Judul About (ID)</label>
            <input v-model="form.about_title_id" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Bio (EN)</label>
            <textarea v-model="form.about_bio_en" rows="4" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Bio (ID)</label>
            <textarea v-model="form.about_bio_id" rows="4" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Spesialisasi (EN)</label>
            <textarea v-model="form.about_specialty_en" rows="3" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Spesialisasi (ID)</label>
            <textarea v-model="form.about_specialty_id" rows="3" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
          </div>
        </div>
      </div>

      <!-- Contact Info -->
      <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 space-y-4">
        <h3 class="text-sm font-semibold text-gray-300 flex items-center gap-2"><Phone class="w-4 h-4 text-violet-400" /> Informasi Kontak</h3>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Email</label>
            <input v-model="form.contact_email" type="email" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Lokasi</label>
            <input v-model="form.contact_location" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Waktu Respon (EN)</label>
            <input v-model="form.contact_response_en" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Waktu Respon (ID)</label>
            <input v-model="form.contact_response_id" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
        </div>
      </div>

      <!-- Social Media -->
      <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 space-y-4">
        <h3 class="text-sm font-semibold text-gray-300 flex items-center gap-2"><Globe class="w-4 h-4 text-violet-400" /> Media Sosial</h3>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">GitHub URL</label>
            <input v-model="form.social_github" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://github.com/..." />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">LinkedIn URL</label>
            <input v-model="form.social_linkedin" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://linkedin.com/in/..." />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">Instagram URL</label>
            <input v-model="form.social_instagram" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://instagram.com/..." />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1.5">TikTok URL</label>
            <input v-model="form.social_tiktok" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://tiktok.com/@..." />
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { Save, Loader2, ImageIcon, Home, UserSquare2, Phone, Globe } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

const form = ref({})
const isLoading = ref(true)
const isSaving = ref(false)
const toast = ref({ show: false, type: 'success', message: '' })

const rolesText = computed({
  get: () => (form.value.hero_roles ?? []).join(', '),
  set: (val) => { form.value.hero_roles = val.split(',').map(s => s.trim()).filter(Boolean) }
})

const showToast = (type, message) => {
  toast.value = { show: true, type, message }
  setTimeout(() => (toast.value.show = false), 3000)
}

onMounted(async () => {
  const { data } = await supabase.from('site_settings').select('*').eq('id', 1).single()
  if (data) form.value = data
  isLoading.value = false
})

const save = async () => {
  isSaving.value = true
  const { error } = await supabase.from('site_settings').upsert({ ...form.value, id: 1 })
  if (error) showToast('error', 'Gagal menyimpan: ' + error.message)
  else showToast('success', '✓ Pengaturan berhasil disimpan!')
  isSaving.value = false
}
</script>
