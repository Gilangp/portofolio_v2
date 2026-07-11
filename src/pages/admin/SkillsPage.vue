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
        class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-3.5 flex items-center gap-3.5 group hover:border-slate-700 transition-all shadow-sm"
        :class="{ 'opacity-50 border-dashed bg-slate-950/40': !(s.is_visible ?? true) }">
        <div class="w-10 h-10 rounded-xl bg-slate-950/60 border border-slate-800 flex items-center justify-center p-1.5 flex-shrink-0 relative">
          <img :src="s.icon_url" :alt="s.name" class="w-full h-full object-contain" loading="lazy" />
        </div>
        <div class="flex-1 min-w-0">
          <div class="flex items-center gap-1.5">
            <span class="text-sm text-slate-200 font-semibold truncate">{{ s.name }}</span>
            <span v-if="!(s.is_visible ?? true)" class="px-1.5 py-0.5 text-[9px] rounded bg-rose-500/10 text-rose-400 border border-rose-500/20 font-bold">Hidden</span>
          </div>
        </div>
        <div class="flex gap-1 opacity-90 group-hover:opacity-100 transition-opacity">
          <button @click="toggleVisibility(s)" class="p-1.5 rounded-lg transition-colors"
            :class="(s.is_visible ?? true) ? 'text-emerald-400 hover:bg-amber-600/20 hover:text-amber-400' : 'text-rose-400 hover:bg-emerald-600/20 hover:text-emerald-400'"
            :title="(s.is_visible ?? true) ? 'Sembunyikan Skill' : 'Tampilkan Skill'">
            <Eye v-if="s.is_visible ?? true" class="w-3.5 h-3.5" />
            <EyeOff v-else class="w-3.5 h-3.5" />
          </button>
          <button @click="openForm(s)" class="p-1.5 rounded-lg text-slate-400 hover:text-blue-400 hover:bg-slate-800" title="Edit"><Pencil class="w-3.5 h-3.5" /></button>
          <button @click="deleteSkill(s.id)" class="p-1.5 rounded-lg text-slate-400 hover:text-rose-400 hover:bg-slate-800" title="Hapus"><Trash2 class="w-3.5 h-3.5" /></button>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <Transition name="modal">
      <div v-if="showForm" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm" @click.self="showForm = false">
        <div class="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-lg shadow-2xl p-6 space-y-4 max-h-[90vh] overflow-y-auto custom-scrollbar">
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

            <!-- Preset Icon Library Picker -->
            <div class="mt-3 border border-slate-800 rounded-xl p-3 bg-slate-950/60 shadow-inner">
              <div class="flex items-center justify-between mb-2">
                <span class="text-xs font-bold text-slate-300 flex items-center gap-1.5">
                  <Bookmark class="w-3.5 h-3.5 text-blue-400" />
                  Library Preset Logo ({{ presetIcons.length }} Logo)
                </span>
                <button type="button" @click="showPresetPicker = !showPresetPicker" class="text-xs text-blue-400 hover:text-blue-300 font-semibold px-2 py-0.5 rounded bg-blue-950/40 border border-blue-800/40 transition-colors">
                  {{ showPresetPicker ? 'Tutup Library' : 'Buka Library Logo' }}
                </button>
              </div>
              
              <div v-if="showPresetPicker" class="mt-2.5 space-y-2.5 animate-fade-in">
                <input v-model="presetSearch" type="text" placeholder="Cari logo (misal: Next, OpenAI, Cisco, Laravel...)" class="w-full px-3 py-1.5 text-xs bg-slate-900 border border-slate-800 rounded-lg text-slate-200 focus:outline-none focus:border-blue-500 transition-colors" />
                <div class="grid grid-cols-4 sm:grid-cols-5 gap-2 max-h-56 overflow-y-auto pr-1 py-1 custom-scrollbar">
                  <button
                    v-for="preset in filteredPresetIcons"
                    :key="preset.name"
                    type="button"
                    @click="selectPresetIcon(preset)"
                    class="flex flex-col items-center justify-center p-2 rounded-xl border transition-all duration-200 group relative"
                    :class="form.icon_url === preset.url ? 'bg-blue-600/20 border-blue-500 text-white shadow-md shadow-blue-500/10' : 'bg-slate-900/80 border-slate-800/80 text-slate-400 hover:border-slate-600 hover:text-slate-200 hover:bg-slate-800/60'"
                    :title="`Pilih logo ${preset.name}`"
                  >
                    <img :src="preset.url" :alt="preset.name" class="w-7 h-7 object-contain mb-1 transition-transform group-hover:scale-110" loading="lazy" />
                    <span class="text-[10px] truncate w-full text-center font-medium">{{ preset.name }}</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-400 mb-1.5">Urutan (Sort Order)</label>
            <input v-model.number="form.sort_order" type="number" class="input-admin" />
          </div>
          <div class="p-3.5 rounded-xl bg-slate-950/60 border border-slate-800/80 flex items-center justify-between">
            <div>
              <label class="text-xs font-bold text-slate-200 block">Tampilkan di Website</label>
              <p class="text-[11px] text-slate-400 mt-0.5">Atur apakah skill ini dimunculkan atau disembunyikan.</p>
            </div>
            <label class="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" v-model="form.is_visible" class="sr-only peer">
              <div class="w-10 h-5 bg-slate-700 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-blue-600"></div>
            </label>
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
import { Plus, Pencil, Trash2, X, Save, Loader2, Eye, EyeOff, Bookmark } from 'lucide-vue-next'
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
const defaultForm = () => ({ name: '', category: 'development', icon_url: '', sort_order: 0, is_visible: true })
const form = ref(defaultForm())

const showPresetPicker = ref(false)
const presetSearch = ref('')

const presetIcons = [
  // Web & Frontend Frameworks
  { name: 'Next.js', url: 'https://cdn.simpleicons.org/nextdotjs' },
  { name: 'Vue.js', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vuejs/vuejs-original.svg' },
  { name: 'React', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original.svg' },
  { name: 'Angular', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/angular/angular-original.svg' },
  { name: 'Svelte', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/svelte/svelte-original.svg' },
  { name: 'Nuxt', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nuxtjs/nuxtjs-original.svg' },
  { name: 'Gatsby', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/gatsby/gatsby-original.svg' },
  { name: 'Astro', url: 'https://cdn.simpleicons.org/astro' },
  { name: 'Alpine.js', url: 'https://cdn.simpleicons.org/alpinedotjs' },
  { name: 'Tailwind CSS', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tailwindcss/tailwindcss-original.svg' },
  { name: 'Bootstrap', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/bootstrap/bootstrap-original.svg' },
  { name: 'Sass', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sass/sass-original.svg' },
  { name: 'Less', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/less/less-plain-wordmark.svg' },
  { name: 'Material UI', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/materialui/materialui-original.svg' },
  { name: 'Three.js', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/threejs/threejs-original.svg' },
  { name: 'jQuery', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jquery/jquery-original.svg' },

  // Languages
  { name: 'JavaScript', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg' },
  { name: 'TypeScript', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/typescript/typescript-original.svg' },
  { name: 'PHP', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/php/php-original.svg' },
  { name: 'Python', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg' },
  { name: 'HTML5', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg' },
  { name: 'CSS3', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg' },
  { name: 'Java', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg' },
  { name: 'C++', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/cplusplus/cplusplus-original.svg' },
  { name: 'C#', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/csharp/csharp-original.svg' },
  { name: 'C', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/c/c-original.svg' },
  { name: 'Go', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/go/go-original.svg' },
  { name: 'Rust', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/rust/rust-original.svg' },
  { name: 'Ruby', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ruby/ruby-original.svg' },
  { name: 'Swift', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/swift/swift-original.svg' },
  { name: 'Kotlin', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kotlin/kotlin-original.svg' },
  { name: 'Dart', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg' },
  { name: 'Scala', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/scala/scala-original.svg' },
  { name: 'Elixir', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/elixir/elixir-original.svg' },
  { name: 'Haskell', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/haskell/haskell-original.svg' },
  { name: 'Lua', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/lua/lua-original.svg' },
  { name: 'R', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/r/r-original.svg' },
  { name: 'Bash', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/bash/bash-original.svg' },

  // Backend & Runtimes
  { name: 'Laravel', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/laravel/laravel-original.svg' },
  { name: 'Node.js', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nodejs/nodejs-original.svg' },
  { name: 'Express', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/express/express-original.svg' },
  { name: 'NestJS', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nestjs/nestjs-original.svg' },
  { name: 'Fastify', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/fastify/fastify-original.svg' },
  { name: 'Deno', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/denojs/denojs-original.svg' },
  { name: 'Bun', url: 'https://cdn.simpleicons.org/bun' },
  { name: 'Django', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/django/django-plain.svg' },
  { name: 'Flask', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flask/flask-original.svg' },
  { name: 'FastAPI', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/fastapi/fastapi-original.svg' },
  { name: 'Spring Boot', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/spring/spring-original.svg' },
  { name: 'Ruby on Rails', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/rails/rails-original-wordmark.svg' },
  { name: 'ASP.NET', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dotnetcore/dotnetcore-original.svg' },
  { name: 'Symfony', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/symfony/symfony-original.svg' },
  { name: 'CodeIgniter', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/codeigniter/codeigniter-plain.svg' },

  // Databases & ORMs
  { name: 'MySQL', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg' },
  { name: 'PostgreSQL', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg' },
  { name: 'Supabase', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/supabase/supabase-original.svg' },
  { name: 'MongoDB', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mongodb/mongodb-original.svg' },
  { name: 'SQLite', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sqlite/sqlite-original.svg' },
  { name: 'Redis', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg' },
  { name: 'Firebase', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg' },
  { name: 'Appwrite', url: 'https://cdn.simpleicons.org/appwrite' },
  { name: 'Oracle', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/oracle/oracle-original.svg' },
  { name: 'Microsoft SQL Server', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/microsoftsqlserver/microsoftsqlserver-plain.svg' },
  { name: 'Prisma', url: 'https://cdn.simpleicons.org/prisma' },
  { name: 'Sequelize', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sequelize/sequelize-original.svg' },

  // Network, OS & Linux
  { name: 'Cisco', url: 'https://cdn.simpleicons.org/cisco' },
  { name: 'MikroTik', url: 'https://cdn.simpleicons.org/mikrotik' },
  { name: 'Linux', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg' },
  { name: 'Ubuntu', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ubuntu/ubuntu-plain.svg' },
  { name: 'Debian', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/debian/debian-original.svg' },
  { name: 'CentOS', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/centos/centos-original.svg' },
  { name: 'Arch Linux', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/archlinux/archlinux-original.svg' },
  { name: 'Kali Linux', url: 'https://cdn.simpleicons.org/kalilinux' },
  { name: 'Red Hat', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redhat/redhat-original.svg' },
  { name: 'Wireshark', url: 'https://cdn.simpleicons.org/wireshark' },
  { name: 'OpenVPN', url: 'https://cdn.simpleicons.org/openvpn' },

  // DevOps, Cloud & Tools
  { name: 'Docker', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg' },
  { name: 'Kubernetes', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kubernetes/kubernetes-plain.svg' },
  { name: 'AWS', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-original-wordmark.svg' },
  { name: 'Google Cloud', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/googlecloud/googlecloud-original.svg' },
  { name: 'Azure', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg' },
  { name: 'DigitalOcean', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/digitalocean/digitalocean-original.svg' },
  { name: 'Heroku', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/heroku/heroku-original.svg' },
  { name: 'Vercel', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vercel/vercel-original.svg' },
  { name: 'Netlify', url: 'https://cdn.simpleicons.org/netlify' },
  { name: 'Cloudflare', url: 'https://cdn.simpleicons.org/cloudflare' },
  { name: 'Nginx', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nginx/nginx-original.svg' },
  { name: 'Apache', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/apache/apache-original.svg' },
  { name: 'Terraform', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg' },
  { name: 'Ansible', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ansible/ansible-original.svg' },
  { name: 'Jenkins', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jenkins/jenkins-original.svg' },
  { name: 'GitHub Actions', url: 'https://cdn.simpleicons.org/githubactions' },

  // QA, Testing & API
  { name: 'Playwright', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/playwright/playwright-original.svg' },
  { name: 'Cypress', url: 'https://cdn.simpleicons.org/cypress' },
  { name: 'Selenium', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/selenium/selenium-original.svg' },
  { name: 'Puppeteer', url: 'https://cdn.simpleicons.org/puppeteer' },
  { name: 'k6', url: 'https://cdn.simpleicons.org/k6' },
  { name: 'Jest', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jest/jest-plain.svg' },
  { name: 'Mocha', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mocha/mocha-plain.svg' },
  { name: 'Vitest', url: 'https://cdn.simpleicons.org/vitest' },
  { name: 'PyTest', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/pytest/pytest-original.svg' },
  { name: 'Postman', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postman/postman-original.svg' },
  { name: 'Insomnia', url: 'https://cdn.simpleicons.org/insomnia' },
  { name: 'Swagger', url: 'https://cdn.simpleicons.org/swagger' },
  { name: 'Grafana', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/grafana/grafana-original.svg' },
  { name: 'Prometheus', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/prometheus/prometheus-original.svg' },
  { name: 'Sentry', url: 'https://cdn.simpleicons.org/sentry' },

  // AI, Data Science & Mobile
  { name: 'OpenAI', url: '/icons/openai.svg' },
  { name: 'PyTorch', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/pytorch/pytorch-original.svg' },
  { name: 'TensorFlow', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tensorflow/tensorflow-original.svg' },
  { name: 'Scikit-learn', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/scikitlearn/scikitlearn-original.svg' },
  { name: 'Pandas', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/pandas/pandas-original.svg' },
  { name: 'NumPy', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/numpy/numpy-original.svg' },
  { name: 'Jupyter', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jupyter/jupyter-original.svg' },
  { name: 'Hugging Face', url: 'https://cdn.simpleicons.org/huggingface' },
  { name: 'Android', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/android/android-original.svg' },
  { name: 'iOS', url: 'https://cdn.simpleicons.org/ios' },
  { name: 'Flutter', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg' },
  { name: 'React Native', url: 'https://cdn.simpleicons.org/react' },
  { name: 'Ionic', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ionic/ionic-original.svg' },
  { name: 'Electron', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/electron/electron-original.svg' },
  { name: 'Tauri', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tauri/tauri-original.svg' },
  { name: 'Unity', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/unity/unity-original.svg' },
  { name: 'Unreal Engine', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/unrealengine/unrealengine-original.svg' },

  // Design, Productivity & Tools
  { name: 'Figma', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/figma/figma-original.svg' },
  { name: 'Photoshop', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/photoshop/photoshop-original.svg' },
  { name: 'Illustrator', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/illustrator/illustrator-plain.svg' },
  { name: 'Canva', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/canva/canva-original.svg' },
  { name: 'Git', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg' },
  { name: 'GitHub', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg' },
  { name: 'GitLab', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/gitlab/gitlab-original.svg' },
  { name: 'Bitbucket', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/bitbucket/bitbucket-original.svg' },
  { name: 'Vite', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vitejs/vitejs-original.svg' },
  { name: 'Webpack', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/webpack/webpack-original.svg' },
  { name: 'Notion', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/notion/notion-original.svg' },
  { name: 'Jira', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jira/jira-original.svg' },
  { name: 'Trello', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/trello/trello-plain.svg' },
  { name: 'Slack', url: 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/slack/slack-original.svg' },
  { name: 'Discord', url: 'https://cdn.simpleicons.org/discord' },
]

const filteredPresetIcons = computed(() => {
  if (!presetSearch.value.trim()) return presetIcons
  const q = presetSearch.value.toLowerCase()
  return presetIcons.filter(p => p.name.toLowerCase().includes(q))
})

const selectPresetIcon = (preset) => {
  form.value.icon_url = preset.url
  if (!form.value.name) {
    form.value.name = preset.name
  }
}

const load = async () => {
  const { data } = await supabase.from('skills').select('*').order('sort_order')
  skills.value = data ?? []
  isLoading.value = false
}

const openForm = (s = null) => {
  form.value = s ? { ...s } : defaultForm()
  editingId.value = s?.id ?? null
  showPresetPicker.value = !s // Buka library preset otomatis jika tambah skill baru
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

const toggleVisibility = async (s) => {
  const newStatus = !(s.is_visible ?? true)
  const { error } = await supabase.from('skills').update({ is_visible: newStatus }).eq('id', s.id)
  if (!error) {
    s.is_visible = newStatus
  } else {
    alert('Gagal mengubah visibilitas skill. Pastikan kolom is_visible sudah ditambahkan ke database Supabase Anda.')
  }
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
