import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

// Global singleton for site settings
const settings = ref(null)
const isLoading = ref(true)
let fetchPromise = null

export default function useSiteSettings() {
  const fetchSettings = async () => {
    if (settings.value) return settings.value
    if (fetchPromise) return fetchPromise

    fetchPromise = supabase
      .from('site_settings')
      .select('*')
      .eq('id', 1)
      .single()
      .then(({ data, error }) => {
        if (!error && data) settings.value = data
        isLoading.value = false
        fetchPromise = null
        return data
      })

    return fetchPromise
  }

  onMounted(() => {
    if (!settings.value) fetchSettings()
  })

  return { settings, isLoading, fetchSettings }
}
