<template>
  <section id="contact" class="py-20 px-4 sm:px-6 lg:px-8 bg-transparent transition-colors duration-500 relative overflow-hidden">
    <div class="orb top-1/4 left-10 w-80 h-80 bg-blue-500/10 dark:bg-cyan-500/15" />
    <div class="orb bottom-1/4 right-10 w-80 h-80 bg-purple-500/10 dark:bg-indigo-500/15" />

    <div class="max-w-6xl mx-auto relative z-10">
      <!-- High-End Cyber-Satin Luxury Header -->
      <div class="text-center mb-16 relative">
        <div class="absolute inset-x-0 -top-6 flex justify-center pointer-events-none opacity-50 dark:opacity-35">
          <div class="w-72 h-16 bg-gradient-to-r from-blue-600 via-indigo-500 to-cyan-400 blur-2xl rounded-full"></div>
        </div>
        <div class="relative inline-flex items-center gap-2.5 px-4 py-1.5 rounded-full bg-white/60 dark:bg-slate-900/60 border border-blue-500/20 dark:border-cyan-500/25 backdrop-blur-md shadow-sm mb-4 transition-all hover:border-cyan-400/50">
          <span class="w-1.5 h-1.5 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_8px_rgba(0,216,255,0.8)]"></span>
          <span class="text-xs font-bold tracking-[0.18em] text-slate-800 dark:text-slate-200 uppercase">{{ t('Contact', 'Kolaborasi') }}</span>
        </div>
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 dark:text-white tracking-tight">
          {{ t("Let's", 'Mari') }} <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 via-indigo-600 to-cyan-500 dark:from-cyan-400 dark:via-blue-500 dark:to-indigo-400 drop-shadow-[0_2px_12px_rgba(0,216,255,0.25)]">{{ t('Connect', 'Terhubung') }}</span>
        </h2>
        <div class="flex items-center justify-center gap-2 mt-5">
          <span class="w-2 h-2 rounded-full bg-blue-600 dark:bg-cyan-400 shadow-[0_0_10px_rgba(0,216,255,0.8)]"></span>
          <span class="w-24 h-1 rounded-full bg-gradient-to-r from-blue-600 via-indigo-500 to-transparent dark:from-cyan-400 dark:via-blue-500 dark:to-transparent"></span>
        </div>
        <p class="mt-4 text-slate-600 dark:text-slate-400 text-sm max-w-lg mx-auto leading-relaxed">
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
          <form @submit.prevent="submitForm" class="space-y-4" novalidate>
            <div>
              <label class="block text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">{{ t('Your Name *', 'Nama Anda *') }}</label>
              <input v-model="form.name" type="text" @input="errors.name = ''" class="input-base" :class="errors.name ? 'border-red-500 dark:border-red-500 focus:ring-red-500' : ''" :placeholder="t('Enter your name', 'Masukkan nama Anda')" />
              <p v-if="errors.name" class="text-xs text-red-500 mt-1.5 font-medium flex items-center gap-1">
                <XCircle class="w-3.5 h-3.5" /> {{ errors.name }}
              </p>
            </div>
            <div>
              <label class="block text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">{{ t('Email Address *', 'Alamat Email *') }}</label>
              <input v-model="form.email" type="email" @input="errors.email = ''" class="input-base" :class="errors.email ? 'border-red-500 dark:border-red-500 focus:ring-red-500' : ''" placeholder="your@email.com" />
              <p v-if="errors.email" class="text-xs text-red-500 mt-1.5 font-medium flex items-center gap-1">
                <XCircle class="w-3.5 h-3.5" /> {{ errors.email }}
              </p>
            </div>
            <div>
              <label class="block text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">{{ t('Your Message *', 'Pesan Anda *') }}</label>
              <textarea v-model="form.message" rows="4" @input="errors.message = ''" class="input-base resize-none" :class="errors.message ? 'border-red-500 dark:border-red-500 focus:ring-red-500' : ''" :placeholder="t('Tell me about your project...', 'Ceritakan tentang proyek Anda...')" />
              <p v-if="errors.message" class="text-xs text-red-500 mt-1.5 font-medium flex items-center gap-1">
                <XCircle class="w-3.5 h-3.5" /> {{ errors.message }}
              </p>
            </div>
            <button
              type="submit"
              :disabled="isSubmitting || !isFormValid"
              class="btn-primary w-full justify-center transition-all duration-300"
              :class="!isFormValid ? 'opacity-50 cursor-not-allowed !bg-gray-600 !shadow-none' : 'shadow-lg shadow-blue-500/20 hover:shadow-blue-500/30'"
            >
              <span v-if="!isSubmitting" class="flex items-center gap-2 font-bold">
                <Send class="w-4 h-4" /> {{ t('Send Message', 'Kirim Pesan') }}
              </span>
              <span v-else class="flex items-center gap-2 font-bold">
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
                <a :href="`mailto:${settings?.contact_email ?? 'gilangpurnomo0505@gmail.com'}`" class="text-blue-500 hover:text-blue-600 text-xs font-medium truncate">
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
                <component :is="getSocialIcon(link.icon || link.name)" class="w-4 h-4 text-blue-500 flex-shrink-0" />
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

const isFormValid = computed(() => {
  const nameValid = form.value.name.trim().length >= 2
  const emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email.trim())
  const msgValid = form.value.message.trim().length >= 5
  return nameValid && emailValid && msgValid
})

const showToast = (type, message) => {
  toast.value = { show: true, type, message }
  setTimeout(() => (toast.value.show = false), 4500)
}

const validate = () => {
  let valid = true
  errors.value = { name: '', email: '', message: '' }

  if (form.value.name.trim().length < 2) {
    errors.value.name = t('Please enter your name (min 2 characters)', 'Mohon masukkan nama Anda (minimal 2 karakter)')
    valid = false
  }
  if (!form.value.email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email.trim())) {
    errors.value.email = t('Please enter a valid email address', 'Mohon masukkan format email yang valid (contoh: nama@domain.com)')
    valid = false
  }
  if (form.value.message.trim().length < 5) {
    errors.value.message = t('Message must be at least 5 characters', 'Pesan minimal 5 karakter')
    valid = false
  }
  return valid
}

const submitForm = async () => {
  if (!validate()) return

  isSubmitting.value = true
  try {
    const serviceId = import.meta.env.VITE_EMAILJS_SERVICE_ID
    const templateId = import.meta.env.VITE_EMAILJS_TEMPLATE_ID
    const publicKey = import.meta.env.VITE_EMAILJS_PUBLIC_KEY
    const targetEmail = settings.value?.contact_email ?? 'gilangpurnomo0505@gmail.com'

    if (!serviceId || !templateId || !publicKey) {
      window.location.href = `mailto:${targetEmail}?subject=Pesan Portofolio dari ${encodeURIComponent(form.value.name)}&body=${encodeURIComponent(form.value.message + '\n\nDari: ' + form.value.name + ' (' + form.value.email + ')')}`
      form.value = { name: '', email: '', message: '' }
      showToast('success', t('Opening your email app to send message.', 'Membuka aplikasi email Anda untuk mengirim pesan.'))
      isSubmitting.value = false
      return
    }

    await emailjs.send(
      serviceId,
      templateId,
      { 
        name: form.value.name, 
        from_name: form.value.name, 
        email: form.value.email, 
        from_email: form.value.email, 
        message: form.value.message, 
        time: new Date().toLocaleString('id-ID', { dateStyle: 'full', timeStyle: 'short' }),
        to_email: targetEmail, 
        reply_to: form.value.email 
      },
      publicKey
    )
    form.value = { name: '', email: '', message: '' }
    showToast('success', t('Message sent successfully.', 'Pesan berhasil terkirim.'))
  } catch (err) {
    console.error('EmailJS Error:', err)
    showToast('error', t('Failed to send via server. Trying email app...', 'Gagal mengirim lewat server. Mencoba membuka aplikasi email...'))
    const targetEmail = settings.value?.contact_email ?? 'gilangpurnomo0505@gmail.com'
    window.location.href = `mailto:${targetEmail}?subject=Pesan Portofolio dari ${encodeURIComponent(form.value.name)}&body=${encodeURIComponent(form.value.message + '\n\nDari: ' + form.value.name + ' (' + form.value.email + ')')}`
  } finally {
    isSubmitting.value = false
  }
}
</script>
