<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Manajemen Proyek Portofolio</h2>
        <p class="text-sm text-slate-400 mt-1">{{ projects.length }} proyek tersimpan di database</p>
      </div>
      <button @click="openForm()" class="btn-admin">
        <Plus class="w-4 h-4" /> Tambah Proyek Baru
      </button>
    </div>

    <!-- List -->
    <div v-if="isLoading" class="space-y-3">
      <div v-for="i in 4" :key="i" class="skeleton h-24 rounded-2xl" />
    </div>
    <div v-else-if="!projects.length" class="text-center py-16 text-slate-500 bg-slate-900/40 border border-slate-800/80 rounded-2xl">
      <FolderOpen class="w-12 h-12 mx-auto mb-3 opacity-40" />
      <p>Belum ada proyek. Klik tombol di atas untuk menambahkan proyek pertama Anda!</p>
    </div>
    <div v-else class="space-y-3">
      <div v-for="p in projects" :key="p.id"
        class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-4 flex items-center gap-4 hover:border-slate-700 transition-colors shadow-sm">
        <img :src="p.image_url" :alt="p.title" class="w-24 h-16 object-cover rounded-xl border border-slate-800 flex-shrink-0 bg-slate-950" />
        <div class="flex-1 min-w-0">
          <h3 class="text-sm font-bold text-slate-100 truncate">{{ p.title }}</h3>
          <p class="text-xs text-slate-400 line-clamp-2 mt-0.5">{{ p.short_description_en }}</p>
          <div class="flex flex-wrap gap-1.5 mt-2">
            <span v-for="tag in (p.tags ?? []).slice(0, 5)" :key="tag" class="px-2 py-0.5 bg-blue-500/10 text-blue-400 border border-blue-500/20 text-[11px] font-medium rounded-md">{{ tag }}</span>
          </div>
        </div>
        <div class="flex gap-2 flex-shrink-0">
          <button @click="openForm(p)" class="p-2.5 rounded-xl bg-slate-800 hover:bg-blue-600/20 hover:text-blue-400 text-slate-400 transition-colors border border-slate-700/60" title="Edit Proyek"><Pencil class="w-4 h-4" /></button>
          <button @click="deleteProject(p.id)" class="p-2.5 rounded-xl bg-slate-800 hover:bg-rose-600/20 hover:text-rose-400 text-slate-400 transition-colors border border-slate-700/60" title="Hapus Proyek"><Trash2 class="w-4 h-4" /></button>
        </div>
      </div>
    </div>

    <!-- Modal Form -->
    <Transition name="modal">
      <div v-if="showForm" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm" @click.self="showForm = false">
        <div class="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-3xl max-h-[90vh] overflow-y-auto shadow-2xl">
          <div class="sticky top-0 bg-slate-900 border-b border-slate-800 px-6 py-4 flex items-center justify-between z-10">
            <h3 class="text-base font-bold text-slate-100">{{ editingId ? 'Edit Proyek' : 'Tambah Proyek Baru' }}</h3>
            <button @click="showForm = false" class="text-slate-500 hover:text-slate-300"><X class="w-5 h-5" /></button>
          </div>

          <div class="p-6 space-y-5">
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul Proyek</label>
              <input v-model="form.title" type="text" class="input-admin" placeholder="Contoh: E-Commerce Web App" />
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 items-start">
              <div>
                <ImageUploadInput
                  v-model="form.image_url"
                  label="Gambar Thumbnail Proyek (.png, .jpg, dll)"
                  folder="projects"
                  placeholder="https://... atau klik Upload File"
                />
                <div v-if="form.image_url" class="mt-2.5">
                  <img :src="form.image_url" class="h-16 w-auto rounded-lg object-cover border border-slate-800 shadow" />
                </div>
              </div>
              <div>
                <label class="block text-xs font-semibold text-slate-400 mb-1.5">Tags (pisahkan koma)</label>
                <input :value="tagsText" @input="tagsText = $event.target.value" type="text" class="input-admin" placeholder="Vue.js, Laravel, MySQL" />
              </div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Singkat (English)</label><textarea v-model="form.short_description_en" rows="2" class="input-admin resize-none" /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Singkat (Indonesia)</label><textarea v-model="form.short_description_id" rows="2" class="input-admin resize-none" /></div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Lengkap (English)</label><textarea v-model="form.description_en" rows="4" class="input-admin resize-none" /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi Lengkap (Indonesia)</label><textarea v-model="form.description_id" rows="4" class="input-admin resize-none" /></div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Semester (English)</label><input v-model="form.semester_en" type="text" class="input-admin" placeholder="5th Semester" /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Semester (Indonesia)</label><input v-model="form.semester_id" type="text" class="input-admin" placeholder="Semester 5" /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Urutan (Sort Order)</label><input v-model.number="form.sort_order" type="number" class="input-admin" /></div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Tipe Proyek (English)</label><input v-model="form.project_type_en" type="text" class="input-admin" placeholder="Academic Project / Internship" /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Tipe Proyek (Indonesia)</label><input v-model="form.project_type_id" type="text" class="input-admin" placeholder="Proyek Akademik / Magang" /></div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Ukuran Tim (English)</label><input v-model="form.team_size_en" type="text" class="input-admin" placeholder="Solo Developer / 4 Members" /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Ukuran Tim (Indonesia)</label><input v-model="form.team_size_id" type="text" class="input-admin" placeholder="Pengembang Solo / 4 Anggota" /></div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Fitur Unggulan (EN) — 1 fitur per baris</label><textarea v-model="featuresEnText" rows="4" class="input-admin resize-none font-mono text-xs" /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Fitur Unggulan (ID) — 1 fitur per baris</label><textarea v-model="featuresIdText" rows="4" class="input-admin resize-none font-mono text-xs" /></div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Live Preview URL</label><input v-model="form.live_url" type="url" class="input-admin" placeholder="https://..." /></div>
              <div><label class="block text-xs font-semibold text-slate-400 mb-1.5">Repository GitHub URL</label><input v-model="form.code_url" type="url" class="input-admin" placeholder="https://github.com/..." /></div>
            </div>
          </div>

          <div class="sticky bottom-0 bg-slate-900 border-t border-slate-800 px-6 py-4 flex gap-3 justify-end z-10">
            <button @click="showForm = false" class="px-4 py-2 text-sm text-slate-400 hover:text-white transition-colors">Batal</button>
            <button @click="saveProject" :disabled="isSaving" class="btn-admin">
              <Loader2 v-if="isSaving" class="w-4 h-4 animate-spin" />
              <Save v-else class="w-4 h-4" />
              {{ isSaving ? 'Menyimpan...' : 'Simpan Proyek' }}
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Plus, Pencil, Trash2, X, Save, Loader2, FolderOpen } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import ImageUploadInput from '@/components/admin/ImageUploadInput.vue'

const projects = ref([])
const isLoading = ref(true)
const showForm = ref(false)
const isSaving = ref(false)
const editingId = ref(null)

const defaultForm = () => ({ title: '', image_url: '', short_description_en: '', short_description_id: '', description_en: '', description_id: '', semester_en: '', semester_id: '', project_type_en: '', project_type_id: '', team_size_en: '', team_size_id: '', tags: [], features_en: [], features_id: [], live_url: '', code_url: '', sort_order: 0 })
const form = ref(defaultForm())

const tagsText = computed({ get: () => (form.value.tags ?? []).join(', '), set: v => { form.value.tags = v.split(',').map(s => s.trim()).filter(Boolean) } })
const featuresEnText = computed({ get: () => (form.value.features_en ?? []).join('\n'), set: v => { form.value.features_en = v.split('\n').map(s => s.trim()).filter(Boolean) } })
const featuresIdText = computed({ get: () => (form.value.features_id ?? []).join('\n'), set: v => { form.value.features_id = v.split('\n').map(s => s.trim()).filter(Boolean) } })

const load = async () => {
  const { data } = await supabase.from('projects').select('*').order('sort_order')
  projects.value = data ?? []
  isLoading.value = false
}

const openForm = (p = null) => {
  form.value = p ? { ...p } : defaultForm()
  editingId.value = p?.id ?? null
  showForm.value = true
}

const saveProject = async () => {
  isSaving.value = true
  const payload = { ...form.value }
  delete payload.id
  let err
  if (editingId.value) {
    const r = await supabase.from('projects').update(payload).eq('id', editingId.value)
    err = r.error
  } else {
    const r = await supabase.from('projects').insert(payload)
    err = r.error
  }
  if (!err) { showForm.value = false; load() }
  isSaving.value = false
}

const deleteProject = async (id) => {
  if (!confirm('Hapus proyek ini?')) return
  await supabase.from('projects').delete().eq('id', id)
  load()
}

onMounted(load)
</script>

<style scoped>
.modal-enter-active, .modal-leave-active { transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>
