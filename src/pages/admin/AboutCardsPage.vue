<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-white">Kartu About Me</h2>
        <p class="text-sm text-gray-400 mt-1">{{ cards.length }} kartu tersimpan (tampil di halaman About)</p>
      </div>
      <button @click="openForm()" class="btn-admin"><Plus class="w-4 h-4" /> Tambah Kartu</button>
    </div>

    <div v-if="isLoading" class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <div v-for="i in 4" :key="i" class="skeleton h-32 rounded-xl" />
    </div>
    <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <div v-for="c in cards" :key="c.id"
        class="bg-gray-900 border border-gray-800 rounded-xl p-4 hover:border-gray-700 transition-colors">
        <div class="flex items-start justify-between gap-3">
          <div class="flex-1">
            <div class="flex items-center gap-2 mb-2">
              <span class="px-2 py-0.5 bg-violet-900/40 text-violet-400 text-xs font-mono rounded">{{ c.icon_type }}</span>
              <span class="text-xs text-gray-500">order: {{ c.sort_order }}</span>
            </div>
            <h3 class="text-sm font-semibold text-white">{{ c.title_en }} / {{ c.title_id }}</h3>
            <p class="text-xs text-gray-400 mt-1 line-clamp-2">{{ c.description_en }}</p>
          </div>
          <div class="flex gap-1.5 flex-shrink-0">
            <button @click="openForm(c)" class="p-1.5 rounded-lg bg-gray-800 hover:bg-violet-900/40 hover:text-violet-400 text-gray-500 transition-colors"><Pencil class="w-4 h-4" /></button>
            <button @click="deleteCard(c.id)" class="p-1.5 rounded-lg bg-gray-800 hover:bg-red-900/40 hover:text-red-400 text-gray-500 transition-colors"><Trash2 class="w-4 h-4" /></button>
          </div>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <Transition name="modal">
      <div v-if="showForm" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm" @click.self="showForm = false">
        <div class="bg-gray-900 border border-gray-800 rounded-2xl w-full max-w-lg shadow-2xl p-6 space-y-4">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-base font-bold text-white">{{ editingId ? 'Edit Kartu' : 'Tambah Kartu' }}</h3>
            <button @click="showForm = false" class="text-gray-500 hover:text-gray-300"><X class="w-5 h-5" /></button>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-xs text-gray-400 mb-1">Tipe Ikon</label>
              <select v-model="form.icon_type" class="input-base bg-gray-800 border-gray-700 text-white">
                <option value="code">code (Web Dev)</option>
                <option value="globe">globe (Network)</option>
                <option value="shield">shield (QA/Testing)</option>
                <option value="brain">brain (ML/AI)</option>
                <option value="cpu">cpu (Hardware)</option>
              </select>
            </div>
            <div>
              <label class="block text-xs text-gray-400 mb-1">Sort Order</label>
              <input v-model.number="form.sort_order" type="number" class="input-base bg-gray-800 border-gray-700 text-white" />
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-xs text-gray-400 mb-1">Judul (EN)</label>
              <input v-model="form.title_en" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
            </div>
            <div>
              <label class="block text-xs text-gray-400 mb-1">Judul (ID)</label>
              <input v-model="form.title_id" type="text" class="input-base bg-gray-800 border-gray-700 text-white" />
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-xs text-gray-400 mb-1">Deskripsi (EN)</label>
              <textarea v-model="form.description_en" rows="3" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
            </div>
            <div>
              <label class="block text-xs text-gray-400 mb-1">Deskripsi (ID)</label>
              <textarea v-model="form.description_id" rows="3" class="input-base bg-gray-800 border-gray-700 text-white resize-none" />
            </div>
          </div>
          <div class="flex gap-3 justify-end pt-2">
            <button @click="showForm = false" class="px-4 py-2 text-sm text-gray-400 hover:text-white">Batal</button>
            <button @click="saveCard" :disabled="isSaving" class="btn-admin">
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
import { ref, onMounted } from 'vue'
import { Plus, Pencil, Trash2, X, Save, Loader2 } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

const cards = ref([])
const isLoading = ref(true)
const showForm = ref(false)
const isSaving = ref(false)
const editingId = ref(null)
const defaultForm = () => ({ title_en: '', title_id: '', description_en: '', description_id: '', icon_type: 'code', sort_order: 0 })
const form = ref(defaultForm())

const load = async () => {
  const { data } = await supabase.from('about_cards').select('*').order('sort_order')
  cards.value = data ?? []
  isLoading.value = false
}

const openForm = (c = null) => {
  form.value = c ? { ...c } : defaultForm()
  editingId.value = c?.id ?? null
  showForm.value = true
}

const saveCard = async () => {
  isSaving.value = true
  const payload = { ...form.value }
  delete payload.id
  let err
  if (editingId.value) {
    const r = await supabase.from('about_cards').update(payload).eq('id', editingId.value)
    err = r.error
  } else {
    const r = await supabase.from('about_cards').insert(payload)
    err = r.error
  }
  if (!err) { showForm.value = false; load() }
  isSaving.value = false
}

const deleteCard = async (id) => {
  if (!confirm('Hapus kartu ini?')) return
  await supabase.from('about_cards').delete().eq('id', id)
  load()
}

onMounted(load)
</script>

<style scoped>
.modal-enter-active, .modal-leave-active { transition: all 0.3s cubic-bezier(0.22, 1, 0.36, 1); }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>
