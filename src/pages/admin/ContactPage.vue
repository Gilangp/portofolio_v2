<template>
  <div class="space-y-6 max-w-4xl">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Pengaturan Section Kontak & Pesan</h2>
        <p class="text-sm text-slate-400 mt-1">Kelola email penerima pesan, lokasi domisili, dan keterangan waktu respon</p>
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
      <div v-for="i in 2" :key="i" class="skeleton h-28 rounded-2xl" />
    </div>

    <template v-else>
      <!-- Informasi Kontak Utama -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <Phone class="w-4 h-4 text-blue-400" /> Informasi Email & Lokasi
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Email Kontak (Penerima Form & Tampil di Web)</label>
            <input v-model="form.contact_email" type="email" class="input-admin" placeholder="admin@domain.com" />
            <p class="text-xs text-slate-500 mt-1">Digunakan untuk menerima pesan dari pengunjung website</p>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Lokasi / Domisili</label>
            <input v-model="form.contact_location" type="text" class="input-admin" placeholder="Jakarta, Indonesia" />
            <p class="text-xs text-slate-500 mt-1">Tampil di informasi kartu kontak</p>
          </div>
        </div>
      </div>

      <!-- Waktu Respon -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <Clock class="w-4 h-4 text-blue-400" /> Keterangan Waktu Respon
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Waktu Respon (English)</label>
            <input v-model="form.contact_response_en" type="text" class="input-admin" placeholder="Usually responds within 24 hours" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Waktu Respon (Indonesia)</label>
            <input v-model="form.contact_response_id" type="text" class="input-admin" placeholder="Biasanya membalas dalam 24 jam" />
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Save, Loader2, Phone, Clock, CheckCircle, AlertCircle } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

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
    contact_email: form.value.contact_email,
    contact_location: form.value.contact_location,
    contact_response_en: form.value.contact_response_en,
    contact_response_id: form.value.contact_response_id,
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
  else showToast('success', 'Informasi Kontak berhasil disimpan!')
  isSaving.value = false
}
</script>
