<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Manajemen Keahlian (Skills)</h2>
        <p class="text-sm text-slate-400 mt-1">{{ skills.length }} skill & tools tersimpan di database</p>
      </div>
      <button @click="openForm()" class="btn-admin"><Plus class="w-4 h-4" /> Tambah Skill Baru</button>
    </div>

    <!-- Category tabs -->
    <div class="flex gap-2 flex-wrap">
      <button v-for="cat in categories" :key="cat.value" @click="activeCategory = cat.value"
        class="px-3.5 py-2 text-xs font-semibold rounded-xl border transition-all duration-200"
        :class="activeCategory === cat.value ? 'bg-blue-600 border-blue-500 text-white shadow-md shadow-blue-500/20' : 'bg-slate-900/80 border-slate-800 text-slate-400 hover:text-white hover:border-slate-700'">
        {{ cat.label }} ({{ skills.filter(s => s.category === cat.value).length }})
      </button>
    </div>

    <div v-if="isLoading" class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3.5">
      <div v-for="i in 8" :key="i" class="skeleton h-16 rounded-2xl" />
    </div>
    <div v-else class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3.5">
      <div v-for="s in filteredSkills" :key="s.id"
        class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-3.5 flex items-center gap-3.5 group hover:border-slate-700 transition-colors shadow-sm">
        <div class="w-10 h-10 rounded-xl bg-slate-950/60 border border-slate-800 flex items-center justify-center p-1.5 flex-shrink-0">
          <img :src="s.icon_url" :alt="s.name" class="w-full h-full object-contain" loading="lazy" />
        </div>
        <span class="text-sm text-slate-200 font-semibold flex-1 truncate">{{ s.name }}</span>
        <div class="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          <button @click="openForm(s)" class="p-1.5 rounded-lg text-slate-400 hover:text-blue-400 hover:bg-slate-800" title="Edit"><Pencil class="w-3.5 h-3.5" /></button>
          <button @click="deleteSkill(s.id)" class="p-1.5 rounded-lg text-slate-400 hover:text-rose-400 hover:bg-slate-800" title="Hapus"><Trash2 class="w-3.5 h-3.5" /></button>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <Transition name="modal">
      <div v-if="showForm" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm" @click.self="showForm = false">
        <div class="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md shadow-2xl p-6 space-y-4">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-base font-bold text-slate-100">{{ editingId ? 'Edit Skill' : 'Tambah Skill Baru' }}</h3>
            <button @click="showForm = false" class="text-slate-500 hover:text-slate-300"><X class="w-5 h-5" /></button>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Nama Skill / Tool</label>
            <input v-model="form.name" type="text" class="input-admin" placeholder="Contoh: Vue.js" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Kategori</label>
            <select v-model="form.category" class="input-admin">
              <option v-for="c in categories" :key="c.value" :value="c.value">{{ c.label }}</option>
            </select>
          </div>
          <div>
            <ImageUploadInput
              v-model="form.icon_url"
              label="Ikon Skill (.svg / .png transparan)"
              folder="skills"
              placeholder="https://... atau klik Upload File"
            />
            <div v-if="form.icon_url" class="mt-3 flex items-center gap-3 p-2 rounded-xl bg-slate-950/60 border border-slate-800 w-fit">
              <img :src="form.icon_url" class="w-8 h-8 object-contain" />
              <span class="text-xs text-slate-400 font-medium pr-2">Preview Ikon</span>
            </div>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Urutan (Sort Order)</label>
            <input v-model.number="form.sort_order" type="number" class="input-admin" />
          </div>
          <div class="flex gap-3 justify-end pt-3">
            <button @click="showForm = false" class="px-4 py-2 text-sm text-slate-400 hover:text-white transition-colors">Batal</button>
            <button @click="saveSkill" :disabled="isSaving" class="btn-admin">
              <Loader2 v-if="isSaving" class="w-4 h-4 animate-spin" />
              <Save v-else class="w-4 h-4" />
              Simpan Skill
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Plus, Pencil, Trash2, X, Save, Loader2 } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import ImageUploadInput from '@/components/admin/ImageUploadInput.vue'

const skills = ref([])
const isLoading = ref(true)
const showForm = ref(false)
const isSaving = ref(false)
const editingId = ref(null)
const activeCategory = ref('development')

const categories = [
  { value: 'development', label: 'Development' },
  { value: 'networking_tool', label: 'Network Tools' },
  { value: 'networking_knowledge', label: 'Network Knowledge' },
  { value: 'tool', label: 'Dev Tools' },
]

const filteredSkills = computed(() => skills.value.filter(s => s.category === activeCategory.value))
const defaultForm = () => ({ name: '', category: 'development', icon_url: '', sort_order: 0 })
const form = ref(defaultForm())

const load = async () => {
  const { data } = await supabase.from('skills').select('*').order('sort_order')
  skills.value = data ?? []
  isLoading.value = false
}

const openForm = (s = null) => {
  form.value = s ? { ...s } : defaultForm()
  editingId.value = s?.id ?? null
  showForm.value = true
}

const saveSkill = async () => {
  isSaving.value = true
  const payload = { ...form.value }
  delete payload.id
  let err
  if (editingId.value) {
    const r = await supabase.from('skills').update(payload).eq('id', editingId.value)
    err = r.error
  } else {
    const r = await supabase.from('skills').insert(payload)
    err = r.error
  }
  if (!err) { showForm.value = false; load() }
  isSaving.value = false
}

const deleteSkill = async (id) => {
  if (!confirm('Hapus skill ini?')) return
  await supabase.from('skills').delete().eq('id', id)
  load()
}

onMounted(load)
</script>

<style scoped>
.modal-enter-active, .modal-leave-active { transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>
