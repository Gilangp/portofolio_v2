import { ref, onMounted, watch } from 'vue'
import { supabase } from '@/lib/supabase'

// Global singleton for site settings
const settings = ref(null)
const isLoading = ref(true)
let fetchPromise = null

// Helper to update DOM title and favicon dynamically without mutating reactive state
const updateMeta = (data) => {
  if (!data) return
  if (data.site_title) {
    document.title = data.site_title
  } else if (data.name) {
    document.title = `${data.name} — Portfolio`
  }

  if (data.site_favicon_url) {
    let link = document.querySelector("link[rel~='icon']")
    if (!link) {
      link = document.createElement('link')
      link.rel = 'icon'
      document.head.appendChild(link)
    }
    link.href = data.site_favicon_url
  }
}

const normalizeSocialLinks = (data) => {
  if (!data) return []
  if (Array.isArray(data.social_links) && data.social_links.length > 0) {
    return data.social_links
  }
  const links = []
  if (data.social_github) links.push({ name: 'GitHub', url: data.social_github, icon: 'Github' })
  if (data.social_linkedin) links.push({ name: 'LinkedIn', url: data.social_linkedin, icon: 'Linkedin' })
  if (data.social_instagram) links.push({ name: 'Instagram', url: data.social_instagram, icon: 'Instagram' })
  if (data.social_tiktok) links.push({ name: 'TikTok', url: data.social_tiktok, icon: 'Tiktok' })
  return links
}

export default function useSiteSettings() {
  const fetchSettings = async () => {
    if (settings.value) {
      updateMeta(settings.value)
      isLoading.value = false
      return settings.value
    }
    if (fetchPromise) return fetchPromise

    // Safety timeout so isLoading never blocks for more than 300ms
    const timer = setTimeout(() => {
      isLoading.value = false
    }, 300)

    fetchPromise = supabase
      .from('site_settings')
      .select('*')
      .eq('id', 1)
      .single()
      .then(({ data, error }) => {
        clearTimeout(timer)
        if (!error && data) {
          // Normalize right BEFORE assigning to ref so we never mutate during reactive watches
          data.normalized_social_links = normalizeSocialLinks(data)
          settings.value = data
          updateMeta(data)
        }
        isLoading.value = false
        fetchPromise = null
        return data
      })
      .catch(() => {
        clearTimeout(timer)
        isLoading.value = false
        fetchPromise = null
      })

    return fetchPromise
  }

  onMounted(() => {
    if (!settings.value) fetchSettings()
    else {
      isLoading.value = false
      updateMeta(settings.value)
    }
  })

  // Watch for changes (e.g. from SettingsPage) only to update DOM meta elements
  watch(settings, (newVal) => {
    if (newVal) {
      updateMeta(newVal)
    }
  }, { deep: true })

  return { settings, isLoading, fetchSettings, normalizeSocialLinks }
}
