<template>
  <div class="notifications">
    <Notification :source="notif.source" :title="notif.title" :icon="notif.icon" :message="notif.message" v-for="notif in data" :key="notif.id"></Notification>
  </div>
</template>

<script>
import Notification from './Notification'
export default {
  components: {
    Notification
  },
  props: {
    data: Array
  },
  data() {
    return {
      // currentCardBackground: Math.floor(Math.random() * 25 + 1), // just for fun :D
    };
  },
  mounted() {
  }
};
</script>

<style lang="scss" scoped>
</style>
