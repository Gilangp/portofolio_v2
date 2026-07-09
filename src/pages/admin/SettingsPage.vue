<template>
  <div class="space-y-6 max-w-4xl">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Brand, Logo & Media Sosial</h2>
        <p class="text-sm text-slate-400 mt-1">Kontrol identitas website, judul SEO, logo, favicon, dan seluruh tautan media sosial</p>
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
      <div v-for="i in 4" :key="i" class="skeleton h-24 rounded-2xl" />
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
            <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center rounded-xl bg-slate-900 border border-slate-800 text-blue-400 shadow-sm mt-4" title="Preview Ikon Persis">
              <DynamicIcon :name="link.icon || link.name || 'globe'" class-name="w-5 h-5" />
            </div>

            <div class="w-48 flex-shrink-0">
              <label class="block text-[10px] text-slate-400 font-semibold mb-1 uppercase tracking-wider">Platform / Ikon</label>
              <select v-model="link.name" @change="link.icon = link.name" class="input-admin !py-2 !text-xs font-medium cursor-pointer">
                <option value="GitHub">GitHub</option>
                <option value="LinkedIn">LinkedIn</option>
                <option value="Instagram">Instagram</option>
                <option value="TikTok">TikTok</option>
                <option value="Twitter">Twitter / X</option>
                <option value="YouTube">YouTube</option>
                <option value="Discord">Discord</option>
                <option value="Telegram">Telegram</option>
                <option value="WhatsApp">WhatsApp</option>
                <option value="Facebook">Facebook</option>
                <option value="Dribbble">Dribbble</option>
                <option value="Figma">Figma</option>
                <option value="GitLab">GitLab</option>
                <option value="Medium">Medium</option>
                <option value="Behance">Behance</option>
                <option value="Email">Email / Mail</option>
                <option value="Website">Website Lainnya</option>
              </select>
            </div>

            <div class="flex-1 min-w-0">
              <label class="block text-[10px] text-slate-400 font-semibold mb-1 uppercase tracking-wider">URL Profil</label>
              <input v-model="link.url" type="url" class="input-admin !py-2 !text-xs" placeholder="https://..." />
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
import { ref, onMounted } from 'vue'
import { Save, Loader2, Globe, Sparkles, Plus, Trash2, CheckCircle, AlertCircle } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import ImageUploadInput from '@/components/admin/ImageUploadInput.vue'
import DynamicIcon from '@/components/common/DynamicIcon.vue'

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

  const payload = {
    site_title: form.value.site_title,
    site_logo_text: form.value.site_logo_text,
    site_logo_url: form.value.site_logo_url,
    site_favicon_url: form.value.site_favicon_url,
    social_github: form.value.social_github,
    social_linkedin: form.value.social_linkedin,
    social_instagram: form.value.social_instagram,
    social_tiktok: form.value.social_tiktok,
  }

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
  else showToast('success', 'Pengaturan Brand & Media Sosial berhasil disimpan!')
  isSaving.value = false
}
</script>
