<script setup>

const props = defineProps(['item'])
</script>

<template>
  <div class="column is-one-third has-text-centered my-5">
    <div class="new-container">
      <a @click="$emit('selectImg', props.item)"><img :src="props.item.mediumUrl" :alt="props.item.title"></a>
      <button class="new-delete top-right" @click="$emit('deleteImg', props.item.id)"></button>
      <p class="duration-text bottom-right">{{item.duration}}</p>
    </div>
  </div>
</template>

<style scoped>
@import '../assets/items.css';
</style>
