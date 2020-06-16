<template>
  <div
    v-bind:class="{ dark: dark }"
    style="width: 326px; top: 4px;"
    class="phone_infoBare barre-header"
  >
    <span class="time">
      <current-time style="font-size: 12px; margin-right: 2px;"></current-time>
    </span>
    <div class="batterie">
      <i class="icon fas fa-battery-full"></i>
    </div>
    <div class="barre">
      <hr class="barre1" />
      <hr class="barre2" />
      <hr class="barre3" />
      <hr class="barre4" />
    </div>
  </div>
</template>
<script>
import { mapGetters } from "vuex";
import CurrentTime from "./CurrentTime";
export default {
  props: {
    dark: false
  },
  computed: mapGetters(["config"]),
  components: {
    CurrentTime
  }
};
</script>
<style scoped lang="scss">
.barre-header {
  height: 30px;
  font-size: 17px;
  line-height: 24px;
  padding: 0px 20px 0px 24px;
  width: 100%;
  color: black;
  position: relative;

  &.dark{
    color: white;
    .barre{
      .barre1{
        background-color: rgba(255, 255, 255, 0.6);
        color: rgba(255, 255, 255, 0.6);
      }
      .barre2{
        background-color: white
      }
      .barre3{
        background-color: white;
      }
      .barre4{
        background-color: white;
      }
    }
  }

  hr {
    position: absolute;
    display: inline-block;
  }

  .barre {
    position: absolute;
    top:-17%;
    right: -2%;
    height: 24px;

    .barre1 {
      height: 12px;
      width: 3px;
      right: 53px;
      background-color: rgba(0, 0, 0, 0.6);
      color: rgba(0, 0, 0, 0.6);
      border: none;
      bottom: -1px;
    }
    .barre2 {
      height: 9px;
      width: 3px;
      right: 58px;
      background-color: rgb(0, 0, 0);
      border: none;
      bottom: -1px;
    }
    .barre3 {
      height: 6px;
      width: 3px;
      right: 63px;
      background-color: rgb(0, 0, 0);
      border: none;
      bottom: -1px;
    }
    .barre4 {
      height: 3px;
      width: 3px;
      right: 68px;
      background-color: rgb(0, 0, 0);
      border: none;
      bottom: -1px;
    }
  }

  .time {
    font-size: 12px;
    position: absolute;
    top: 15%;
    left: 9%;
    height: 24px;
    font-weight: bold;
  }

  .batterie {
    position: absolute;
    top: 0%;
    right: -4%;
    width: 50px;
    height: 24px;

    .icon {
      font-size: 12px;
    }
  }
}
</style>
