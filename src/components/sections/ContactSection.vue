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

          <!-- Dynamic Social -->
          <div class="card-base p-5 hover:shadow-xl">
            <h3 class="text-base font-semibold text-gray-800 dark:text-white mb-4 flex items-center gap-2">
              <Globe class="w-5 h-5 text-blue-500" />
              {{ t('Follow Me', 'Ikuti Saya') }}
            </h3>
            <div class="grid grid-cols-2 gap-2">
              <a
                v-for="(link, idx) in (settings?.normalized_social_links || [])"
                :key="idx"
                :href="link.url"
                target="_blank"
                class="flex items-center gap-2 p-2.5 rounded-lg bg-gray-50 dark:bg-gray-800/80 hover:bg-blue-50 dark:hover:bg-blue-900/30 hover:text-blue-500 transition-colors text-xs font-medium text-gray-700 dark:text-gray-300 border border-transparent hover:border-blue-500/20"
              >
                <component :is="getSocialIcon(link.icon || link.name)" class="w-4 h-4 text-blue-500" />
                <span class="truncate">{{ link.name || link.label }}</span>
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
import { MessageSquare, Send, Loader2, Phone, Mail, MapPin, Clock, Globe, Github, Linkedin, Instagram, Twitter, Youtube, MessageCircle, Share2, CheckCircle, XCircle } from 'lucide-vue-next'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()

// Icon resolver helper
const getSocialIcon = (iconName = '') => {
  const name = iconName.toLowerCase()
  if (name.includes('github')) return Github
  if (name.includes('linkedin')) return Linkedin
  if (name.includes('instagram')) return Instagram
  if (name.includes('twitter') || name.includes('x')) return Twitter
  if (name.includes('youtube')) return Youtube
  if (name.includes('discord')) return MessageSquare
  if (name.includes('telegram')) return Send
  if (name.includes('whatsapp') || name.includes('wa')) return MessageCircle
  if (name.includes('phone') || name.includes('tel')) return Phone
  return Globe || Share2
}

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
