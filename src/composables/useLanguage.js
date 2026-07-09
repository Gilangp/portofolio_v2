import { ref } from 'vue'

// Shared singleton state
const currentLang = ref(localStorage.getItem('lang') || 'id')

export default function useLanguage() {
  const setLanguage = (lang) => {
    currentLang.value = lang
    localStorage.setItem('lang', lang)
    document.documentElement.setAttribute('lang', lang)
  }

  const toggleLanguage = () => {
    setLanguage(currentLang.value === 'en' ? 'id' : 'en')
  }

  const t = (enText, idText) => currentLang.value === 'en' ? enText : idText

  return { currentLang, setLanguage, toggleLanguage, t }
}
