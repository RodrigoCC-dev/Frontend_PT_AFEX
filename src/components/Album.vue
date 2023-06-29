<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

let link = ''
let videoData = {}
let apiUlr = import.meta.env.VITE_BACK_DIR
const videoList = ref([])

async function getVideoList() {
  try {
    const response = await axios.get(apiUlr + '/album')
    videoList.value = response.data
  } catch (e) {
    console.log('No fue posible obtener la lista de videos')
    console.log(e)
  }
}

function getVideoId() {
  let videoId = ''
  if (link.includes('v=')) {
    videoId = link.split('v=')[1]
  } else {
    let aux = link.split('/')
    videoId = aux[aux.length -1]
  }
  return videoId
}

function isValidUrl() {
  let aux = link.split('/')
  return aux.includes('www.youtube.com') || aux.includes('youtu.be')
}

function getTime(duration) {
  const aux = duration.replace('H', ':').replace('M', ':')
  return aux.split('S')[0].split('PT')[1]
}

async function getInfo() {
  if (isValidUrl()) {
    let videoId = getVideoId()
    let url = 'https://www.googleapis.com/youtube/v3/videos?id=' + videoId + '&key=' + import.meta.env.VITE_API_KEY + '&part=snippet%2CcontentDetails'
    try {
      const response = await axios.get(url)
      videoData = response.data
      const newVideo = {
        videoId: videoData.items[0].id,
        title: videoData.items[0].snippet.title,
        description: videoData.items[0].snippet.description,
        thumbUrl: videoData.items[0].snippet.thumbnails.medium.url,
        duration: getTime(videoData.items[0].contentDetails.duration)
      }
      try {
        await axios.post(apiUlr + '/album', newVideo)
        getVideoList()
      } catch (e) {
        console.log('No fue posible agregar el video')
      }
    } catch (e) {
      console.log('Hubo un error al obtener la data')
    }
  } else {
    console.log('Dirección no es enlace de youtube válido')
  }
}

onMounted(async () => await getVideoList())

</script>

<template>
  <div class="container">
    <div class="mt-5">
      <div class="content">
        <h2>Añadir nuevo video</h2>
      </div>
      <div class="field has-addons">
        <div class="control is-expanded">
          <input class="input" type="text" placeholder="Enlace youtube" v-model="link">
        </div>
        <div class="control">
          <a class="button px-6 is-info" @click="getInfo">Añadir</a>
        </div>
      </div>
    </div>
  </div>
</template>
