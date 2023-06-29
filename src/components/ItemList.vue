<script setup>
import { defineProps } from 'vue'

const props = defineProps(['item'])
</script>

<template>
  <div class="column is-one-third has-text-centered my-5">
    <img :src="props.item.thumbUrl" :alt="props.item.title">
  </div>
</template>
