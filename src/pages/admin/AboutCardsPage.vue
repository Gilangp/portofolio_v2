<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-xl font-bold text-slate-100">Manajemen Kartu Fokus (About Cards)</h2>
        <p class="text-sm text-slate-400 mt-1">{{ cards.length }} kartu tersimpan (tampil di grid halaman About Me)</p>
      </div>
      <button @click="openForm()" class="btn-admin"><Plus class="w-4 h-4" /> Tambah Kartu Baru</button>
    </div>

    <div v-if="isLoading" class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <div v-for="i in 4" :key="i" class="skeleton h-32 rounded-2xl" />
    </div>
    <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <div v-for="c in cards" :key="c.id"
        class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-5 hover:border-slate-700 transition-colors shadow-sm">
        <div class="flex items-start justify-between gap-4">
          <div class="flex-1">
            <div class="flex items-center gap-2 mb-3">
              <span class="px-2.5 py-1 bg-blue-500/10 text-blue-400 border border-blue-500/20 text-xs font-mono font-medium rounded-lg flex items-center gap-1.5">
                <DynamicIcon :name="c.icon_type" class-name="w-3.5 h-3.5" />
                {{ c.icon_type }}
              </span>
              <span class="text-xs text-slate-500 font-medium">urutan: #{{ c.sort_order }}</span>
            </div>
            <h3 class="text-sm font-bold text-slate-100">{{ c.title_en }} / {{ c.title_id }}</h3>
            <p class="text-xs text-slate-400 mt-1.5 line-clamp-2 leading-relaxed">{{ c.description_en }}</p>
          </div>
          <div class="flex gap-1.5 flex-shrink-0">
            <button @click="openForm(c)" class="p-2 rounded-xl bg-slate-800 hover:bg-blue-600/20 hover:text-blue-400 text-slate-400 transition-colors border border-slate-700/60" title="Edit"><Pencil class="w-4 h-4" /></button>
            <button @click="deleteCard(c.id)" class="p-2 rounded-xl bg-slate-800 hover:bg-rose-600/20 hover:text-rose-400 text-slate-400 transition-colors border border-slate-700/60" title="Hapus"><Trash2 class="w-4 h-4" /></button>
          </div>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <Transition name="modal">
      <div v-if="showForm" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm" @click.self="showForm = false">
        <div class="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-lg shadow-2xl p-6 space-y-4">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-base font-bold text-slate-100">{{ editingId ? 'Edit Kartu Fokus' : 'Tambah Kartu Baru' }}</h3>
            <button @click="showForm = false" class="text-slate-500 hover:text-slate-300"><X class="w-5 h-5" /></button>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <div class="flex items-center justify-between mb-1.5">
                <label class="block text-xs font-semibold text-slate-400">Tipe Ikon</label>
                <div class="flex items-center gap-1.5 px-2 py-0.5 rounded bg-blue-500/10 text-blue-400 border border-blue-500/20 text-[11px] font-mono">
                  <DynamicIcon :name="form.icon_type" class-name="w-3.5 h-3.5" />
                  <span>Preview: {{ form.icon_type || 'code' }}</span>
                </div>
              </div>
              <select v-model="form.icon_type" class="input-admin mb-2">
                <option value="code">code / Code2 (Web Dev)</option>
                <option value="globe">globe / Globe (Network / Web)</option>
                <option value="shield">shield / ShieldCheck (QA / Security)</option>
                <option value="brain">brain / BrainCircuit (AI / ML)</option>
                <option value="cpu">cpu / Cpu (Hardware / IoT)</option>
                <option value="server">server / Server (Backend / API)</option>
                <option value="database">database / Database (SQL / NoSQL)</option>
                <option value="smartphone">smartphone / Smartphone (Mobile Dev)</option>
                <option value="cloud">cloud / Cloud (DevOps / AWS)</option>
                <option value="terminal">terminal / Terminal (CLI / System)</option>
                <option value="lock">lock / Lock (Cybersecurity)</option>
                <option value="wifi">wifi / Wifi (Networking / Wireless)</option>
                <option value="layers">layers / Layers (Architecture)</option>
                <option value="monitor">monitor / Monitor (Desktop App)</option>
                <option value="layout">layout / Layout (UI/UX Design)</option>
                <option value="filecode">filecode / FileCode (Scripting)</option>
                <option value="git">git / GitBranch (Version Control)</option>
                <option value="wrench">wrench / Wrench (Maintenance / Tools)</option>
                <option value="sparkles">sparkles / Sparkles (Special Features)</option>
                <option value="boxes">boxes / Boxes (Modules / Microservices)</option>
                <option value="workflow">workflow / Workflow (CI/CD Pipeline)</option>
              </select>
              <input
                v-model="form.icon_type"
                type="text"
                class="input-admin text-xs font-mono"
                placeholder="Atau ketik nama ikon Lucide persis (contoh: TerminalSquare)"
              />
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Urutan (Sort Order)</label>
              <input v-model.number="form.sort_order" type="number" class="input-admin" />
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul (English)</label>
              <input v-model="form.title_en" type="text" class="input-admin" placeholder="Web Development" />
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Judul (Indonesia)</label>
              <input v-model="form.title_id" type="text" class="input-admin" placeholder="Pengembangan Web" />
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi (English)</label>
              <textarea v-model="form.description_en" rows="3" class="input-admin resize-none" placeholder="Building responsive web..." />
            </div>
            <div>
              <label class="block text-xs font-semibold text-slate-400 mb-1.5">Deskripsi (Indonesia)</label>
              <textarea v-model="form.description_id" rows="3" class="input-admin resize-none" placeholder="Membangun web responsif..." />
            </div>
          </div>
          <div class="flex gap-3 justify-end pt-3">
            <button @click="showForm = false" class="px-4 py-2 text-sm text-slate-400 hover:text-white transition-colors">Batal</button>
            <button @click="saveCard" :disabled="isSaving" class="btn-admin">
              <Loader2 v-if="isSaving" class="w-4 h-4 animate-spin" />
              <Save v-else class="w-4 h-4" />
              Simpan Kartu
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
import DynamicIcon from '@/components/common/DynamicIcon.vue'

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
.modal-enter-active, .modal-leave-active { transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
.modal-enter-from, .modal-leave-to { opacity: 0; }
</style>
