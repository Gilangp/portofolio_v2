<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-white">Manajemen Proyek</h2>
        <p class="text-sm text-gray-400 mt-1">{{ projects.length }} proyek tersimpan</p>
      </div>
      <button @click="openForm()" class="btn-admin">
        <Plus class="w-4 h-4" /> Tambah Proyek
      </button>
    </div>

    <!-- List -->
    <div v-if="isLoading" class="space-y-3">
      <div v-for="i in 4" :key="i" class="skeleton h-24 rounded-xl" />
    </div>
    <div v-else-if="!projects.length" class="text-center py-16 text-gray-500">
      <FolderOpen class="w-12 h-12 mx-auto mb-3 opacity-40" />
      <p>Belum ada proyek. Tambahkan proyek pertama Anda!</p>
    </div>
    <div v-else class="space-y-3">
      <div v-for="p in projects" :key="p.id"
        class="bg-gray-900 border border-gray-800 rounded-xl p-4 flex items-center gap-4 hover:border-gray-700 transition-colors">
        <img :src="p.image_url" :alt="p.title" class="w-20 h-14 object-cover rounded-lg flex-shrink-0" />
        <div class="flex-1 min-w-0">
          <h3 class="text-sm font-semibold text-white truncate">{{ p.title }}</h3>
          <p class="text-xs text-gray-400 line-clamp-2 mt-0.5">{{ p.short_description_en }}</p>
          <div class="flex flex-wrap gap-1 mt-1.5">
            <span v-for="tag in (p.tags ?? []).slice(0, 4)" :key="tag" class="px-1.5 py-0.5 bg-gray-800 text-gray-400 text-xs rounded">{{ tag }}</span>
          </div>
        </div>
        <div class="flex gap-2 flex-shrink-0">
          <button @click="openForm(p)" class="p-2 rounded-lg bg-gray-800 hover:bg-violet-900/40 hover:text-violet-400 text-gray-400 transition-colors"><Pencil class="w-4 h-4" /></button>
          <button @click="deleteProject(p.id)" class="p-2 rounded-lg bg-gray-800 hover:bg-red-900/40 hover:text-red-400 text-gray-400 transition-colors"><Trash2 class="w-4 h-4" /></button>
        </div>
      </div>
    </div>

    <!-- Modal Form -->
    <Transition name="modal">
      <div v-if="showForm" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm" @click.self="showForm = false">
        <div class="bg-gray-900 border border-gray-800 rounded-2xl w-full max-w-3xl max-h-[90vh] overflow-y-auto shadow-2xl">
          <div class="sticky top-0 bg-gray-900 border-b border-gray-800 px-6 py-4 flex items-center justify-between">
            <h3 class="text-base font-bold text-white">{{ editingId ? 'Edit Proyek' : 'Tambah Proyek Baru' }}</h3>
            <button @click="showForm = false" class="text-gray-500 hover:text-gray-300"><X class="w-5 h-5" /></button>
          </div>

          <div class="p-6 space-y-5">
            <div>
              <label class="block text-xs text-gray-400 mb-1">Judul Proyek</label>
              <input v-model="form.title" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs text-gray-400 mb-1">URL Gambar</label>
                <input v-model="form.image_url" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://..." />
              </div>
              <div>
                <label class="block text-xs text-gray-400 mb-1">Tags (pisah koma)</label>
                <input :value="tagsText" @input="tagsText = $event.target.value" type="text" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="Vue.js, Laravel, MySQL" />
              </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div><label class="block text-xs text-gray-400 mb-1">Deskripsi Singkat (EN)</label><textarea v-model="form.short_description_en" rows="2" class="input-base bg-gray-800 border-gray-700 text-white resize-none" /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Deskripsi Singkat (ID)</label><textarea v-model="form.short_description_id" rows="2" class="input-base bg-gray-800 border-gray-700 text-white resize-none" /></div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div><label class="block text-xs text-gray-400 mb-1">Deskripsi Lengkap (EN)</label><textarea v-model="form.description_en" rows="4" class="input-base bg-gray-800 border-gray-700 text-white resize-none" /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Deskripsi Lengkap (ID)</label><textarea v-model="form.description_id" rows="4" class="input-base bg-gray-800 border-gray-700 text-white resize-none" /></div>
            </div>
            <div class="grid grid-cols-3 gap-4">
              <div><label class="block text-xs text-gray-400 mb-1">Semester (EN)</label><input v-model="form.semester_en" type="text" class="input-base bg-gray-800 border-gray-700 text-white" /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Semester (ID)</label><input v-model="form.semester_id" type="text" class="input-base bg-gray-800 border-gray-700 text-white" /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Sort Order</label><input v-model.number="form.sort_order" type="number" class="input-base bg-gray-800 border-gray-700 text-white" /></div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div><label class="block text-xs text-gray-400 mb-1">Tipe Proyek (EN)</label><input v-model="form.project_type_en" type="text" class="input-base bg-gray-800 border-gray-700 text-white" /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Tipe Proyek (ID)</label><input v-model="form.project_type_id" type="text" class="input-base bg-gray-800 border-gray-700 text-white" /></div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div><label class="block text-xs text-gray-400 mb-1">Ukuran Tim (EN)</label><input v-model="form.team_size_en" type="text" class="input-base bg-gray-800 border-gray-700 text-white" /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Ukuran Tim (ID)</label><input v-model="form.team_size_id" type="text" class="input-base bg-gray-800 border-gray-700 text-white" /></div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div><label class="block text-xs text-gray-400 mb-1">Fitur (EN) — satu per baris</label><textarea v-model="featuresEnText" rows="4" class="input-base bg-gray-800 border-gray-700 text-white resize-none font-mono text-xs" /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Fitur (ID) — satu per baris</label><textarea v-model="featuresIdText" rows="4" class="input-base bg-gray-800 border-gray-700 text-white resize-none font-mono text-xs" /></div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div><label class="block text-xs text-gray-400 mb-1">Live URL</label><input v-model="form.live_url" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://..." /></div>
              <div><label class="block text-xs text-gray-400 mb-1">Code URL (GitHub)</label><input v-model="form.code_url" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://github.com/..." /></div>
            </div>
          </div>

          <div class="sticky bottom-0 bg-gray-900 border-t border-gray-800 px-6 py-4 flex gap-3 justify-end">
            <button @click="showForm = false" class="px-4 py-2 text-sm text-gray-400 hover:text-white transition-colors">Batal</button>
            <button @click="saveProject" :disabled="isSaving" class="btn-admin">
              <Loader2 v-if="isSaving" class="w-4 h-4 animate-spin" />
              <Save v-else class="w-4 h-4" />
              {{ isSaving ? 'Menyimpan...' : 'Simpan' }}
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
.modal-enter-active, .modal-leave-active { transition: all 0.3s cubic-bezier(0.22, 1, 0.36, 1); }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>
