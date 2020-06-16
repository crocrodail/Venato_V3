<template>
  <div class="notifications">
     <transition-group
        name="custom-classes-transition"
        enter-active-class="animated slideInLeft"
        leave-active-class="animated slideOutRight"
      >
        <Notification :source="notif.source" :title="notif.title" :icon="notif.logo" :message="notif.message" v-for="notif in data" :key="notif.id"></Notification>
     </transition-group>
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
