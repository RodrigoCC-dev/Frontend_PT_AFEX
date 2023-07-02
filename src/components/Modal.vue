<script setup>
import { ref, computed } from 'vue'

const props = defineProps(['item', 'show'])
const emit = defineEmits(['closeModal'])
let viewVideo = ref(false)

const fullDesc = computed(() => {
  let list = []
  if (Object.keys(props.item).length > 0 ) {
    const descList = props.item.Descriptions.sort((a, b) => a.partNumber - b.partNumber)
    descList.forEach((elem) => {
      list.push(elem.description)
    })
  }
  return list.join('')
})

const videoEmb = computed(() => {
  let url = ''
  if (Object.keys(props.item).length > 0) {
    url = 'https://www.youtube.com/embed/' + props.item.youtubeId + '?autoplay=1'
  }
  return url
})

function playVideo() {
  viewVideo.value = true
}

function stopVideo() {
  viewVideo.value = false
  emit('closeModal')
}

</script>

<template>
  <div class="modal" :class="{ 'is-active': props.show }">
    <div class="modal-background"></div>
    <div class="new-modal-content">
      <div class="box new-container">
        <button class="delete top-right" @click="stopVideo"></button>
        <div class="columns is-vcentered">
          <div class="column is-5">
            <div v-if="viewVideo">
              <iframe width="470" height="352"
              :src="videoEmb">
              </iframe>
            </div>
            <div v-else>
              <div class="new-container">
                <img :src="props.item.stdUrl" alt="Video Youtube">
                <a @click="playVideo">
                  <img class="img-centered ytb-btn" src="https://developers.google.com/site-assets/logo-youtube.svg" alt="Play" srcset="" sizes="64px">
                </a>
              </div>
            </div>
          </div>
          <div class="column is-7">
            <div class="content">
              <p class="title is-4">{{ props.item.title }}</p>
              <div class="scroll-container">
                <p class="scroll-content">{{ fullDesc }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import '../assets/modal.css';
</style>
