<script setup>
import { computed } from 'vue'

const props = defineProps(['item', 'show'])

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

</script>

<template>
  <div class="modal" :class="{ 'is-active': props.show }">
    <div class="modal-background"></div>
    <div class="new-modal-content">
      <div class="box new-container">
        <button class="delete top-right" @click="$emit('closeModal')"></button>
        <div class="columns is-vcentered">
          <div class="column is-5">
            <img :src="props.item.stdUrl" alt="Video Youtube">
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
