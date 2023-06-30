<script setup>
import { defineProps } from 'vue'

const props = defineProps(['item'])
</script>

<template>
  <div class="column is-one-third has-text-centered my-5">
    <div class="new-container">
      <img :src="props.item.thumbUrl" :alt="props.item.title">
      <button class="new-delete top-right"></button>
      <p class="duration-text bottom-right">{{item.duration}}</p>
    </div>
  </div>
</template>

<style scoped>
@import '../assets/items.css';
</style>
