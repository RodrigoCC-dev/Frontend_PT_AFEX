<script setup>
import axios from 'axios'

let link = ''
let videoData = {}

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

async function getInfo() {
  if (isValidUrl()) {
    let videoId = getVideoId()
    let url = 'https://www.googleapis.com/youtube/v3/videos?id=' + videoId + '&key=' + import.meta.env.VITE_API_KEY + '&part=snippet%2CcontentDetails'
    try {
      const response = await axios.get(url)
      videoData = response.data
      console.log(videoData)
    } catch (e) {
      console.log('Hubo un error al obtener la data')
    }
  } else {
    console.log('Dirección no es enlace de youtube válido')
  }
}

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
