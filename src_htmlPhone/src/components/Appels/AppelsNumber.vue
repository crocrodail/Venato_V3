<template>
  <div class="calls">
    <vs-row>
      <vs-col
        class="number"
        vs-type="flex"
        vs-justify="center"
        vs-align="start"
        vs-w="12"
      >{{ numeroFormat }}</vs-col>
    </vs-row>
    <vs-row class="keyboard">
      <vs-col
        class="key"
        v-for="(key, i) of keyInfo"
        :key="key.primary"
        :class="{'key-select': i === keySelect, 'keySpe': key.isNotNumber === true}"
        vs-w="4"
      >
        <button class="touch" @click="test()" :class="{'isActive': i === keySelect}">
          <span class="key-primary">{{key.primary}}</span>
          <span class="key-secondary">{{key.secondary}}</span>
        </button>
      </vs-col>
    </vs-row>

    <vs-row class="call">
      <div class="call-btn" :class="{'active': keySelect === 12}" @click="onPressCall">
        <svg viewBox="0 0 24 24">
          <g transform="rotate(0, 12, 12)">
            <path
              d="M6.62,10.79C8.06,13.62 10.38,15.94 13.21,17.38L15.41,15.18C15.69,14.9 16.08,14.82 16.43,14.93C17.55,15.3 18.75,15.5 20,15.5A1,1 0 0,1 21,16.5V20A1,1 0 0,1 20,21A17,17 0 0,1 3,4A1,1 0 0,1 4,3H7.5A1,1 0 0,1 8.5,4C8.5,5.25 8.7,6.45 9.07,7.57C9.18,7.92 9.1,8.31 8.82,8.59L6.62,10.79Z"
            />
          </g>
        </svg>
      </div>
    </vs-row>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import PhoneTitle from "./../PhoneTitle";
export default {
  components: {
    PhoneTitle
  },
  data() {
    return {
      numero: "",
      keyInfo: [
        { primary: "1", secondary: "" },
        { primary: "2", secondary: "abc" },
        { primary: "3", secondary: "def" },
        { primary: "4", secondary: "ghi" },
        { primary: "5", secondary: "jkl" },
        { primary: "6", secondary: "mmo" },
        { primary: "7", secondary: "pqrs" },
        { primary: "8", secondary: "tuv" },
        { primary: "9", secondary: "wxyz" },
        { primary: "-", secondary: "", isNotNumber: true },
        { primary: "0", secondary: "+" },
        { primary: "#", secondary: "", isNotNumber: true }
      ],
      keySelect: 0
    };
  },
  methods: {
    ...mapActions(["startCall"]),
    test(){
      console.log("test");
    },
    onLeft() {
      this.keySelect = Math.max(this.keySelect - 1, 0);
      console.log("Left", this.keySelect);
    },
    onRight() {
      this.keySelect = Math.min(this.keySelect + 1, 11);
      console.log("Right", this.keySelect);
    },
    onDown() {
      this.keySelect = Math.min(this.keySelect + 3, 12);
      console.log("Down", this.keySelect);
    },
    onUp() {
      if (this.keySelect > 2) {
        if (this.keySelect === 12) {
          this.keySelect = 10;
        } else {
          this.keySelect = this.keySelect - 3;
        }
      }
      console.log("Up", this.keySelect);
    },
    onEnter() {
      if (this.keySelect === 12) {
        if (this.numero.length > 0) {
          this.startCall({ numero: this.numeroFormat });
        }
      } else {
        this.numero += this.keyInfo[this.keySelect].primary;
      }
      console.log("Enter", this.keySelect);
    },
    onBackspace: function() {
      if (this.ignoreControls === true) return;
      if (this.numero.length !== 0) {
        this.numero = this.numero.slice(0, -1);
      } else {
        history.back();
      }
      console.log("Backspace", this.keySelect);
    },
    deleteNumber() {
      if (this.numero.length !== 0) {
        this.numero = this.numero.slice(0, -1);
      }
    },
    onPressKey(key) {
      this.numero += key.primary;
      console.log(this.numero);
    },
    onPressCall() {
      this.startCall({ numero: this.numeroFormat });
    },
    quit() {
      history.back();
    }

  },
  computed: {
    ...mapGetters(["IntlString", "useMouse", "useFormatNumberFrance"]),
    numeroFormat() {
      var cleaned = ('' + this.numero).replace(/\D/g, '')
      var match = cleaned.match(/^(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/)
      if (match) {
        return '' + match[1] + '-' + match[2] + '-' + match[3]+ '-' + match[4]+ '-' + match[5]
      }
      return null
    }
  },

  created() {
    if (!this.useMouse) {
      this.$bus.$on("keyUpBackspace", this.onBackspace);
      // this.$bus.$on("keyUpArrowLeft", this.onLeft);
      // this.$bus.$on("keyUpArrowRight", this.onRight);
      this.$bus.$on("keyUpArrowDown", this.onDown);
      this.$bus.$on("keyUpArrowUp", this.onUp);
      this.$bus.$on("keyUpEnter", this.onEnter);
    } else {
      this.keySelect = -1;
    }
  },
  beforeDestroy() {
    this.$bus.$off("keyUpBackspace", this.onBackspace);
    // this.$bus.$off("keyUpArrowLeft", this.onLeft);
    // this.$bus.$off("keyUpArrowRight", this.onRight);
    this.$bus.$off("keyUpArrowDown", this.onDown);
    this.$bus.$off("keyUpArrowUp", this.onUp);
    this.$bus.$off("keyUpEnter", this.onEnter);
  }
};
</script>

<style lang="scss" scoped>
.calls {
  width: 325px;
  .number {
    height: 90px;
    font-size: 35px;
    padding-top: 30px;
    line-height: 52px;
    text-align: center;
    padding-right: 8px;
    margin-bottom: 8px;
    position: relative;
  }
  .keyboard {
    .key {
      text-align: center;
      height: 96px;
      // &:hover, &.key-select {
      //   &::after {
      //     content: "";
      //     position: relative;
      //     top: -70px;
      //     left: calc(50% - 45px);
      //     display: block;
      //     width: 90px;
      //     height: 90px;
      //     background: radial-gradient(rgba(0, 0, 0, 0.04), rgba(0, 0, 0, 0.16));
      //     border-radius: 50%;
      //   }
      // }
      .touch{
        border-radius: 50%;
        width: 90%;
        height: 100%;
        background-color: transparent;
        box-shadow: none;
        border: none;
        &:hover, .isActive{
          background-color: rgba(0, 0, 0, 0.1);
        }
        .key-primary {
          display: block;
          font-size: 36px;
          color: black;
          line-height: 22px;
        }
        .key-secondary {
          text-transform: uppercase;
          display: block;
          font-size: 12px;
          color: black;
          line-height: 12px;
          padding-top: 10px;
          height: 22px;
          width: 40px;
          margin: auto;
        }
        .keySpe {
          .key-primary {
            color: #2c3e50;
            line-height: 96px;
            padding: 0;
          }
        }
      }
    }
  }
  .call {
    height: 90px;
    .call-btn {
      margin-top: -29px;
      height: 70px;
      width: 70px;
      margin: auto;
      border-radius: 50%;
      background-color: #52d66a;
      &:hover, &.active {
        background-color: #43a047;
      }
      svg {
        width: 50px;
        height: 50px;
        margin: 10px;
        fill: #eee;
      }
    }
  }
}
/*
.deleteNumber {
  display: inline-block;
  position: absolute;
  background: #2c2c2c;
  top: 16px;
  right: 12px;
  height: 18px;
  width: 32px;
  padding: 0;
}
.deleteNumber:after {
  content: "";
  position: absolute;
  left: -5px;
  top: 0;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 9px 5px 9px 0;
  border-color: transparent #2c2c2c transparent transparent;
} */
</style>
