<template>
  <section id="contact" class="py-6 px-4 sm:px-6 lg:px-8 bg-gradient-to-b from-white to-gray-50 dark:from-gray-900 dark:to-gray-800 relative overflow-hidden">
    <!-- Background elements -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute top-1/4 left-1/5 w-32 h-32 rounded-full bg-gradient-to-r from-blue-500/5 to-purple-500/5 blur-xl animate-float-slow"></div>
      <div class="absolute bottom-1/3 right-1/4 w-40 h-40 rounded-full bg-gradient-to-br from-indigo-500/5 to-pink-500/5 blur-xl animate-float-slower"></div>
    </div>

    <div class="h-12"></div>

    <div class="max-w-6xl mx-auto relative z-10">
      <div class="text-center mb-12">
        <h2 class="text-3xl md:text-4xl font-bold mb-3">
          <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 dark:from-blue-400 dark:via-purple-400 dark:to-pink-400 relative">
            {{ currentLang === 'en' ? "Let's Connect" : "Mari Terhubung" }}
            <span class="absolute bottom-0 left-1/2 transform -translate-x-1/2 w-16 h-1 bg-gradient-to-r from-blue-400 to-purple-500 rounded-full mt-1 animate-underline"></span>
          </span>
        </h2>
        <p class="text-base text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
          {{ currentLang === 'en' ? "Have a project in mind? Let's connect and explore how we can bring your ideas to life." : "Punya proyek atau ide yang ingin dikerjakan? Mari terhubung dan wujudkan bersama." }}
        </p>
      </div>

      <!-- contact -->
      <div class="grid grid-cols-1 lg:grid-cols-5 gap-4 lg:gap-6">
        <div class="lg:col-span-3">
          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-4 md:p-5 border border-gray-100 dark:border-gray-700/50 backdrop-blur-sm bg-opacity-90 dark:bg-opacity-90 transition-all duration-300 hover:shadow-xl">
            <h3 class="text-base font-semibold mb-3 text-gray-800 dark:text-white flex items-center">
              <span class="w-6 h-6 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center mr-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
                </svg>
              </span>
              {{ currentLang === 'en' ? "Send Me a Message" : "Kirim Pesan" }}
            </h3>
            
            <form @submit.prevent="submitForm" class="space-y-3" novalidate>
              <div class="space-y-1">
                <label for="name" class="text-xs font-medium text-gray-700 dark:text-gray-300">{{ currentLang === 'en' ? "Your Name *" : "Nama Anda *" }}</label>
                <input 
                  type="text" 
                  id="name"
                  v-model="form.name" 
                  @input="errors.name = ''"
                  class="w-full px-3 py-2 text-xs border rounded-lg focus:ring-2 focus:ring-blue-400 focus:border-blue-400 dark:bg-gray-800/70 dark:text-white transition-all duration-200"
                  :class="errors.name ? 'border-red-500 dark:border-red-500' : 'border-gray-200 dark:border-gray-700'"
                  :placeholder="currentLang === 'en' ? 'Enter your name' : 'Masukkan nama Anda'"
                >
                <span v-if="errors.name" class="text-xs text-red-500">{{ errors.name }}</span>
              </div>

              <div class="space-y-1">
                <label for="email" class="text-xs font-medium text-gray-700 dark:text-gray-300">{{ currentLang === 'en' ? "Email Address *" : "Alamat Email *" }}</label>
                <input 
                  type="email" 
                  id="email"
                  v-model="form.email" 
                  @input="errors.email = ''"
                  class="w-full px-3 py-2 text-xs border rounded-lg focus:ring-2 focus:ring-blue-400 focus:border-blue-400 dark:bg-gray-800/70 dark:text-white transition-all duration-200"
                  :class="errors.email ? 'border-red-500 dark:border-red-500' : 'border-gray-200 dark:border-gray-700'"
                  placeholder="your.email@example.com"
                >
                <span v-if="errors.email" class="text-xs text-red-500">{{ errors.email }}</span>
              </div>

              <div class="space-y-1">
                <label for="message" class="text-xs font-medium text-gray-700 dark:text-gray-300">{{ currentLang === 'en' ? "Your Message *" : "Pesan Anda *" }}</label>
                <textarea 
                  id="message"
                  v-model="form.message" 
                  rows="3" 
                  @input="errors.message = ''"
                  class="w-full px-3 py-2 text-xs border rounded-lg focus:ring-2 focus:ring-blue-400 focus:border-blue-400 dark:bg-gray-800/70 dark:text-white transition-all duration-200 resize-none"
                  :class="errors.message ? 'border-red-500 dark:border-red-500' : 'border-gray-200 dark:border-gray-700'"
                  :placeholder="currentLang === 'en' ? 'Tell me about your project...' : 'Ceritakan tentang proyek atau kebutuhan Anda...'"
                ></textarea>
                <span v-if="errors.message" class="text-xs text-red-500">{{ errors.message }}</span>
              </div>

              <button 
                type="submit" 
                :disabled="isSubmitting || !isFormValid"
                class="w-full text-xs bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 disabled:from-gray-400 disabled:to-gray-500 disabled:cursor-not-allowed text-white font-medium py-2 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2 dark:focus:ring-offset-gray-800 transition-all duration-300 shadow hover:shadow-md flex items-center justify-center"
              >
                <span v-if="!isSubmitting" class="flex items-center">
                  {{ currentLang === 'en' ? "Send Message" : "Kirim Pesan" }}
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                  </svg>
                </span>
                <span v-else class="flex items-center">
                  <svg class="animate-spin -ml-1 mr-2 h-3.5 w-3.5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  {{ currentLang === 'en' ? "Sending..." : "Mengirim..." }}
                </span>
              </button>
            </form>
          </div>
        </div>

        <!-- contact info -->
        <div class="lg:col-span-2 space-y-3">
          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-4 md:p-5 border border-gray-100 dark:border-gray-700/50 backdrop-blur-sm bg-opacity-90 dark:bg-opacity-90 transition-all duration-300 hover:shadow-xl">
            <h3 class="text-base font-semibold mb-3 text-gray-800 dark:text-white flex items-center">
              <span class="w-6 h-6 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center mr-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                </svg>
              </span>
              {{ currentLang === 'en' ? "Contact Information" : "Informasi Kontak" }}
            </h3>
            
            <div class="space-y-3">
              <div class="flex items-start gap-2">
                <div class="p-1 bg-blue-100 dark:bg-blue-900/30 rounded-lg text-blue-500 mt-0.5">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                </div>
                <div>
                  <h4 class="text-xs font-medium text-gray-500 dark:text-gray-400">{{ currentLang === 'en' ? "Email" : "Alamat Email" }}</h4>
                  <a :href="`mailto:${settings?.contact_email ?? 'gilangpurnomo0505@gmail.com'}`" class="text-blue-500 hover:text-blue-600 dark:hover:text-blue-400 text-xs font-medium">
                    {{ settings?.contact_email ?? 'gilangpurnomo0505@gmail.com' }}
                  </a>
                </div>
              </div>

              <div class="flex items-start gap-2">
                <div class="p-1 bg-blue-100 dark:bg-blue-900/30 rounded-lg text-blue-500 mt-0.5">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                </div>
                <div>
                  <h4 class="text-xs font-medium text-gray-500 dark:text-gray-400">{{ currentLang === 'en' ? "Location" : "Lokasi" }}</h4>
                  <p class="text-gray-700 dark:text-gray-300 text-xs font-medium">{{ settings?.contact_location ?? 'Malang, Indonesia' }}</p>
                </div>
              </div>

              <div class="flex items-start gap-2">
                <div class="p-1 bg-blue-100 dark:bg-blue-900/30 rounded-lg text-blue-500 mt-0.5">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div>
                  <h4 class="text-xs font-medium text-gray-500 dark:text-gray-400">{{ currentLang === 'en' ? "Response Time" : "Waktu Respon" }}</h4>
                  <p class="text-gray-700 dark:text-gray-300 text-xs font-medium">{{ currentLang === 'en' ? (settings?.contact_response_en ?? 'Same day - 24 hours') : (settings?.contact_response_id ?? 'Hari yang sama - 24 jam') }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- sosmed card -->
          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-4 md:p-5 border border-gray-100 dark:border-gray-700/50 backdrop-blur-sm bg-opacity-90 dark:bg-opacity-90 transition-all duration-300 hover:shadow-xl">
            <h3 class="text-base font-semibold mb-3 text-gray-800 dark:text-white flex items-center">
              <span class="w-6 h-6 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center mr-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-3l-4 4z" />
                </svg>
              </span>
              {{ currentLang === 'en' ? "Follow Me" : "Ikuti Saya" }}
            </h3>
            
            <div class="flex flex-wrap gap-2">
              <a
                v-for="(link, idx) in (settings?.normalized_social_links || defaultSocialLinks)"
                :key="idx"
                :href="link.url"
                target="_blank"
                rel="noopener noreferrer"
                class="flex-1 min-w-[90px]"
              >
                <div class="p-1.5 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-blue-100 dark:hover:bg-blue-900/30 transition-colors duration-200 flex items-center gap-1.5">
                  <div class="p-1 bg-white dark:bg-gray-800 rounded-md flex items-center justify-center">
                    <DynamicIcon :name="link.icon || link.name || 'globe'" class-name="h-3.5 w-3.5 text-gray-800 dark:text-gray-200" />
                  </div>
                  <span class="text-gray-700 dark:text-gray-300 text-xs font-medium capitalize">{{ link.name || link.label }}</span>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- success toast -->
    <div v-if="showSuccessToast" class="fixed bottom-4 right-4 z-50 animate-fade-in-up">
      <div class="bg-gradient-to-r from-green-500 to-teal-500 text-white px-4 py-1.5 rounded-lg shadow-lg flex items-center">
        <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
        <span class="text-xs font-medium">{{ currentLang === 'en' ? "Message sent successfully! Thanks for reaching out." : "Pesan berhasil dikirim! Terima kasih telah menghubungi saya." }}</span>
      </div>
    </div>

    <!-- error toast -->
    <div v-if="showErrorToast" class="fixed bottom-4 right-4 z-50 animate-fade-in-up">
      <div class="bg-gradient-to-r from-red-500 to-red-600 text-white px-4 py-1.5 rounded-lg shadow-lg flex items-center">
        <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
        <span class="text-xs font-medium">{{ errorMessage }}</span>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed } from 'vue'
import emailjs from 'emailjs-com'
import useLanguage from '@/composables/useLanguage'
import useSiteSettings from '@/composables/useSiteSettings'
import DynamicIcon from '@/components/common/DynamicIcon.vue'

const { currentLang, t } = useLanguage()
const { settings } = useSiteSettings()

const defaultSocialLinks = [
  { name: 'github', url: 'https://github.com/Gilangp', icon: 'github' },
  { name: 'linkedin', url: 'https://www.linkedin.com/in/gilang-purnomo-b3863328b/', icon: 'linkedin' },
  { name: 'instagram', url: 'https://www.instagram.com/gilangprnm__/', icon: 'instagram' },
  { name: 'tiktok', url: 'https://www.tiktok.com/@gilangp__', icon: 'tiktok' }
]

const form = ref({ name: '', email: '', message: '' })
const errors = ref({ name: '', email: '', message: '' })
const isSubmitting = ref(false)
const showSuccessToast = ref(false)
const showErrorToast = ref(false)
const errorMessage = ref('')

const validateEmail = () => {
  const email = form.value.email.trim()
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  const anonymousEmails = ['anonymous@', 'test@test', 'aaa@aaa', 'noname@', 'email@email', 'fake@', '123@123']

  errors.value.email = ''
  if (!email) {
    errors.value.email = currentLang.value === 'en' ? 'Email is required' : 'Alamat email wajib diisi'
    return false
  }
  if (!emailRegex.test(email)) {
    errors.value.email = currentLang.value === 'en' ? 'Please enter a valid email address' : 'Mohon masukkan email yang valid'
    return false
  }
  if (anonymousEmails.some(anon => email.toLowerCase().includes(anon))) {
    errors.value.email = currentLang.value === 'en' ? 'Please use a real email address' : 'Mohon gunakan alamat email asli'
    return false
  }
  return true
}

const validateForm = () => {
  errors.value = { name: '', email: '', message: '' }
  if (!form.value.name.trim() || form.value.name.length < 2) {
    errors.value.name = currentLang.value === 'en' ? 'Name must be at least 2 characters' : 'Nama minimal 2 karakter'
  }
  if (!validateEmail()) {
    return false
  }
  if (!form.value.message.trim() || form.value.message.length < 10) {
    errors.value.message = currentLang.value === 'en' ? 'Message must be at least 10 characters' : 'Pesan minimal 10 karakter'
  }
  return !errors.value.name && !errors.value.email && !errors.value.message
}

const isFormValid = computed(() => {
  return (
    form.value.name.trim().length >= 2 &&
    form.value.email.trim().length > 0 &&
    form.value.message.trim().length >= 10 &&
    !errors.value.email
  )
})

const submitForm = async () => {
  if (!validateForm()) {
    errorMessage.value = currentLang.value === 'en' ? 'Please fill all fields correctly' : 'Mohon isi semua kolom dengan benar'
    showErrorToast.value = true
    setTimeout(() => (showErrorToast.value = false), 4000)
    return
  }

  isSubmitting.value = true
  try {
    const serviceId = import.meta.env.VITE_EMAILJS_SERVICE_ID
    const templateId = import.meta.env.VITE_EMAILJS_TEMPLATE_ID
    const publicKey = import.meta.env.VITE_EMAILJS_PUBLIC_KEY
    const targetEmail = settings.value?.contact_email ?? 'gilangpurnomo0505@gmail.com'

    if (!serviceId || !templateId || !publicKey) {
      window.location.href = `mailto:${targetEmail}?subject=Pesan Portofolio dari ${encodeURIComponent(form.value.name)}&body=${encodeURIComponent(form.value.message + '\n\nDari: ' + form.value.name + ' (' + form.value.email + ')')}`
      showSuccessToast.value = true
      form.value = { name: '', email: '', message: '' }
      setTimeout(() => (showSuccessToast.value = false), 4000)
      isSubmitting.value = false
      return
    }

    await emailjs.send(
      serviceId,
      templateId,
      {
        from_name: form.value.name,
        from_email: form.value.email,
        message: form.value.message,
        to_email: targetEmail,
        reply_to: form.value.email,
        time: new Date().toLocaleString('en-US', { timeZone: 'Asia/Jakarta' })
      },
      publicKey
    )

    showSuccessToast.value = true
    form.value = { name: '', email: '', message: '' }
    errors.value = { name: '', email: '', message: '' }
    setTimeout(() => (showSuccessToast.value = false), 4000)
  } catch (err) {
    errorMessage.value = currentLang.value === 'en' ? 'Failed to send email. Please try again.' : 'Gagal mengirim email. Silakan coba lagi.'
    showErrorToast.value = true
    console.error('EmailJS error:', err)
    setTimeout(() => (showErrorToast.value = false), 4000)
  } finally {
    isSubmitting.value = false
  }
}
</script>
