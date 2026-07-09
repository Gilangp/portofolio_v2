<template>
  <div class="space-y-6 max-w-4xl">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Pengaturan Section Tentang Saya (About)</h2>
        <p class="text-sm text-slate-400 mt-1">Kelola foto profil about, judul biografi, deskripsi utama, dan keahlian spesialisasi</p>
      </div>
      <button @click="save" :disabled="isSaving" class="btn-admin">
        <Loader2 v-if="isSaving" class="w-4 h-4 animate-spin" />
        <Save v-else class="w-4 h-4" />
        {{ isSaving ? 'Menyimpan...' : 'Simpan Perubahan' }}
      </button>
    </div>

    <!-- Toast -->
    <Transition name="toast">
      <div v-if="toast.show" class="fixed top-6 right-6 z-50 px-5 py-3.5 rounded-2xl shadow-2xl text-white text-sm font-medium flex items-center gap-2 border border-white/10"
           :class="toast.type === 'success' ? 'bg-emerald-600' : 'bg-rose-600'">
        <CheckCircle v-if="toast.type === 'success'" class="w-4 h-4" />
        <AlertCircle v-else class="w-4 h-4" />
        <span>{{ toast.message }}</span>
      </div>
    </Transition>

    <div v-if="isLoading" class="space-y-4">
      <div v-for="i in 3" :key="i" class="skeleton h-28 rounded-2xl" />
    </div>

    <template v-else>
      <!-- Foto & Judul About -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <ImageIcon class="w-4 h-4 text-blue-400" /> Foto Profil & Judul Halaman About
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-1">
          <div>
            <ImageUploadInput
              v-model="form.about_photo_url"
              label="Foto About (Tampil di section Tentang Saya)"
              folder="profiles"
              placeholder="https://... atau klik Upload File"
            />
            <div class="mt-3 flex items-center gap-3">
              <img v-if="form.about_photo_url" :src="form.about_photo_url" class="w-12 h-12 rounded-xl object-cover border border-slate-700 shadow" />
              <span class="text-xs text-slate-500">Tampil di samping/atas biografi Anda</span>
            </div>
          </div>
          <div class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul About (English)</label>
              <input v-model="form.about_title_en" type="text" class="input-admin" placeholder="About Me" />
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul About (Indonesia)</label>
              <input v-model="form.about_title_id" type="text" class="input-admin" placeholder="Tentang Saya" />
            </div>
          </div>
        </div>
      </div>

      <!-- Biografi Utama -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <UserSquare2 class="w-4 h-4 text-blue-400" /> Biografi Utama
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Biografi Lengkap (English)</label>
            <textarea v-model="form.about_bio_en" rows="5" class="input-admin resize-none" placeholder="I am a passionate computer science..." />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Biografi Lengkap (Indonesia)</label>
            <textarea v-model="form.about_bio_id" rows="5" class="input-admin resize-none" placeholder="Saya adalah mahasiswa informatika..." />
          </div>
        </div>
      </div>

      <!-- Spesialisasi & Ringkasan -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <Sparkles class="w-4 h-4 text-blue-400" /> Keahlian & Spesialisasi Singkat
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Spesialisasi Tambahan (English)</label>
            <textarea v-model="form.about_specialty_en" rows="3" class="input-admin resize-none" placeholder="My specialization spans across..." />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Spesialisasi Tambahan (Indonesia)</label>
            <textarea v-model="form.about_specialty_id" rows="3" class="input-admin resize-none" placeholder="Spesialisasi saya mencakup..." />
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Save, Loader2, ImageIcon, UserSquare2, Sparkles, CheckCircle, AlertCircle } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import ImageUploadInput from '@/components/admin/ImageUploadInput.vue'

const form = ref({})
const isLoading = ref(true)
const isSaving = ref(false)
const toast = ref({ show: false, type: 'success', message: '' })

const showToast = (type, message) => {
  toast.value = { show: true, type, message }
  setTimeout(() => (toast.value.show = false), 3500)
}

onMounted(async () => {
  const { data } = await supabase.from('site_settings').select('*').eq('id', 1).single()
  if (data) {
    form.value = data
  }
  isLoading.value = false
})

const save = async () => {
  isSaving.value = true
  
  const updatePayload = {
    about_photo_url: form.value.about_photo_url,
    about_title_en: form.value.about_title_en,
    about_title_id: form.value.about_title_id,
    about_bio_en: form.value.about_bio_en,
    about_bio_id: form.value.about_bio_id,
    about_specialty_en: form.value.about_specialty_en,
    about_specialty_id: form.value.about_specialty_id,
  }

  let payload = { ...updatePayload }
  let { error } = await supabase.from('site_settings').update(payload).eq('id', 1)

  let attempts = 0
  while (error && attempts < 10) {
    if (error.message && (error.message.includes('Could not find') || error.message.includes('schema cache'))) {
      const match = error.message.match(/'([^']+)' column/)
      if (match && match[1] && payload[match[1]] !== undefined) {
        delete payload[match[1]]
        delete form.value[match[1]]
        attempts++
        const retry = await supabase.from('site_settings').update(payload).eq('id', 1)
        error = retry.error
        continue
      }
    }
    const upsertPayload = { ...payload, id: 1 }
    const retryUpsert = await supabase.from('site_settings').upsert(upsertPayload)
    error = retryUpsert.error
    if (error && error.message && (error.message.includes('Could not find') || error.message.includes('schema cache'))) {
      const match = error.message.match(/'([^']+)' column/)
      if (match && match[1]) {
        delete payload[match[1]]
        delete form.value[match[1]]
        attempts++
        continue
      }
    }
    break
  }

  if (error) showToast('error', 'Gagal menyimpan: ' + error.message)
  else showToast('success', 'Perubahan About berhasil disimpan!')
  isSaving.value = false
}
</script>
