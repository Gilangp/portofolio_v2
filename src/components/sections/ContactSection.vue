<template>
  <section id="contact" class="py-20 px-4 sm:px-6 lg:px-8 bg-gray-50 dark:bg-gray-950 transition-colors duration-500 relative overflow-hidden">
    <div class="orb top-1/4 left-10 w-60 h-60 bg-blue-500/5" />
    <div class="orb bottom-1/4 right-10 w-72 h-72 bg-purple-500/5" />

    <div class="max-w-6xl mx-auto relative z-10">
      <div class="text-center mb-12">
        <h2 class="section-title">{{ t("Let's Connect", 'Mari Terhubung') }}</h2>
        <span class="inline-block w-16 h-1 bg-gradient-to-r from-blue-400 to-purple-500 rounded-full mt-2" />
        <p class="mt-4 text-gray-500 dark:text-gray-400 text-sm">
          {{ t("Have a project in mind? Let's bring your ideas to life.", 'Punya proyek atau ide? Mari terhubung dan wujudkan bersama.') }}
        </p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-5 gap-6">
        <!-- Contact Form -->
        <div class="lg:col-span-3 card-base p-6 hover:shadow-xl">
          <h3 class="text-base font-semibold text-gray-800 dark:text-white mb-5 flex items-center gap-2">
            <MessageSquare class="w-5 h-5 text-blue-500" />
            {{ t('Send Me a Message', 'Kirim Pesan') }}
          </h3>
          <form @submit.prevent="submitForm" class="space-y-4">
            <div>
              <label class="block text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">{{ t('Your Name *', 'Nama Anda *') }}</label>
              <input v-model="form.name" type="text" required minlength="2" class="input-base" :placeholder="t('Enter your name', 'Masukkan nama Anda')" />
              <p v-if="errors.name" class="text-xs text-red-500 mt-1">{{ errors.name }}</p>
            </div>
            <div>
              <label class="block text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">{{ t('Email Address *', 'Alamat Email *') }}</label>
              <input v-model="form.email" type="email" required class="input-base" placeholder="your@email.com" @blur="validateEmail" />
              <p v-if="errors.email" class="text-xs text-red-500 mt-1">{{ errors.email }}</p>
            </div>
            <div>
              <label class="block text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">{{ t('Your Message *', 'Pesan Anda *') }}</label>
              <textarea v-model="form.message" rows="4" required minlength="10" class="input-base resize-none" :placeholder="t('Tell me about your project...', 'Ceritakan tentang proyek Anda...')" />
              <p v-if="errors.message" class="text-xs text-red-500 mt-1">{{ errors.message }}</p>
            </div>
            <button type="submit" :disabled="isSubmitting || !isFormValid" class="btn-primary w-full justify-center disabled:opacity-50 disabled:cursor-not-allowed">
              <span v-if="!isSubmitting" class="flex items-center gap-2">
                <Send class="w-4 h-4" /> {{ t('Send Message', 'Kirim Pesan') }}
              </span>
              <span v-else class="flex items-center gap-2">
                <Loader2 class="w-4 h-4 animate-spin" /> {{ t('Sending...', 'Mengirim...') }}
              </span>
            </button>
          </form>
        </div>

        <!-- Contact Info -->
        <div class="lg:col-span-2 space-y-4">
          <div class="card-base p-5 hover:shadow-xl">
            <h3 class="text-base font-semibold text-gray-800 dark:text-white mb-4 flex items-center gap-2">
              <Phone class="w-5 h-5 text-blue-500" />
              {{ t('Contact Information', 'Informasi Kontak') }}
            </h3>
            <div class="space-y-3">
              <div class="flex items-center gap-3 text-sm">
                <div class="p-1.5 bg-blue-100 dark:bg-blue-900/30 rounded-lg text-blue-500"><Mail class="w-4 h-4" /></div>
                <a :href="`mailto:${settings?.contact_email}`" class="text-blue-500 hover:text-blue-600 text-xs font-medium">
                  {{ settings?.contact_email ?? 'gilangpurnomo0505@gmail.com' }}
                </a>
              </div>
              <div class="flex items-center gap-3 text-sm">
                <div class="p-1.5 bg-blue-100 dark:bg-blue-900/30 rounded-lg text-blue-500"><MapPin class="w-4 h-4" /></div>
                <span class="text-gray-700 dark:text-gray-300 text-xs">{{ settings?.contact_location ?? 'Malang, Indonesia' }}</span>
              </div>
              <div class="flex items-center gap-3 text-sm">
                <div class="p-1.5 bg-blue-100 dark:bg-blue-900/30 rounded-lg text-blue-500"><Clock class="w-4 h-4" /></div>
                <span class="text-gray-700 dark:text-gray-300 text-xs">
                  {{ currentLang === 'en' ? (settings?.contact_response_en ?? 'Same day - 24 hours') : (settings?.contact_response_id ?? 'Hari yang sama - 24 jam') }}
                </span>
              </div>
            </div>
          </div>

          <!-- Social -->
          <div class="card-base p-5 hover:shadow-xl">
            <h3 class="text-base font-semibold text-gray-800 dark:text-white mb-4 flex items-center gap-2">
              <Globe class="w-5 h-5 text-blue-500" />
              {{ t('Follow Me', 'Ikuti Saya') }}
            </h3>
            <div class="grid grid-cols-2 gap-2">
              <a v-if="settings?.social_github" :href="settings.social_github" target="_blank" class="flex items-center gap-2 p-2.5 rounded-lg bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors text-xs font-medium text-gray-700 dark:text-gray-300">
                <Github class="w-4 h-4" /> GitHub
              </a>
              <a v-if="settings?.social_linkedin" :href="settings.social_linkedin" target="_blank" class="flex items-center gap-2 p-2.5 rounded-lg bg-gray-50 dark:bg-gray-700 hover:bg-blue-50 dark:hover:bg-blue-900/30 transition-colors text-xs font-medium text-gray-700 dark:text-gray-300">
                <Linkedin class="w-4 h-4 text-blue-600" /> LinkedIn
              </a>
              <a v-if="settings?.social_instagram" :href="settings.social_instagram" target="_blank" class="flex items-center gap-2 p-2.5 rounded-lg bg-gray-50 dark:bg-gray-700 hover:bg-pink-50 dark:hover:bg-pink-900/20 transition-colors text-xs font-medium text-gray-700 dark:text-gray-300">
                <Instagram class="w-4 h-4 text-pink-500" /> Instagram
              </a>
              <a v-if="settings?.social_tiktok" :href="settings.social_tiktok" target="_blank" class="flex items-center gap-2 p-2.5 rounded-lg bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors text-xs font-medium text-gray-700 dark:text-gray-300">
                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="currentColor"><path d="M12.525.02c1.31-.02 2.61-.01 3.91-.02.08 1.53.63 3.09 1.75 4.17 1.12 1.11 2.7 1.62 4.24 1.79v4.03c-1.44-.05-2.89-.35-4.2-.97-.57-.26-1.1-.59-1.62-.93-.01 2.92.01 5.84-.02 8.75-.08 1.4-.54 2.79-1.35 3.94-1.31 1.92-3.58 3.17-5.91 3.21-1.43.08-2.86-.31-4.08-1.03-2.02-1.19-3.44-3.37-3.65-5.71-.02-.5-.03-1-.01-1.49.18-1.9 1.12-3.72 2.58-4.96 1.66-1.44 3.98-2.13 6.15-1.72.02 1.48-.04 2.96-.04 4.44-.99-.32-2.15-.23-3.02.37-.63.41-1.11 1.04-1.36 1.75-.21.51-.15 1.07-.14 1.61.24 1.64 1.82 3.02 3.5 2.87 1.12-.01 2.19-.66 2.77-1.61.19-.33.4-.67.41-1.06.1-1.79.06-3.57.07-5.36.01-4.03-.01-8.05.02-12.07z"/></svg>
                TikTok
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast -->
    <Transition name="toast">
      <div v-if="toast.show" class="fixed bottom-6 right-6 z-50 px-5 py-3 rounded-xl shadow-2xl text-white text-sm font-medium flex items-center gap-2"
           :class="toast.type === 'success' ? 'bg-gradient-to-r from-green-500 to-emerald-500' : 'bg-gradient-to-r from-red-500 to-rose-500'">
        <CheckCircle v-if="toast.type === 'success'" class="w-4 h-4" />
        <XCircle v-else class="w-4 h-4" />
        {{ toast.message }}
      </div>
    </Transition>
  </section>
</template>

<script setup>
import { ref, computed } from 'vue'
import emailjs from 'emailjs-com'
import { MessageSquare, Send, Loader2, Phone, Mail, MapPin, Clock, Globe, Github, Linkedin, Instagram, CheckCircle, XCircle } from 'lucide-vue-next'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()

const form = ref({ name: '', email: '', message: '' })
const errors = ref({ name: '', email: '', message: '' })
const isSubmitting = ref(false)
const toast = ref({ show: false, type: 'success', message: '' })

const showToast = (type, message) => {
  toast.value = { show: true, type, message }
  setTimeout(() => (toast.value.show = false), 4000)
}

const validateEmail = () => {
  const email = form.value.email.trim()
  errors.value.email = ''
  if (!email) return (errors.value.email = t('Email is required', 'Email wajib diisi'))
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return (errors.value.email = t('Invalid email format', 'Format email tidak valid'))
}

const isFormValid = computed(() =>
  form.value.name.trim().length >= 2 && form.value.email.trim().length > 0 && form.value.message.trim().length >= 10 && !errors.value.email
)

const submitForm = async () => {
  validateEmail()
  if (!isFormValid.value) return showToast('error', t('Please fill all fields correctly.', 'Mohon isi semua kolom dengan benar.'))
  isSubmitting.value = true
  try {
    await emailjs.send(
      import.meta.env.VITE_EMAILJS_SERVICE_ID,
      import.meta.env.VITE_EMAILJS_TEMPLATE_ID,
      { from_name: form.value.name, from_email: form.value.email, message: form.value.message, to_email: settings.value?.contact_email ?? 'gilangpurnomo0505@gmail.com', reply_to: form.value.email },
      import.meta.env.VITE_EMAILJS_PUBLIC_KEY
    )
    form.value = { name: '', email: '', message: '' }
    showToast('success', t('Message sent successfully! 🎉', 'Pesan berhasil terkirim! 🎉'))
  } catch {
    showToast('error', t('Failed to send. Please try again.', 'Gagal mengirim pesan. Coba lagi.'))
  } finally {
    isSubmitting.value = false
  }
}
</script>
