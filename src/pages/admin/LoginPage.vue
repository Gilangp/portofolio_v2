<template>
  <div class="min-h-screen flex items-center justify-center bg-[#090d16] px-4 relative overflow-hidden">
    <div class="absolute -top-32 -left-32 w-96 h-96 bg-blue-600/10 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute -bottom-32 -right-32 w-96 h-96 bg-purple-600/10 rounded-full blur-3xl pointer-events-none"></div>

    <div class="w-full max-w-md relative z-10">
      <!-- Dynamic Header -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-gradient-to-tr from-blue-600 to-indigo-600 shadow-lg shadow-blue-500/20 mb-4 overflow-hidden p-2">
          <img v-if="settings?.site_logo_url" :src="settings.site_logo_url" :alt="settings?.site_logo_text || 'Logo'" class="w-full h-full object-contain" />
          <span v-else class="text-2xl font-black text-white">{{ settings?.site_logo_text || 'GP' }}</span>
        </div>
        <h1 class="text-2xl font-bold text-slate-100 tracking-tight">Admin Portal</h1>
        <p class="text-sm text-slate-400 mt-1.5">Kelola seluruh konten portofolio Anda secara real-time</p>
      </div>

      <!-- Card -->
      <div class="bg-slate-900/80 border border-slate-800/80 rounded-2xl p-7 shadow-2xl backdrop-blur-xl">
        <form @submit.prevent="login" class="space-y-5">
          <div>
            <label class="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-2">Alamat Email</label>
            <input
              v-model="form.email"
              type="email"
              required
              class="input-admin"
              placeholder="admin@email.com"
            />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-2">Kata Sandi (Password)</label>
            <div class="relative">
              <input
                v-model="form.password"
                :type="showPw ? 'text' : 'password'"
                required
                class="input-admin pr-11"
                placeholder="••••••••"
              />
              <button
                type="button"
                @click="showPw = !showPw"
                class="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300 transition-colors focus:outline-none"
              >
                <Eye v-if="!showPw" class="w-4 h-4" />
                <EyeOff v-else class="w-4 h-4" />
              </button>
            </div>
          </div>

          <!-- Error Message -->
          <div v-if="error" class="flex items-center gap-2.5 text-xs text-rose-300 bg-rose-500/10 border border-rose-500/20 rounded-xl p-3.5">
            <AlertCircle class="w-4 h-4 flex-shrink-0 text-rose-400" />
            <span>{{ error }}</span>
          </div>

          <button
            type="submit"
            :disabled="isLoading"
            class="w-full py-3 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 disabled:opacity-50 text-white font-semibold text-sm rounded-xl transition-all duration-200 shadow-lg shadow-blue-500/20 flex items-center justify-center gap-2"
          >
            <Loader2 v-if="isLoading" class="w-4 h-4 animate-spin" />
            <Lock v-else class="w-4 h-4" />
            {{ isLoading ? 'Memverifikasi...' : 'Masuk ke Admin Panel' }}
          </button>
        </form>
      </div>

      <!-- Footer link -->
      <div class="text-center mt-6">
        <RouterLink to="/" class="inline-flex items-center gap-1.5 text-xs text-slate-500 hover:text-slate-300 transition-colors font-medium">
          ← Kembali ke Halaman Portofolio
        </RouterLink>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Eye, EyeOff, Loader2, Lock, AlertCircle } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'
import useSiteSettings from '@/composables/useSiteSettings'

const router = useRouter()
const { settings } = useSiteSettings()
const form = ref({ email: '', password: '' })
const isLoading = ref(false)
const showPw = ref(false)
const error = ref('')

const login = async () => {
  isLoading.value = true
  error.value = ''
  const { error: err } = await supabase.auth.signInWithPassword({
    email: form.value.email,
    password: form.value.password
  })
  if (err) {
    error.value = 'Email atau password salah. Coba periksa kembali.'
  } else {
    router.push('/admin/dashboard')
  }
  isLoading.value = false
}
</script>
