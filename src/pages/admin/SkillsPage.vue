<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-white">Manajemen Keahlian</h2>
        <p class="text-sm text-gray-400 mt-1">{{ skills.length }} skill tersimpan</p>
      </div>
      <button @click="openForm()" class="btn-admin"><Plus class="w-4 h-4" /> Tambah Skill</button>
    </div>

    <!-- Category tabs -->
    <div class="flex gap-2 flex-wrap">
      <button v-for="cat in categories" :key="cat.value" @click="activeCategory = cat.value"
        class="px-3 py-1.5 text-xs font-medium rounded-lg border transition-colors"
        :class="activeCategory === cat.value ? 'bg-violet-600 border-violet-500 text-white' : 'bg-gray-800 border-gray-700 text-gray-400 hover:text-white'">
        {{ cat.label }} ({{ skills.filter(s => s.category === cat.value).length }})
      </button>
    </div>

    <div v-if="isLoading" class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
      <div v-for="i in 8" :key="i" class="skeleton h-16 rounded-xl" />
    </div>
    <div v-else class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
      <div v-for="s in filteredSkills" :key="s.id"
        class="bg-gray-900 border border-gray-800 rounded-xl p-3 flex items-center gap-3 group hover:border-gray-700 transition-colors">
        <img :src="s.icon_url" :alt="s.name" class="w-8 h-8 object-contain" loading="lazy" />
        <span class="text-sm text-gray-300 font-medium flex-1 truncate">{{ s.name }}</span>
        <div class="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          <button @click="openForm(s)" class="p-1 rounded text-gray-500 hover:text-violet-400"><Pencil class="w-3.5 h-3.5" /></button>
          <button @click="deleteSkill(s.id)" class="p-1 rounded text-gray-500 hover:text-red-400"><Trash2 class="w-3.5 h-3.5" /></button>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <Transition name="modal">
      <div v-if="showForm" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm" @click.self="showForm = false">
        <div class="bg-gray-900 border border-gray-800 rounded-2xl w-full max-w-md shadow-2xl p-6 space-y-4">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-base font-bold text-white">{{ editingId ? 'Edit Skill' : 'Tambah Skill' }}</h3>
            <button @click="showForm = false" class="text-gray-500 hover:text-gray-300"><X class="w-5 h-5" /></button>
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1">Nama Skill</label>
            <input v-model="form.name" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1">Kategori</label>
            <select v-model="form.category" class="input-base bg-gray-800 border-gray-700 text-white">
              <option v-for="c in categories" :key="c.value" :value="c.value">{{ c.label }}</option>
            </select>
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1">URL Ikon (SVG/PNG)</label>
            <input v-model="form.icon_url" type="url" class="input-base bg-gray-800 border-gray-700 text-white" placeholder="https://cdn.jsdelivr.net/..." />
            <div v-if="form.icon_url" class="mt-2 flex items-center gap-2">
              <img :src="form.icon_url" class="w-8 h-8 object-contain" />
              <span class="text-xs text-gray-500">Preview ikon</span>
            </div>
          </div>
          <div>
            <label class="block text-xs text-gray-400 mb-1">Sort Order</label>
            <input v-model.number="form.sort_order" type="number" class="input-base bg-gray-800 border-gray-700 text-white" />
          </div>
          <div class="flex gap-3 justify-end pt-2">
            <button @click="showForm = false" class="px-4 py-2 text-sm text-gray-400 hover:text-white transition-colors">Batal</button>
            <button @click="saveSkill" :disabled="isSaving" class="btn-admin">
              <Loader2 v-if="isSaving" class="w-4 h-4 animate-spin" />
              <Save v-else class="w-4 h-4" />
              Simpan
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
.modal-enter-active, .modal-leave-active { transition: all 0.3s cubic-bezier(0.22, 1, 0.36, 1); }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>
