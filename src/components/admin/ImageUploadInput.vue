<template>
  <div class="space-y-2">
    <label v-if="label" class="block text-xs font-semibold text-slate-400">{{ label }}</label>
    <div class="flex gap-2">
      <!-- Direct URL Input -->
      <input
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
        type="url"
        class="input-admin flex-1 !py-2 !text-xs"
        :placeholder="placeholder || 'https://... atau klik Upload File'"
      />

      <!-- Hidden File Input -->
      <input
        ref="fileInputRef"
        type="file"
        accept="image/*,.svg,.ico"
        class="hidden"
        @change="handleFileUpload"
      />

      <!-- Upload Button -->
      <button
        type="button"
        @click="triggerFilePicker"
        :disabled="isUploading"
        class="px-3 py-2 bg-slate-800 hover:bg-blue-600/20 text-slate-300 hover:text-blue-400 font-semibold text-xs rounded-xl border border-slate-700 hover:border-blue-500/40 transition-all flex items-center gap-1.5 flex-shrink-0 disabled:opacity-50"
      >
        <Loader2 v-if="isUploading" class="w-3.5 h-3.5 animate-spin text-blue-400" />
        <UploadCloud v-else class="w-3.5 h-3.5 text-blue-400" />
        {{ isUploading ? 'Mengupload...' : 'Upload File' }}
      </button>
    </div>

    <!-- Error/Bucket Banner if bucket doesn't exist -->
    <div v-if="uploadError" class="p-3 bg-rose-500/10 border border-rose-500/20 rounded-xl text-xs text-rose-300 space-y-2">
      <div class="flex items-start gap-2">
        <AlertTriangle class="w-4 h-4 flex-shrink-0 text-rose-400 mt-0.5" />
        <div>
          <p class="font-bold">Gagal Mengunggah ke Storage:</p>
          <p class="text-[11px] text-rose-200/80 mt-0.5">{{ uploadError }}</p>
        </div>
      </div>
      <div v-if="uploadError.includes('not found') || uploadError.includes('bucket') || uploadError.includes('policy') || uploadError.includes('row-level')" class="p-2.5 bg-slate-950/80 rounded-lg border border-slate-800 text-[11px] font-mono text-slate-300 space-y-1">
        <p class="text-blue-400 font-sans font-semibold">Tips Solusi Supabase Storage:</p>
        <p class="font-sans text-[11px] text-slate-400">Jalankan SQL ini di <strong>SQL Editor Supabase</strong> untuk membuat Storage Bucket <code class="text-blue-300">portfolio-media</code> secara otomatis:</p>
        <div class="p-1.5 bg-black/60 rounded text-[10px] select-all overflow-x-auto text-emerald-400">
          INSERT INTO storage.buckets (id, name, public) VALUES ('portfolio-media', 'portfolio-media', true) ON CONFLICT DO NOTHING;<br/>
          CREATE POLICY "Public Access" ON storage.objects FOR ALL USING ( bucket_id = 'portfolio-media' );
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { UploadCloud, Loader2, AlertTriangle } from 'lucide-vue-next'
import { uploadImageToStorage } from '@/lib/supabase'

const props = defineProps({
  modelValue: { type: String, default: '' },
  label: { type: String, default: '' },
  placeholder: { type: String, default: '' },
  folder: { type: String, default: 'general' }
})

const emit = defineEmits(['update:modelValue'])

const fileInputRef = ref(null)
const isUploading = ref(false)
const uploadError = ref('')

const triggerFilePicker = () => {
  uploadError.value = ''
  if (fileInputRef.value) fileInputRef.value.click()
}

const handleFileUpload = async (e) => {
  const file = e.target.files?.[0]
  if (!file) return

  isUploading.value = true
  uploadError.value = ''

  const { url, error } = await uploadImageToStorage(file, props.folder)
  if (error) {
    uploadError.value = error
  } else if (url) {
    emit('update:modelValue', url)
  }

  isUploading.value = false
  // Reset file input value so same file can be selected again if needed
  if (fileInputRef.value) fileInputRef.value.value = ''
}
</script>
