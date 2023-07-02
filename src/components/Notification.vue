<script setup>
import { computed } from 'vue'

const props = defineProps(['msg', 'notClass'])

const notificationClass = computed(() => {
  return props.notClass.success ? 'is-success' : (props.notClass.warn ? 'is-warning' : 'is-danger')
})
</script>

<template>
  <div class="columns is-centered ">
    <div class="column is-half not-over">
      <div class="notification" :class="notificationClass">
        <button class="delete" @click="$emit('closeNot')"></button>
        {{ props.msg }}
      </div>
    </div>
  </div>
</template>

<style scoped>
.not-over {
  position: absolute;
  top: 15px;
  left: 50%;
  transform: translate(-50%, -10%);
}
</style>
