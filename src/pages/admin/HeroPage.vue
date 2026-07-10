<template>
  <div class="space-y-6 max-w-4xl">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Pengaturan Section Hero (Beranda)</h2>
        <p class="text-sm text-slate-400 mt-1">Kelola foto utama, nama lengkap, salam pembuka, link CV, efek mengetik, dan deskripsi beranda</p>
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
      <!-- Supabase Schema Warning & Helper Banner -->
      <div v-if="showSchemaWarning" class="bg-amber-500/10 border border-amber-500/30 rounded-2xl p-5 space-y-3 transition-all">
        <div class="flex items-start justify-between gap-3">
          <div class="flex items-center gap-2 text-amber-400 font-bold text-sm">
            <AlertTriangle class="w-5 h-5 flex-shrink-0" />
            <span>Info Penting: Mengatasi Error 400 (Bad Request) pada Supabase</span>
          </div>
          <button @click="showSchemaWarning = false" class="text-slate-400 hover:text-white text-xs font-medium">Tutup ✕</button>
        </div>
        <p class="text-xs text-slate-300 leading-relaxed">
          Jika kolom baru seperti <code class="text-amber-300">hero_greeting_en</code> atau <code class="text-amber-300">hero_roles</code> mengalami error <strong>400 Bad Request</strong> saat disimpan, itu karena tabel <code class="text-amber-300">site_settings</code> di Supabase belum ditambahkan kolom tersebut. Perubahan Anda <strong>tetap aktif langsung di browser & website</strong> saat ini. Untuk menyimpannya permanen ke database Supabase, salin SQL di bawah dan jalankan di menu <strong>SQL Editor</strong> Supabase Anda:
        </p>
        <div class="relative bg-slate-950 rounded-xl p-3 border border-slate-800 text-[11px] font-mono text-slate-300 max-h-40 overflow-y-auto">
          <button @click="copySql" type="button" class="absolute top-2 right-2 px-2.5 py-1 bg-amber-500 hover:bg-amber-400 text-slate-950 font-bold rounded-lg transition-colors flex items-center gap-1 text-xs shadow">
            <Copy class="w-3.5 h-3.5" /> {{ sqlCopied ? 'Tersalin!' : 'Salin SQL Fix' }}
          </button>
          <pre class="whitespace-pre-wrap pr-28">ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS profile_photo_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS name text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS cv_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_greeting_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_greeting_id text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles_en jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles_id jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_desc_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_desc_id text;
NOTIFY pgrst, 'reload schema';</pre>
        </div>
      </div>

      <!-- Foto & Identitas Utama -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <ImageIcon class="w-4 h-4 text-blue-400" /> Foto Utama & Link CV
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-1">
          <div>
            <ImageUploadInput
              v-model="form.profile_photo_url"
              label="Foto Hero (Tampil di lingkaran hero beranda)"
              folder="profiles"
              placeholder="https://... atau klik Upload File"
            />
            <div class="mt-3 flex items-center gap-3">
              <img v-if="form.profile_photo_url" :src="form.profile_photo_url" class="w-12 h-12 rounded-full object-cover border border-slate-700 shadow" />
              <span class="text-xs text-slate-500">Tampil di halaman utama (Hero Section)</span>
            </div>
          </div>
          <div class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Nama Lengkap</label>
              <input v-model="form.name" type="text" class="input-admin" placeholder="Gilang Purnomo" />
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Link Download CV (PDF URL)</label>
              <input v-model="form.cv_url" type="url" class="input-admin" placeholder="https://..." />
            </div>
          </div>
        </div>
      </div>

      <!-- Salam & Efek Mengetik -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <Home class="w-4 h-4 text-blue-400" /> Teks Salam Pembuka & Peran (Typing Effect)
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Salam Pembuka (English)</label>
            <input v-model="form.hero_greeting_en" type="text" class="input-admin" placeholder="Hello, I am" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Salam Pembuka (Indonesia)</label>
            <input v-model="form.hero_greeting_id" type="text" class="input-admin" placeholder="Halo, Saya" />
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Daftar Teks Efek Mengetik (English - pisahkan koma)</label>
            <input :value="rolesTextEn" @input="rolesTextEn = $event.target.value" type="text" class="input-admin" placeholder="Fullstack Developer, Network Engineer" />
            <p class="text-xs text-slate-500 mt-1.5">Contoh: <code class="text-blue-400">Fullstack Developer, Network Engineer</code></p>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Daftar Teks Efek Mengetik (Indonesia - pisahkan koma)</label>
            <input :value="rolesTextId" @input="rolesTextId = $event.target.value" type="text" class="input-admin" placeholder="Pengembang Fullstack, Teknisi Jaringan" />
            <p class="text-xs text-slate-500 mt-1.5">Contoh: <code class="text-blue-400">Pengembang Fullstack, Teknisi Jaringan</code></p>
          </div>
        </div>
      </div>

      <!-- Deskripsi Singkat -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <FileText class="w-4 h-4 text-blue-400" /> Deskripsi Singkat Hero Beranda
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Singkat Hero (English)</label>
            <textarea v-model="form.hero_desc_en" rows="4" class="input-admin resize-none" placeholder="Passionate IT student specializing in..." />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Singkat Hero (Indonesia)</label>
            <textarea v-model="form.hero_desc_id" rows="4" class="input-admin resize-none" placeholder="Mahasiswa IT yang antusias di bidang..." />
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { Save, Loader2, ImageIcon, Home, FileText, CheckCircle, AlertCircle, AlertTriangle, Copy } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import ImageUploadInput from '@/components/admin/ImageUploadInput.vue'
import useSiteSettings from '@/composables/useSiteSettings'

const { updateSiteSettingsLocal } = useSiteSettings()

const form = ref({})
const isLoading = ref(true)
const isSaving = ref(false)
const toast = ref({ show: false, type: 'success', message: '' })
const showSchemaWarning = ref(false)
const sqlCopied = ref(false)

const rolesTextEn = computed({
  get: () => (form.value.hero_roles_en ?? form.value.hero_roles ?? ['Fullstack Developer', 'Network Engineer']).join(', '),
  set: (val) => { form.value.hero_roles_en = val.split(',').map(s => s.trim()).filter(Boolean) }
})

const rolesTextId = computed({
  get: () => (form.value.hero_roles_id ?? ['Pengembang Fullstack', 'Teknisi Jaringan']).join(', '),
  set: (val) => { form.value.hero_roles_id = val.split(',').map(s => s.trim()).filter(Boolean) }
})

const showToast = (type, message) => {
  toast.value = { show: true, type, message }
  setTimeout(() => (toast.value.show = false), 4500)
}

const copySql = () => {
  const sql = `ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS profile_photo_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS name text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS cv_url text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_greeting_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_greeting_id text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles_en jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_roles_id jsonb DEFAULT '[]'::jsonb;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_desc_en text;
ALTER TABLE site_settings ADD COLUMN IF NOT EXISTS hero_desc_id text;
NOTIFY pgrst, 'reload schema';`
  navigator.clipboard.writeText(sql)
  sqlCopied.value = true
  setTimeout(() => (sqlCopied.value = false), 2500)
}

onMounted(async () => {
  const { data } = await supabase.from('site_settings').select('*').eq('id', 1).single()
  let localBackup = {}
  try {
    localBackup = JSON.parse(localStorage.getItem('site_settings_backup') || '{}')
  } catch (e) {}
  form.value = { ...localBackup, ...(data || {}) }
  isLoading.value = false
})

const save = async () => {
  isSaving.value = true
  updateSiteSettingsLocal(form.value)
  
  const updatePayload = {
    profile_photo_url: form.value.profile_photo_url,
    name: form.value.name,
    cv_url: form.value.cv_url,
    hero_greeting_en: form.value.hero_greeting_en,
    hero_greeting_id: form.value.hero_greeting_id,
    hero_roles: form.value.hero_roles_en || form.value.hero_roles,
    hero_roles_en: form.value.hero_roles_en,
    hero_roles_id: form.value.hero_roles_id,
    hero_desc_en: form.value.hero_desc_en,
    hero_desc_id: form.value.hero_desc_id,
  }

  let payload = { ...updatePayload }
  let { error } = await supabase.from('site_settings').update(payload).eq('id', 1)

  let attempts = 0
  let strippedColumns = 0
  while (error && attempts < 10) {
    if (error.message && (error.message.includes('Could not find') || error.message.includes('schema cache'))) {
      const match = error.message.match(/'([^']+)' column/)
      if (match && match[1] && payload[match[1]] !== undefined) {
        // DO NOT delete form.value[match[1]] here so UI retains the user's input!
        delete payload[match[1]]
        attempts++
        strippedColumns++
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
        attempts++
        strippedColumns++
        continue
      }
    }
    break
  }

  if (error && strippedColumns === 0) {
    showToast('error', 'Gagal menyimpan ke Supabase: ' + error.message)
  } else if (strippedColumns > 0) {
    showToast('success', 'Perubahan aktif & tersimpan di browser! (Catatan: Ada kolom belum di database Supabase, klik Info Penting di bawah untuk menyalin SQL fix)')
    showSchemaWarning.value = true
  } else {
    showToast('success', 'Perubahan Hero berhasil disimpan ke database Supabase!')
  }
  isSaving.value = false
}
</script>
