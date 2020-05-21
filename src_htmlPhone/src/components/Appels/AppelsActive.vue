<template>
  <div style="width: 326px; height: 743px;" class="phone_app">
    <div class="backblur" v-bind:style="{background: 'url(' + backgroundURL +')'}"></div>
    <InfoBare dark="true" />
    <div class="num">{{appelsDisplayNumber}}</div>
    <div class="contactName">{{appelsDisplayName}}</div>

    <div class="time"></div>
    <div class="time-display">{{timeDisplay}}</div>

    <div
      v-if="useMouse && status === 0"
      class="ignore"
      @click.stop="onIgnoreCall"
    >{{ IntlString('APP_PHONE_CALL_IGNORE')}}</div>

    <vs-row class="actionbox">
      <vs-col
        class="action raccrocher"
        :class="{disableTrue: status === 0 && select !== 0}"
        @click.stop="raccrocher"
        vs-w="3"
      >
        <i class="fas fa-phone-slash"></i>
      </vs-col>
      <vs-col
        class="action deccrocher"
        v-if="status === 0"
        :class="{disableFalse: status === 0 && select !== 1}"
        @click.stop="deccrocher"
        vs-w="3"
      >
        <i class="icon fas fa-phone-alt"></i>
      </vs-col>
    </vs-row>
  </div>
</template>

<script>
// eslint-disable-next-line
import { mapGetters, mapActions } from "vuex";
import InfoBare from "./../InfoBare";

export default {
  components: {
    InfoBare
  },
  data() {
    return {
      time: -1,
      intervalNum: undefined,
      select: -1,
      status: 0
    };
  },
  methods: {
    ...mapActions(["acceptCall", "rejectCall", "ignoreCall"]),
    onBackspace() {
      if (this.status === 1) {
        this.onRejectCall();
      } else {
        this.onIgnoreCall();
      }
    },
    onEnter() {
      if (this.status === 0) {
        if (this.select === 0) {
          this.onRejectCall();
        } else {
          this.onAcceptCall();
        }
      }
    },
    raccrocher() {
      this.onRejectCall();
    },
    deccrocher() {
      if (this.status === 0) {
        this.onAcceptCall();
      }
    },
    onLeft() {
      if (this.status === 0) {
        this.select = 0;
      }
    },
    onRight() {
      if (this.status === 0) {
        this.select = 1;
      }
    },
    updateTime() {
      this.time += 1;
    },
    onRejectCall() {
      this.rejectCall();
      this.$phoneAPI.setIgnoreFocus(false);
    },
    onAcceptCall() {
      this.acceptCall();
      this.$phoneAPI.setIgnoreFocus(true);
    },
    onIgnoreCall() {
      this.ignoreCall();
      this.$phoneAPI.setIgnoreFocus(false);
      this.$router.push({ name: 'menu' })
    },
    startTimer() {
      if (this.intervalNum === undefined) {
        this.time = 0;
        this.intervalNum = setInterval(this.updateTime, 1000);
      }
    }
  },

  watch: {
    appelsInfo() {
      if (this.appelsInfo === null) return;
      if (this.appelsInfo.is_accepts === true) {
        this.status = 1;
        this.$phoneAPI.setIgnoreFocus(true);
        this.startTimer();
      }
    }
  },

  computed: {
    ...mapGetters([
      "IntlString",
      "backgroundURL",
      "useMouse",
      "appelsInfo",
      "appelsDisplayName",
      "appelsDisplayNumber",
      "myPhoneNumber"
    ]),
    timeDisplay() {
      if (this.time < 0) {
        return ". . .";
      }
      const min = Math.floor(this.time / 60);
      let sec = this.time % 60;
      if (sec < 10) {
        sec = "0" + sec;
      }
      return `${min}:${sec}`;
    }
  },

  mounted() {
    if (this.appelsInfo !== null && this.appelsInfo.initiator === true) {
      this.status = 1;
      this.$phoneAPI.setIgnoreFocus(true);
    }
  },

  created() {
    if (!this.useMouse) {
      this.$bus.$on("keyUpEnter", this.onEnter);
      this.$bus.$on("keyUpArrowLeft", this.onLeft);
      this.$bus.$on("keyUpArrowRight", this.onRight);
    }
    this.$bus.$on("keyUpBackspace", this.onBackspace);
  },
  beforeDestroy() {
    this.$bus.$off("keyUpBackspace", this.onBackspace);
    this.$bus.$off("keyUpEnter", this.onEnter);
    this.$bus.$off("keyUpArrowLeft", this.onLeft);
    this.$bus.$off("keyUpArrowRight", this.onRight);
    if (this.intervalNum !== undefined) {
      window.clearInterval(this.intervalNum);
    }
    this.$phoneAPI.setIgnoreFocus(false);
  }
};
</script>

<style lang="scss" scoped>
.backblur {
  top: -6px;
  left: -6px;
  right: -6px;
  bottom: -6px;
  position: absolute;
  background-size: cover !important;
  filter: blur(6px);
}
.num {
  position: absolute;
  text-shadow: 0px 0px 15px black, 0px 0px 15px black;
  top: 60px;
  left: 0;
  right: 0;
  color: rgba(255, 255, 255, 0.9);
  text-align: center;
  font-size: 46px;
}
.contactName {
  position: absolute;
  text-shadow: 0px 0px 15px black, 0px 0px 15px black;
  top: 100px;
  left: 0;
  right: 0;
  color: rgba(255, 255, 255, 0.8);
  text-align: center;
  margin-top: 16px;
  font-size: 26px;
}

.time {
  position: relative;
  margin: 0 auto;
  top: 280px;
  left: 0px;
  width: 150px;
  height: 150px;
  border-top: 2px solid white;
  border-radius: 50%;
  animation: rond 1.8s infinite linear;
}
.time-display {
  text-shadow: 0px 0px 15px black, 0px 0px 15px black;
  position: relative;
  top: 187px;
  line-height: 20px;
  left: 0px;
  width: 150px;
  height: 91px;
  color: white;
  font-size: 36px;
  text-align: center;
  margin: 0 auto;
}

.actionbox {
  position: absolute;
  display: flex;
  bottom: 70px;
  left: 0;
  right: 0;
  justify-content: space-around;
  .action {
    height: 80px;
    width: 100px;
    border-radius: 50%;
    svg {
      position: relative;
      left: 20px;
      top: 20px;
      color: white;
      height: 40px;
      width: 40px;
    }
    &.raccrocher {
      background-color: #fd3d2e;
      &:hover {
        background-color: #ffffff !important;
        svg {
          color: #fd3d2e;
        }
      }
    }
    &.deccrocher {
      background-color: #4ddb62;
      &:hover {
        background-color: #ffffff !important;
        svg {
          color: #4ddb62;
        }
      }
    }
    .disableTrue {
      background-color: #fd3d2e;
    }
  }
}

.ignore {
  position: absolute;
  display: flex;
  bottom: 220px;
  height: 40px;
  line-height: 40px;
  border-radius: 20px;
  text-align: center;
  left: 0;
  right: 0;
  justify-content: space-around;
  background-color: #4d4d4d;
  width: 70%;
  left: 15%;
  color: #ccc;
  &:hover {
    background-color: #818080;
  }
}

@keyframes rond {
  from {
    rotate: 0deg;
  }
  to {
    rotate: 360deg;
  }
}
</style>
