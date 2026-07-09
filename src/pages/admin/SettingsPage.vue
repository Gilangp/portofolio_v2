<template>
  <div class="space-y-6 max-w-4xl">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Pengaturan Umum & Biodata</h2>
        <p class="text-sm text-slate-400 mt-1">Kontrol seluruh teks dasar, brand, logo, foto profil, dan media sosial</p>
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
      <div v-for="i in 6" :key="i" class="skeleton h-20 rounded-2xl" />
    </div>

    <template v-else>
      <!-- Brand & SEO Section -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <Sparkles class="w-4 h-4 text-blue-400" /> Brand, Logo & Favicon Website
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul Tab Browser (SEO Title)</label>
            <input v-model="form.site_title" type="text" class="input-admin" placeholder="Gilang Purnomo — Portofolio" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Teks Logo / Inisial (Jika tanpa gambar)</label>
            <input v-model="form.site_logo_text" type="text" class="input-admin" placeholder="GP" />
          </div>
          <div class="sm:col-span-2 grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <ImageUploadInput
                v-model="form.site_logo_url"
                label="Gambar Logo (Opsional - PNG/SVG)"
                folder="logos"
                placeholder="https://... atau klik Upload File"
              />
              <div v-if="form.site_logo_url" class="mt-2.5 flex items-center gap-2 p-2 rounded-lg bg-slate-950 border border-slate-800 w-fit">
                <img :src="form.site_logo_url" class="h-6 w-auto object-contain" />
                <span class="text-xs text-slate-400">Preview Logo</span>
              </div>
            </div>
            <div>
              <ImageUploadInput
                v-model="form.site_favicon_url"
                label="Favicon (.ico / .png tab icon)"
                folder="logos"
                placeholder="https://... atau klik Upload File"
              />
              <div v-if="form.site_favicon_url" class="mt-2.5 flex items-center gap-2 p-2 rounded-lg bg-slate-950 border border-slate-800 w-fit">
                <img :src="form.site_favicon_url" class="w-5 h-5 object-contain" />
                <span class="text-xs text-slate-400">Preview Favicon</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Photo Section -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <ImageIcon class="w-4 h-4 text-blue-400" /> Foto Profil & Halaman
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-1">
          <div>
            <ImageUploadInput
              v-model="form.profile_photo_url"
              label="Foto Hero (Halaman Home)"
              folder="profiles"
              placeholder="https://... atau klik Upload File"
            />
            <div class="mt-3 flex items-center gap-3">
              <img v-if="form.profile_photo_url" :src="form.profile_photo_url" class="w-12 h-12 rounded-full object-cover border border-slate-700 shadow" />
              <span class="text-xs text-slate-500">Tampil di lingkaran hero beranda</span>
            </div>
          </div>
          <div>
            <ImageUploadInput
              v-model="form.about_photo_url"
              label="Foto About (Halaman About)"
              folder="profiles"
              placeholder="https://... atau klik Upload File"
            />
            <div class="mt-3 flex items-center gap-3">
              <img v-if="form.about_photo_url" :src="form.about_photo_url" class="w-12 h-12 rounded-xl object-cover border border-slate-700 shadow" />
              <span class="text-xs text-slate-500">Tampil di section tentang saya</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Hero Section -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <Home class="w-4 h-4 text-blue-400" /> Section Beranda (Hero)
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Nama Lengkap</label>
            <input v-model="form.name" type="text" class="input-admin" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Link Download CV (PDF URL)</label>
            <input v-model="form.cv_url" type="url" class="input-admin" placeholder="https://..." />
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Salam Pembuka (English)</label>
            <input v-model="form.hero_greeting_en" type="text" class="input-admin" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Salam Pembuka (Indonesia)</label>
            <input v-model="form.hero_greeting_id" type="text" class="input-admin" />
          </div>
        </div>
        <div>
          <label class="block text-xs font-semibold text-slate-400 mb-1.5">Daftar Teks Efek Mengetik (pisahkan dengan koma)</label>
          <input :value="rolesText" @input="rolesText = $event.target.value" type="text" class="input-admin" placeholder="Fullstack Developer, Network Engineer" />
          <p class="text-xs text-slate-500 mt-1.5">Contoh: <code class="text-blue-400">Fullstack Developer, Network Engineer, QA Automation</code></p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Singkat Hero (English)</label>
            <textarea v-model="form.hero_desc_en" rows="3" class="input-admin resize-none" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Singkat Hero (Indonesia)</label>
            <textarea v-model="form.hero_desc_id" rows="3" class="input-admin resize-none" />
          </div>
        </div>
      </div>

      <!-- About Section -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <UserSquare2 class="w-4 h-4 text-blue-400" /> Section Tentang Saya (About)
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul About (English)</label>
            <input v-model="form.about_title_en" type="text" class="input-admin" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul About (Indonesia)</label>
            <input v-model="form.about_title_id" type="text" class="input-admin" />
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Biografi Utama (English)</label>
            <textarea v-model="form.about_bio_en" rows="4" class="input-admin resize-none" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Biografi Utama (Indonesia)</label>
            <textarea v-model="form.about_bio_id" rows="4" class="input-admin resize-none" />
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Keahlian & Spesialisasi (English)</label>
            <textarea v-model="form.about_specialty_en" rows="3" class="input-admin resize-none" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Keahlian & Spesialisasi (Indonesia)</label>
            <textarea v-model="form.about_specialty_id" rows="3" class="input-admin resize-none" />
          </div>
        </div>
      </div>

      <!-- Contact Info -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <Phone class="w-4 h-4 text-blue-400" /> Informasi Kontak
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Email Kontak (Untuk form pesan)</label>
            <input v-model="form.contact_email" type="email" class="input-admin" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Lokasi</label>
            <input v-model="form.contact_location" type="text" class="input-admin" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Waktu Respon (English)</label>
            <input v-model="form.contact_response_en" type="text" class="input-admin" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Waktu Respon (Indonesia)</label>
            <input v-model="form.contact_response_id" type="text" class="input-admin" />
          </div>
        </div>
      </div>

      <!-- Footer Custom Content -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2 border-b border-slate-800 pb-3">
          <LayoutBottom class="w-4 h-4 text-blue-400" /> Tampilan & Konten Footer Website
        </h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Tagline / Deskripsi Footer (English)</label>
            <textarea v-model="form.footer_tagline_en" rows="2" class="input-admin resize-none" placeholder="Thank you for visiting my portfolio. Let's create something amazing together!" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Tagline / Deskripsi Footer (Indonesia)</label>
            <textarea v-model="form.footer_tagline_id" rows="2" class="input-admin resize-none" placeholder="Terima kasih telah mengunjungi portofolio saya. Mari berkarya bersama!" />
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Teks Hak Cipta / Copyright (English)</label>
            <input v-model="form.footer_copyright_en" type="text" class="input-admin" placeholder="All rights reserved. Designed & built with passion." />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Teks Hak Cipta / Copyright (Indonesia)</label>
            <input v-model="form.footer_copyright_id" type="text" class="input-admin" placeholder="Hak cipta dilindungi undang-undang. Didesain dengan dedikasi." />
          </div>
        </div>
      </div>

      <!-- Dynamic Social Media -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-6 space-y-4 shadow-sm">
        <div class="flex items-center justify-between border-b border-slate-800 pb-3">
          <h3 class="text-sm font-bold text-slate-200 flex items-center gap-2">
            <Globe class="w-4 h-4 text-blue-400" /> Daftar Media Sosial Dinamis
          </h3>
          <button @click="addSocialLink" type="button" class="px-3 py-1.5 bg-blue-600/20 hover:bg-blue-600 text-blue-400 hover:text-white text-xs font-semibold rounded-lg border border-blue-500/30 transition-all flex items-center gap-1.5">
            <Plus class="w-3.5 h-3.5" /> Tambah Media Sosial
          </button>
        </div>

        <p class="text-xs text-slate-400">Tambahkan sebanyak apapun akun media sosial yang ingin Anda tampilkan. Ikon akan otomatis menyesuaikan berdasarkan nama/ikon yang Anda pilih.</p>

        <div v-if="!form.social_links || !form.social_links.length" class="text-center py-6 text-slate-500 border border-dashed border-slate-800 rounded-xl text-xs">
          Belum ada link sosial media. Klik "+ Tambah Media Sosial" di kanan atas.
        </div>

        <div v-else class="space-y-3 pt-1">
          <div
            v-for="(link, idx) in form.social_links"
            :key="idx"
            class="flex items-center gap-3 p-3 rounded-xl bg-slate-950/60 border border-slate-800/80"
          >
            <div class="w-40 flex-shrink-0">
              <label class="block text-[10px] text-slate-500 font-semibold mb-1 uppercase">Platform / Ikon</label>
              <select v-model="link.name" @change="link.icon = link.name" class="input-admin !py-1.5 !text-xs">
                <option value="GitHub">GitHub</option>
                <option value="LinkedIn">LinkedIn</option>
                <option value="Instagram">Instagram</option>
                <option value="TikTok">TikTok</option>
                <option value="Twitter">Twitter / X</option>
                <option value="YouTube">YouTube</option>
                <option value="Discord">Discord</option>
                <option value="Telegram">Telegram</option>
                <option value="WhatsApp">WhatsApp</option>
                <option value="Website">Website Lainnya</option>
              </select>
            </div>

            <div class="flex-1 min-w-0">
              <label class="block text-[10px] text-slate-500 font-semibold mb-1 uppercase">URL Profil</label>
              <input v-model="link.url" type="url" class="input-admin !py-1.5 !text-xs" placeholder="https://..." />
            </div>

            <div class="pt-4 flex-shrink-0">
              <button @click="removeSocialLink(idx)" type="button" class="p-2 rounded-lg bg-slate-800 hover:bg-rose-600/20 text-slate-400 hover:text-rose-400 transition-colors border border-slate-700" title="Hapus link ini">
                <Trash2 class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { Save, Loader2, ImageIcon, Home, UserSquare2, Phone, Globe, Sparkles, Plus, Trash2, CheckCircle, AlertCircle, LayoutTemplate as LayoutBottom } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import ImageUploadInput from '@/components/admin/ImageUploadInput.vue'

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
  setTimeout(() => (toast.value.show = false), 3500)
}

onMounted(async () => {
  const { data } = await supabase.from('site_settings').select('*').eq('id', 1).single()
  if (data) {
    if (!data.social_links || !Array.isArray(data.social_links) || data.social_links.length === 0) {
      const links = []
      if (data.social_github) links.push({ name: 'GitHub', url: data.social_github, icon: 'GitHub' })
      if (data.social_linkedin) links.push({ name: 'LinkedIn', url: data.social_linkedin, icon: 'LinkedIn' })
      if (data.social_instagram) links.push({ name: 'Instagram', url: data.social_instagram, icon: 'Instagram' })
      if (data.social_tiktok) links.push({ name: 'TikTok', url: data.social_tiktok, icon: 'TikTok' })
      data.social_links = links.length ? links : [{ name: 'GitHub', url: 'https://github.com', icon: 'GitHub' }]
    }
    form.value = data
  }
  isLoading.value = false
})

const addSocialLink = () => {
  if (!form.value.social_links) form.value.social_links = []
  form.value.social_links.push({ name: 'Instagram', url: 'https://instagram.com/', icon: 'Instagram' })
}

const removeSocialLink = (index) => {
  form.value.social_links.splice(index, 1)
}

const save = async () => {
  isSaving.value = true
  if (form.value.social_links && Array.isArray(form.value.social_links)) {
    const gh = form.value.social_links.find(s => s.name.toLowerCase().includes('github'))
    const li = form.value.social_links.find(s => s.name.toLowerCase().includes('linkedin'))
    const ig = form.value.social_links.find(s => s.name.toLowerCase().includes('instagram'))
    const tk = form.value.social_links.find(s => s.name.toLowerCase().includes('tiktok'))
    if (gh) form.value.social_github = gh.url
    if (li) form.value.social_linkedin = li.url
    if (ig) form.value.social_instagram = ig.url
    if (tk) form.value.social_tiktok = tk.url
  }

  const { error } = await supabase.from('site_settings').upsert({ ...form.value, id: 1 })
  if (error) showToast('error', 'Gagal menyimpan: ' + error.message)
  else showToast('success', 'Perubahan berhasil disimpan! 🎉')
  isSaving.value = false
}
</script>
