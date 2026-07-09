import { ref, onMounted, onBeforeUnmount } from 'vue'

export function useParallax() {
  const parallaxY = ref(0)
  const parallaxX = ref(0)

  const handleScroll = () => {
    parallaxY.value = window.scrollY * 0.3
  }

  const handleMouseMove = (event) => {
    const x = (event.clientX / window.innerWidth - 0.5) * 30
    const y = (event.clientY / window.innerHeight - 0.5) * 30
    parallaxX.value = x
  }

  onMounted(() => {
    window.addEventListener('scroll', handleScroll)
    window.addEventListener('mousemove', handleMouseMove)
  })

  onBeforeUnmount(() => {
    window.removeEventListener('scroll', handleScroll)
    window.removeEventListener('mousemove', handleMouseMove)
  })

  return { parallaxY, parallaxX }
}
