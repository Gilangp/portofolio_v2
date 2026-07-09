import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

/**
 * Upload an image/file to Supabase Storage bucket 'portfolio-media'
 * @param {File} file - File object from input type="file"
 * @param {string} folder - Target folder inside the bucket (e.g., 'logos', 'projects', 'skills')
 * @returns {Promise<{ url?: string, error?: string }>}
 */
export async function uploadImageToStorage(file, folder = 'uploads') {
  try {
    if (!file) return { error: 'No file provided' }
    
    // Clean filename and make unique
    const cleanName = file.name.replace(/[^a-zA-Z0-9.-]/g, '_').toLowerCase()
    const filePath = `${folder}/${Date.now()}_${Math.random().toString(36).substring(2, 8)}_${cleanName}`

    const { data, error } = await supabase.storage
      .from('portfolio-media')
      .upload(filePath, file, {
        cacheControl: '3600',
        upsert: false
      })

    if (error) {
      console.error('Storage upload error:', error)
      return { error: error.message }
    }

    const { data: urlData } = supabase.storage
      .from('portfolio-media')
      .getPublicUrl(filePath)

    return { url: urlData.publicUrl }
  } catch (err) {
    return { error: err.message || 'Unknown error occurred during upload' }
  }
}
