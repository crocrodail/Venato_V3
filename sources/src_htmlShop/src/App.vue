<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
import "./style.scss";
import { mapGetters, mapActions } from "vuex";
export default {
  name: "app",
  components: {},
  data: function() {
    return {};
  },
  methods: {},
  computed: {},
  watch: {},
  created() {},
  mounted() {
    window.addEventListener("message", event => {
      if (event.data.keyUp !== undefined) {
        this.$bus.$emit("keyUp" + event.data.keyUp);
      }
    });

    window.addEventListener("keydown", event => {
      const keyValid = [
        "a",
        "e",
        "z",
        "s"
        // "ArrowUp",
        // "ArrowDown",
        // "Backspace",
        // "Enter"
      ];
      if (keyValid.indexOf(event.key) !== -1) {
        // this.$bus.$emit("keyUp" + event.key);
        $.post("http://shop/tattoo/key", JSON.stringify({ key: event.key }));
      }
    });
  },
  beforeDestroy() {}
};
</script>

<style lang="scss">
</style>
