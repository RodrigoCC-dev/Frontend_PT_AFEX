<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import ItemList from './ItemList.vue'
import Modal from './Modal.vue'
import Notification from './Notification.vue'

let link = ''
let videoData = {}
let apiUrl = import.meta.env.VITE_BACK_DIR
const videoList = ref([])
let showConfirm = ref(false)
let idDeleted = 0
let showModal = ref(false)
let itemShow = {}
let hasError = ref({
  error: false,
  message: ''
})
let seeNot = ref(false)
let notType = {
  error: false,
  warn: false,
  success: false
}
let notMsg = ''

const videoIdList = computed(() => {
  let list = []
  videoList.value.forEach((item) => {
    list.push(item.youtubeId)
  })
  return list
})

async function getVideoList() {
  try {
    const response = await axios.get(apiUrl + '/album')
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

function isPresentVideoId(id) {
  return videoIdList.value.includes(id)
}

function getTime(duration) {
  let list = []
  const aux = duration.replace('H', ':').replace('M', ':')
  const time = aux.split('S')[0].split('PT')[1]
  const array = time.split(':')
  list.push(array[0])
  for (let i = 1; i < array.length; i++) {
    array[i].length === 1 ? list.push('0' + array[i]) : list.push(array[i])
  }
  return list.join(':')
}

async function getInfo() {
  if (isValidUrl()) {
    let videoId = getVideoId()
    if (!isPresentVideoId(videoId)) {
      let url = 'https://www.googleapis.com/youtube/v3/videos?id=' + videoId + '&key=' + import.meta.env.VITE_API_KEY + '&part=snippet%2CcontentDetails'
      try {
        const response = await axios.get(url)
        videoData = response.data
        const newVideo = {
          videoId: videoData.items[0].id,
          title: videoData.items[0].snippet.title,
          description: videoData.items[0].snippet.description,
          mediumUrl: videoData.items[0].snippet.thumbnails.medium.url,
          stdUrl: videoData.items[0].snippet.thumbnails.standard.url,
          duration: getTime(videoData.items[0].contentDetails.duration)
        }
        try {
          await axios.post(apiUrl + '/album', newVideo)
          getVideoList()
          link = ''
          setNotification('success', 'Se ha agregado exitósamente el video al album')
        } catch (e) {
          try {
            setNotification('error', e.response.data.error)
          } catch {
            setNotification('error', 'No fue posible agregar el video. Por favor, intente nuevamente.')
          }
        }
      } catch {
        setNotification('warn', 'No fue posible obtener los datos del video. Por favor, verifique el enlace e intente nuevamente.')
      }
    } else {
      hasError.value.error = true
      hasError.value.message = 'El video asociado al enlace ya se encuentra presente en el album. Por favor, verificar.'
    }
  } else {
    hasError.value.error = true
    hasError.value.message = 'Dirección ingresada no es un enlace de Youtube válido. Por favor, verificar.'
  }
}

function showVideo(item) {
  itemShow = item
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  itemShow = {}
}

function deleteVideo(id) {
  idDeleted = id
  showConfirm.value = true
}

function cancelDelete() {
  showConfirm.value = false
  idDeleted = 0
}

async function confirmDelete() {
  try {
    const response = await axios.delete(apiUrl + '/album/' + idDeleted)
    getVideoList()
    setNotification('success', 'El video fue eliminado exitósamente.')
  } catch (e) {
    try {
      setNotification('error', e.response.data.error)
    } catch {
      setNotification('error', 'No fue posible eliminar el video. Por favor, intente nuevamente.')
    }
  }
  showConfirm.value = false
  idDeleted = 0
}

function cleanError() {
  hasError.value.error = false
  hasError.value.message = ''
}

function setNotification(type, msg) {
  if (Object.keys(notType).includes(type)) {
    notType[type] = true
  } else {
    notType.error = true
  }
  notMsg = msg
  seeNot.value = true
  autoCloseNot()
}

function closeNot() {
  seeNot.value = false
  notMsg = ''
  Object.keys(notType).forEach((key) => {
    notType[key] = false
  })
}

function autoCloseNot() {
  setTimeout(() => {closeNot()}, 5000)
}

onMounted(async () => await getVideoList())

</script>

<template>
  <div class="container">

    <template v-if="seeNot">
      <Notification :msg="notMsg" :notClass="notType" @close-not="closeNot" />
    </template>

    <div class="my-5 py-5">
      <div class="content">
        <h2>Añadir nuevo video</h2>
      </div>
      <div class="field has-addons">
        <div class="control is-expanded">
          <input class="input" :class="{'is-danger' : hasError.error}" type="text" placeholder="Enlace youtube" @input="cleanError" v-model="link">
        </div>
        <div class="control">
          <a class="button px-6 is-info" @click="getInfo">Añadir</a>
        </div>
      </div>
      <p class="help is-danger is-size-6">{{ hasError.message }}</p>
    </div>

    <div class="columns is-multiline pt-5 mt-5">
      <template v-for="video in videoList">
        <ItemList :item="video" @select-img="showVideo" @delete-img="deleteVideo" />
      </template>
    </div>

    <Modal :item="itemShow" :show="showModal" @close-modal="closeModal" />

    <div class="modal" :class="{ 'is-active': showConfirm }">
      <div class="modal-background"></div>
      <div class="modal-content">
        <div class="box new-container">
          <button class="delete top-right" @click="cancelDelete"></button>
          <div class="columns">
            <div class="column is-full">
              <p class="title is-5 py-3">¿Seguro que quieres eliminar este video?</p>
              <div class="columns is-centered">
                <div class="column is-4 is-offset-one-quarter">
                  <div class="field">
                    <div class="control">
                      <button class="button is-info is-outlined is-fullwidth" @click="cancelDelete">Cancelar</button>
                    </div>
                  </div>
                </div>
                <div class="column is-4">
                  <div class="field">
                    <div class="control">
                      <button class="button is-link is-fullwidth" @click="confirmDelete">Eliminar</button>
                    </div>
                  </div>
                </div>
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
