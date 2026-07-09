<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-950 px-4">
    <div class="w-full max-w-sm">
      <div class="text-center mb-8">
        <div class="text-4xl font-black text-gradient mb-2">GP</div>
        <h1 class="text-xl font-bold text-white">Admin Portal</h1>
        <p class="text-sm text-gray-400 mt-1">Portfolio V2 Management</p>
      </div>

      <div class="bg-gray-900 border border-gray-800 rounded-2xl p-6 shadow-2xl">
        <form @submit.prevent="login" class="space-y-4">
          <div>
            <label class="block text-xs font-medium text-gray-400 mb-1.5">Email</label>
            <input v-model="form.email" type="email" required class="input-base bg-gray-800 border-gray-700 text-white focus:ring-violet-500 focus:border-violet-500" placeholder="admin@email.com" />
          </div>
          <div>
            <label class="block text-xs font-medium text-gray-400 mb-1.5">Password</label>
            <div class="relative">
              <input v-model="form.password" :type="showPw ? 'text' : 'password'" required class="input-base bg-gray-800 border-gray-700 text-white focus:ring-violet-500 focus:border-violet-500 pr-10" placeholder="••••••••" />
              <button type="button" @click="showPw = !showPw" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-300">
                <Eye v-if="!showPw" class="w-4 h-4" />
                <EyeOff v-else class="w-4 h-4" />
              </button>
            </div>
          </div>

          <p v-if="error" class="text-xs text-red-400 bg-red-900/20 border border-red-800/50 rounded-lg px-3 py-2">{{ error }}</p>

          <button type="submit" :disabled="isLoading" class="w-full py-2.5 bg-gradient-to-r from-violet-600 to-indigo-600 hover:from-violet-700 hover:to-indigo-700 disabled:opacity-50 text-white font-semibold rounded-xl transition-all duration-300 flex items-center justify-center gap-2">
            <Loader2 v-if="isLoading" class="w-4 h-4 animate-spin" />
            <Lock v-else class="w-4 h-4" />
            {{ isLoading ? 'Logging in...' : 'Login' }}
          </button>
        </form>
      </div>

      <p class="text-center text-xs text-gray-600 mt-6">
        <RouterLink to="/" class="text-gray-500 hover:text-gray-400 transition-colors">← Back to Portfolio</RouterLink>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Eye, EyeOff, Loader2, Lock } from 'lucide-vue-next'
import { supabase } from '@/lib/supabase'

const router = useRouter()
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
    error.value = 'Email atau password salah. Coba lagi.'
  } else {
    router.push('/admin/dashboard')
  }
  isLoading.value = false
}
</script>
